import time

write_queue = []


def add_to_queue(
    timestamp,
    duration,
    stability,
    activity,
    activity_confidence,
    roll,
    pitch,
    yaw,
    calibration_status,
):
    global write_queue
    write_queue.append(
        {
            "timestamp": timestamp,
            "duration": duration,
            "stability": stability,
            "activity": activity,
            "activity_confidence": activity_confidence,
            "roll": roll,
            "pitch": pitch,
            "yaw": yaw,
            "calibration_status": calibration_status,
        }
    )

    print(
        "Timestamp:",
        timestamp,
        "Duration:",
        duration,
        "Stability:",
        stability,
        "Activity:",
        activity,
        "Activity Confidence:",
        activity_confidence,
        "Roll:",
        roll,
        "Pitch:",
        pitch,
        "Yaw:",
        yaw,
        "Calibration status:",
        calibration_status,
    )


def write_to_disk():
    global write_queue
    print("Writing to disk - queue size:", len(write_queue))
    write_start = time.monotonic()
    with open("data.csv", "a") as f:
        while write_queue:
            item = write_queue.pop(0)
            f.write(
                "{0},{1},{2},{3},{4},{5},{6},{7},{8}\n".format(
                    item["timestamp"],
                    item["duration"],
                    item["stability"],
                    item["activity"],
                    item["activity_confidence"],
                    item["roll"],
                    item["pitch"],
                    item["yaw"],
                    item["calibration_status"],
                )
            )

    print("Finished writing to disk -- duration: ", time.monotonic() - write_start)
