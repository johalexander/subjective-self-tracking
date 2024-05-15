import time
import board
import digitalio
import busio
import analogio
import math
import sys
import sync_time
from adafruit_debouncer import Debouncer
from adafruit_bno08x.uart import BNO08X_UART
from adafruit_bno08x import BNO_REPORT_ACCELEROMETER
from adafruit_bno08x import BNO_REPORT_GYROSCOPE
from adafruit_bno08x import BNO_REPORT_MAGNETOMETER
from adafruit_bno08x import BNO_REPORT_ROTATION_VECTOR
from adafruit_bno08x import BNO_REPORT_STABILITY_CLASSIFIER
from adafruit_bno08x import BNO_REPORT_ACTIVITY_CLASSIFIER

sync_time.sync_rtc()

button_pin = digitalio.DigitalInOut(board.D13)
button_pin.direction = digitalio.Direction.INPUT
button_pin.pull = digitalio.Pull.UP
button = Debouncer(button_pin)

motor_pin = digitalio.DigitalInOut(board.D12)
motor_pin.direction = digitalio.Direction.OUTPUT

MAX_ANALOG_VAL = 65535
MAX_BATTERY_VOLTAGE = 4.2

battery_voltage_pin = analogio.AnalogIn(board.VOLTAGE_MONITOR)

write_queue = []
last_write_time = time.monotonic()
write_interval = 180


def add_to_queue(
    timestamp,
    duration,
    stability,
    activity,
    activity_confidence,
    roll,
    pitch,
    yaw,
    calibration_status,
):
    global write_queue
    write_queue.append(
        {
            "timestamp": timestamp,
            "duration": duration,
            "stability": stability,
            "activity": activity,
            "activity_confidence": activity_confidence,
            "roll": roll,
            "pitch": pitch,
            "yaw": yaw,
            "calibration_status": calibration_status,
        }
    )


def write_to_disk():
    global write_queue
    write_start = time.monotonic()
    with open("data.csv", "a") as f:
        while write_queue:
            item = write_queue.pop(0)
            f.write(
                "{0},{1},{2},{3},{4},{5},{6},{7},{8}\n".format(
                    item["timestamp"],
                    item["duration"],
                    item["stability"],
                    item["activity"],
                    item["activity_confidence"],
                    item["roll"],
                    item["pitch"],
                    item["yaw"],
                    item["calibration_status"],
                )
            )

    print("Finished writing to disk -- duration: ", time.monotonic() - write_start)


def get_battery_voltage_and_log():
    # Read the raw value and convert to voltage
    # The multiplier adjustment (2 * 1.1 * 3.3) should matches the hardware setup
    timestamp = time.time()
    raw_value = battery_voltage_pin.value
    voltage_level = (raw_value / MAX_ANALOG_VAL) * 2 * 1.1 * 3.3
    battery_fraction = voltage_level / MAX_BATTERY_VOLTAGE
    with open("battery.csv", "a") as f:
        f.write(
            "{0},{1},{2},{3}\n".format(
                timestamp,
                raw_value,
                voltage_level,
                battery_fraction,
            )
        )

        print(
            "Raw:",
            raw_value,
            "Voltage (V):",
            voltage_level,
            "Percent (%):",
            battery_fraction * 100,
        )


def initialize_bno():
    try:
        uart = busio.UART(
            board.TX, board.RX, baudrate=3000000, receiver_buffer_size=2048
        )
        bno = BNO08X_UART(uart)
        bno.enable_feature(BNO_REPORT_ACCELEROMETER)
        bno.enable_feature(BNO_REPORT_GYROSCOPE)
        bno.enable_feature(BNO_REPORT_MAGNETOMETER)
        bno.enable_feature(BNO_REPORT_ROTATION_VECTOR)
        bno.enable_feature(BNO_REPORT_STABILITY_CLASSIFIER)
        bno.enable_feature(BNO_REPORT_ACTIVITY_CLASSIFIER)
        return bno
    except RuntimeError as e:
        print(f"Failed to initialize BNO board: {e}")
        uart.deinit()
        return None


max_retries = 10
retry_count = 0

while retry_count < max_retries:
    motor_pin.value = False
    bno = initialize_bno()
    if bno is not None:
        print("BNO board initialized successfully!")
        print("Calibration status:", bno.calibration_status)
        print(
            "0 = Unreliable\n1 = Accuracy Low\n2 = Accuracy Medium\n3 = Accuracy High"
        )
        break
    print("Retrying initialization...")
    retry_count += 1
    time.sleep(2)

if bno is None:
    print(
        "Failed to initialize the BNO board after several attempts. Soft resetting..."
    )
    sys.exit()


def calculate_angle():
    """
    Method retrieves a quaternion from BNO08X and uses quaternion_to_euler to convert.
    Returns euler angles (roll, pitch, yaw) as degrees.
    """
    quaternion = bno.quaternion

    roll, pitch, yaw = quaternion_to_euler(*quaternion)

    roll_deg = math.degrees(roll)
    pitch_deg = math.degrees(pitch)
    yaw_deg = math.degrees(yaw)

    return roll_deg, pitch_deg, yaw_deg


def quaternion_to_euler(w, x, y, z):
    """
    Convert a quaternion into euler angles (roll, pitch, yaw)
    roll is rotation around x axis, pitch is rotation around y axis,
    and yaw is rotation around z axis.
    """
    # Roll (x-axis rotation)
    sinr_cosp = 2 * (w * x + y * z)
    cosr_cosp = 1 - 2 * (x ** 2 + y ** 2)
    roll = math.atan2(sinr_cosp, cosr_cosp)

    # Pitch (y-axis rotation)
    sinp = 2 * (w * y - z * x)
    if abs(sinp) >= 1:
        pitch = math.copysign(math.pi / 2, sinp)  # use 90 degrees if out of range
    else:
        pitch = math.asin(sinp)

    # Yaw (z-axis rotation)
    siny_cosp = 2 * (w * z + x * y)
    cosy_cosp = 1 - 2 * (y ** 2 + z ** 2)
    yaw = math.atan2(siny_cosp, cosy_cosp)

    return roll, pitch, yaw


duration = 0
timestamp = 0
stability = ""
activity = ""
activity_confidence = ""


while True:
    button.update()
    roll, pitch, yaw = calculate_angle()

    if button.fell:
        timestamp = time.time()

        stability = bno.stability_classification

        activity_classification = bno.activity_classification
        activity = activity_classification["most_likely"]
        activity_confidence = activity_classification[activity]

        current_roll = roll
        current_pitch = pitch
        current_yaw = yaw

        calibration_status = bno.calibration_status

        motor_pin.value = True

    if button.rose:
        motor_pin.value = False
        duration = int(button.last_duration * 1e3)

        print(
            "Timestamp:",
            timestamp,
            "Duration:",
            duration,
            "Stability:",
            stability,
            "Activity:",
            activity,
            "Activity Confidence:",
            activity_confidence,
            "Roll:",
            current_roll,
            "Pitch:",
            current_pitch,
            "Yaw:",
            current_yaw,
            "Calibration status:",
            calibration_status,
        )

        add_to_queue(
            timestamp,
            duration,
            stability,
            activity,
            activity_confidence,
            current_roll,
            current_pitch,
            current_yaw,
            calibration_status,
        )

    if time.monotonic() - last_write_time > write_interval and button.value:
        get_battery_voltage_and_log()
        print("Writing to disk - queue size:", len(write_queue))
        write_to_disk()
        last_write_time = time.monotonic()
