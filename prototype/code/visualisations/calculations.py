import math


# Quaternion to euler angles conversion
def normalize(x, y, z, w):
    """Returns a normalized quaternion.
    
    Math from https://github.com/adafruit/Adafruit_BNO055/blob/master/utility/quaternion.h#L60
    """
    magnitude = math.sqrt(x * x + y * y + z * z + w * w)
    return (x / magnitude, y / magnitude, z / magnitude, w / magnitude)

def quaternion_to_euler(x, y, z, w):
    """Returns euler angles representing the input quaternion (x, y, z, w).
    
    Angles are radians in rotation order and are right-handed about the axes. Method output in degrees as yaw (euler_x), pitch (euler_y), roll (euler_z).
    
    Math from https://github.com/adafruit/Adafruit_BNO055/blob/master/utility/quaternion.h#L145
    """
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
    """Scales an input value to desired scale. 
    
    Purpose is to scale an input angle (value; negative or positive) between 0 and max_angle.
    An output is produced relative to the scale. 
    The output is clamped to the maximum scale value per default.
    """
    absolute = abs(value)
    scaled = round((absolute / max_angle) * scale)
    if clamp:
        return max(0, min(scaled, scale))
    
    return scaled


def scale_roll(roll, scale):
    return scale_value(roll, scale, 90.0)


def scale_pitch(pitch, scale):
    return scale_value(pitch, scale, 90.0)

