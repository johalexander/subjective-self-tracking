import math


# Quaternion to euler angles
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


# Scaling of input value
def scale_value(value, scale, max_angle, clamp=True):
    absolute = abs(value)
    scaled = round((absolute / max_angle) * scale)
    if clamp:
        return max(0, min(scaled, scale))
    
    return scaled


def scale_roll(roll, scale):
    return scale_value(roll, scale, 90.0)


def scale_pitch(pitch, scale):
    return scale_value(pitch, scale, 90.0)

