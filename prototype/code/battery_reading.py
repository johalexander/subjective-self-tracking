import analogio
import time
import board

max_analog_val = 65535
max_battery_voltage = 4.2

battery_voltage_pin = analogio.AnalogIn(board.VOLTAGE_MONITOR)


def log_battery_voltage():
    timestamp = time.time()
    raw_value = battery_voltage_pin.value
    voltage_level = (raw_value / max_analog_val) * 2 * 3.3
    battery_fraction = voltage_level / max_battery_voltage
    battery_soc = voltage_to_soc(voltage_level)
    with open("battery.csv", "a") as f:
        f.write(
            "{0},{1},{2},{3},{4}\n".format(
                timestamp,
                raw_value,
                voltage_level,
                battery_fraction * 100,
                battery_soc,
            )
        )

        print(
            "Timestamp:",
            timestamp,
            "Raw:",
            raw_value,
            "Voltage (V):",
            voltage_level,
            "Percent (%):",
            battery_fraction * 100,
            "SoC:",
            battery_soc,
        )


def voltage_to_soc(voltage):
    if voltage >= 4.2:
        return 100
    elif voltage >= 4.0:
        return 85 + (voltage - 4.0) * (100 - 85) / (4.2 - 4.0)
    elif voltage >= 3.9:
        return 75 + (voltage - 3.9) * (85 - 75) / (4.0 - 3.9)
    elif voltage >= 3.8:
        return 65 + (voltage - 3.8) * (75 - 65) / (3.9 - 3.8)
    elif voltage >= 3.7:
        return 50 + (voltage - 3.7) * (65 - 50) / (3.8 - 3.7)
    elif voltage >= 3.6:
        return 40 + (voltage - 3.6) * (50 - 40) / (3.7 - 3.6)
    elif voltage >= 3.5:
        return 30 + (voltage - 3.5) * (40 - 30) / (3.6 - 3.5)
    elif voltage >= 3.4:
        return 15 + (voltage - 3.4) * (30 - 15) / (3.5 - 3.4)
    elif voltage >= 3.3:
        return 5 + (voltage - 3.3) * (15 - 5) / (3.4 - 3.3)
    elif voltage >= 3.2:
        return (voltage - 3.2) * (5 - 0) / (3.3 - 3.2)
    else:
        return 0
