import time
import board
import digitalio
import battery_reading
import on_disk_storage
import bno_initializer
import backend
import supervisor
import math
from adafruit_debouncer import Debouncer

button_pin = digitalio.DigitalInOut(board.D13)
button_pin.direction = digitalio.Direction.INPUT
button_pin.pull = digitalio.Pull.UP
button = Debouncer(button_pin)

backend.sync_rtc()
bno = bno_initializer.init()

last_write_time = time.monotonic()
write_interval = 180


def process_data(
    timestamp,
    duration,
    stability,
    activity,
    activity_confidence,
    calibration_status,
    quaternion,
):
    on_disk_storage.add_to_queue(
        timestamp,
        duration,
        stability,
        activity,
        activity_confidence,
        calibration_status,
        *quaternion,
    )

    backend.send_data(
        timestamp,
        duration,
        stability,
        activity,
        activity_confidence,
        calibration_status,
        *quaternion,
    )
    
def normalize(x, y, z, w):
    magnitude = math.sqrt(x * x + y * y + z * z + w * w)
    return (x / magnitude, y / magnitude, z / magnitude, w / magnitude)

def quaternion_to_euler(x, y, z, w):
    x, y, z, w = normalize(x, y, z, w)
    
    sqw = w * w
    sqx = x * x
    sqy = y * y
    sqz = z * z

    euler_x = math.atan2(2.0 * (x * y + z * w), (sqx - sqy - sqz + sqw))
    euler_y = math.asin(-2.0 * (x * z - y * w) / (sqx + sqy + sqz + sqw))
    euler_z = math.atan2(2.0 * (y * z + x * w), (-sqx - sqy + sqz + sqw))

    return (math.degrees(euler_x), math.degrees(euler_y), math.degrees(euler_z))


while True:
    if supervisor.runtime.serial_bytes_available:
        break

    if bno is None:
        supervisor.reload()
        break

    try:
        button.update()
        quaternion = bno.quaternion

        if button.fell:
            timestamp = time.time()

            stability = bno.stability_classification

            activity_classification = bno.activity_classification
            activity = activity_classification["most_likely"]
            activity_confidence = activity_classification[activity]

            calibration_status = bno.calibration_status

        if button.rose:
            duration = int(button.last_duration * 1e3)

            if duration > 15000:
                supervisor.reload()

            process_data(
                timestamp,
                duration,
                stability,
                activity,
                activity_confidence,
                calibration_status,
                quaternion,
            )
            
            x, y, z, w = quaternion
            heading, roll, pitch = quaternion_to_euler(x, y, z, w)
            print(roll, pitch)

        if time.monotonic() - last_write_time > write_interval and button.value:
            battery_reading.log_battery_voltage()
            on_disk_storage.write_to_disk()
            last_write_time = time.monotonic()

        time.sleep(0.02)
    except OSError as e:
        print(f"OSError: BNO board failure: {e}")
        supervisor.reload()
    except RuntimeError as e:
        print(f"RuntimeError: BNO board failure: {e}")
        supervisor.reload()
    except Exception as e:
        print(f"Unexpected error: Failed to initialize BNO board: {e}")
        supervisor.reload()


