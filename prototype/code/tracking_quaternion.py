import time
import board
import digitalio
import sync_time
import battery_reading
import on_disk_storage
import bno_initializer
import backend
import supervisor
from adafruit_debouncer import Debouncer

button_pin = digitalio.DigitalInOut(board.D13)
button_pin.direction = digitalio.Direction.INPUT
button_pin.pull = digitalio.Pull.UP
button = Debouncer(button_pin)

motor_pin = digitalio.DigitalInOut(board.D12)
motor_pin.direction = digitalio.Direction.OUTPUT
motor_pin.value = False

sync_time.sync_rtc()
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


while True:
    if supervisor.runtime.serial_bytes_available:
        break

    if bno is None:
        break

    button.update()
    quaternion = bno.quaternion

    if button.fell:
        timestamp = time.time()

        stability = bno.stability_classification

        activity_classification = bno.activity_classification
        activity = activity_classification["most_likely"]
        activity_confidence = activity_classification[activity]

        calibration_status = bno.calibration_status

        motor_pin.value = True

    if button.rose:
        motor_pin.value = False
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

    if time.monotonic() - last_write_time > write_interval and button.value:
        battery_reading.log_battery_voltage()
        on_disk_storage.write_to_disk()
        last_write_time = time.monotonic()

    time.sleep(0.02)
