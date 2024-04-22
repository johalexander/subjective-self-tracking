import math

def quaternion_to_euler(w, x, y, z):
    """
    Convert a quaternion into euler angles (roll, pitch, yaw)
    roll is rotation around x axis, pitch is rotation around y axis,
    and yaw is rotation around z axis.
    """
    # Roll (x-axis rotation)
    sinr_cosp = 2 * (w * x + y * z)
    cosr_cosp = 1 - 2 * (x**2 + y**2)
    roll = math.atan2(sinr_cosp, cosr_cosp)

    # Pitch (y-axis rotation)
    sinp = 2 * (w * y - z * x)
    if abs(sinp) >= 1:
        pitch = math.copysign(math.pi / 2, sinp)  # use 90 degrees if out of range
    else:
        pitch = math.asin(sinp)

    # Yaw (z-axis rotation)
    siny_cosp = 2 * (w * z + x * y)
    cosy_cosp = 1 - 2 * (y**2 + z**2)
    yaw = math.atan2(siny_cosp, cosy_cosp)

    return roll, pitch, yaw

quaternion = bno.quaternion  # This will give you a tuple (w, x, y, z)

# Now, call the quaternion_to_euler function with the unpacked tuple
roll, pitch, yaw = quaternion_to_euler(*quaternion)

# If you want to convert the angles from radians to degrees
roll_deg = math.degrees(roll)
pitch_deg = math.degrees(pitch)
yaw_deg = math.degrees(yaw)

print("Roll:", roll_deg, "Pitch:", pitch_deg, "Yaw:", yaw_deg)
