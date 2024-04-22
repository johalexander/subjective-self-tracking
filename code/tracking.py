import time
import board
import digitalio
import busio
from adafruit_debouncer import Button
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

pin = digitalio.DigitalInOut(board.D12)
pin.direction = digitalio.Direction.INPUT
pin.pull = digitalio.Pull.UP
button = Button(pin)

start = 0
end = 0
duration = 0
modality = 0
timestamp = 0

try:
    with open("/data.csv", "a") as fp:
        while True:
            button.update()
            stability = bno.stability_classification

            activity_classification = bno.activity_classification
            activity = activity_classification["most_likely"]
            activity_confidence = activity_classification[most_likely]

            if button.pressed:
                timestamp = time.time
                start = time.time

            if button.released:
                end = time.time
                duration = end - start

                fp.write("{0},{1},{2},{3},{4},{5}\n".format(timestamp, duration, modality, stability, activity, activity_confidence))
                fp.flush()
except OSError as e:
    while True:
        time.sleep(0.5)
