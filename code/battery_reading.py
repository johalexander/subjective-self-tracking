import analogio
import time
import board

max_analog_val = 65535
max_battery_voltage = 4.2

battery_voltage_pin = analogio.AnalogIn(board.VOLTAGE_MONITOR)


def log_battery_voltage():
    # Read the raw value and convert to voltage
    # The multiplier adjustment (2 * 1.1 * 3.3) should matches the hardware setup
    timestamp = time.time()
    raw_value = battery_voltage_pin.value
    voltage_level = (raw_value / max_analog_val) * 2 * 1.1 * 3.3
    battery_fraction = voltage_level / max_battery_voltage
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
