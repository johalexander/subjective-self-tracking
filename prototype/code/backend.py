import adafruit_connection_manager
import wifi
import adafruit_requests
import adafruit_ntp
import socketpool
import time
import os
import rtc

DATA_POST_URL = "http://172.20.10.2:8080/data"


pool = adafruit_connection_manager.get_radio_socketpool(wifi.radio)
ssl_context = adafruit_connection_manager.get_radio_ssl_context(wifi.radio)
requests = adafruit_requests.Session(pool, ssl_context)


def send_data(
    timestamp,
    duration,
    stability,
    activity,
    activity_confidence,
    calibration_status,
    w,
    x,
    y,
    z,
):
    body = {
        "timestamp": timestamp,
        "duration": duration,
        "stability": stability,
        "activity": activity,
        "activity_confidence": activity_confidence,
        "calibration_status": calibration_status,
        "w": w,
        "x": x,
        "y": y,
        "z": z,
    }

    with requests.post(DATA_POST_URL, data=body) as response:
        print("Status code (/data):", response.status_code)
        response.close()


def sync_rtc():
    try:
        wifi.radio.connect(
            os.getenv("CIRCUITPY_WIFI_SSID"), os.getenv("CIRCUITPY_WIFI_PASSWORD")
        )

        pool = socketpool.SocketPool(wifi.radio)
        ntp = adafruit_ntp.NTP(pool, tz_offset=0)

        rtc.RTC().datetime = ntp.datetime
        print("Synced timestamp:", time.time())
    except OSError as e:
        print("Failed to sync local time.", e)
