import time
import board
import digitalio
from adafruit_debouncer import Button

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

            if button.pressed:
                timestamp = time.time
                start = time.time

            if button.released:
                end = time.time
                duration = end - start

                fp.write("{0},{1},{2}\n".format(timestamp, duration, modality))
                fp.flush()
except OSError as e:
    while True:
        time.sleep(0.5)
