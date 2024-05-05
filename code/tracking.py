import time
import board
import digitalio
import busio
import math
from adafruit_debouncer import Debouncer
from adafruit_bno08x.uart import BNO08X_UART
from adafruit_bno08x import BNO_REPORT_ACCELEROMETER
from adafruit_bno08x import BNO_REPORT_GYROSCOPE
from adafruit_bno08x import BNO_REPORT_MAGNETOMETER
from adafruit_bno08x import BNO_REPORT_ROTATION_VECTOR
from adafruit_bno08x import BNO_REPORT_STABILITY_CLASSIFIER
from adafruit_bno08x import BNO_REPORT_ACTIVITY_CLASSIFIER

uart = busio.UART(board.TX, board.RX, baudrate=3000000, receiver_buffer_size=2048)
bno = BNO08X_UART(uart)
bno.enable_feature(BNO_REPORT_ACCELEROMETER)
bno.enable_feature(BNO_REPORT_GYROSCOPE)
bno.enable_feature(BNO_REPORT_MAGNETOMETER)
bno.enable_feature(BNO_REPORT_ROTATION_VECTOR)
bno.enable_feature(BNO_REPORT_STABILITY_CLASSIFIER)
bno.enable_feature(BNO_REPORT_ACTIVITY_CLASSIFIER)

button_pin = digitalio.DigitalInOut(board.D13)
button_pin.direction = digitalio.Direction.INPUT
button_pin.pull = digitalio.Pull.UP
button = Debouncer(button_pin)

motor_pin = digitalio.DigitalInOut(board.D12)
motor_pin.direction = digitalio.Direction.OUTPUT

duration = 0
timestamp = 0


def calculate_angle():
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


try:
    with open("/data.csv", "a") as fp:
        while True:
            button.update()
            stability = bno.stability_classification

            activity_classification = bno.activity_classification
            activity = activity_classification["most_likely"]
            activity_confidence = activity_classification[activity]

            if button.fell:
                timestamp = time.time()
                roll, pitch, yaw = calculate_angle()
                motor_pin.value = True

            if button.rose:
                duration = int(button.last_duration * 1e3)
                motor_pin.value = False

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
                    roll,
                    "Pitch:",
                    pitch,
                    "Yaw:",
                    yaw,
                )

                fp.write(
                    "{0},{1},{2},{3},{4},{5},{6},{7}\n".format(
                        timestamp,
                        duration,
                        stability,
                        activity,
                        activity_confidence,
                        roll,
                        pitch,
                        yaw,
                    )
                )
                fp.flush()
except OSError:
    while True:
        time.sleep(0.5)
