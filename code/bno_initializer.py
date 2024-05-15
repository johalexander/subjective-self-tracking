import busio
import board
import time
import sys
from adafruit_bno08x.uart import BNO08X_UART
from adafruit_bno08x import BNO_REPORT_ACCELEROMETER
from adafruit_bno08x import BNO_REPORT_GYROSCOPE
from adafruit_bno08x import BNO_REPORT_MAGNETOMETER
from adafruit_bno08x import BNO_REPORT_ROTATION_VECTOR
from adafruit_bno08x import BNO_REPORT_STABILITY_CLASSIFIER
from adafruit_bno08x import BNO_REPORT_ACTIVITY_CLASSIFIER

max_retries = 10
retry_count = 0


def init():
    global max_retries
    global retry_count
    while retry_count < max_retries:
        bno = __initialize_bno()
        if bno is not None:
            print("BNO board initialized successfully!")
            print("Calibration status:", bno.calibration_status)
            print(
                "0 = Unreliable\n1 = Accuracy Low",
                "\n2 = Accuracy Medium\n3 = Accuracy High",
            )
            break
        print("Retrying initialization...")
        retry_count += 1
        time.sleep(2)

    if bno is None:
        print("Failed to initialize the BNO board after several attempts...")
        sys.exit()

    return bno


def __initialize_bno():
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
