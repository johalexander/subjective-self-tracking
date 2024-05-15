import time
import os
import rtc
import socketpool
import wifi
import adafruit_ntp


def sync_rtc():
    wifi.radio.connect(
        os.getenv("CIRCUITPY_WIFI_SSID"), os.getenv("CIRCUITPY_WIFI_PASSWORD")
    )

    pool = socketpool.SocketPool(wifi.radio)
    ntp = adafruit_ntp.NTP(pool, tz_offset=0)

    rtc.RTC().datetime = ntp.datetime
    print("Synced timestamp:", time.time())
