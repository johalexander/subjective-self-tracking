import time

write_queue = []


def add_to_queue(
    timestamp,
    duration,
    stability,
    activity,
    activity_confidence,
    calibration_status,
    x,
    y,
    z,
    w,
):
    global write_queue
    write_queue.append(
        {
            "timestamp": timestamp,
            "duration": duration,
            "stability": stability,
            "activity": activity,
            "activity_confidence": activity_confidence,
            "calibration_status": calibration_status,
            "x": x,
            "y": y,
            "z": z,
            "w": w,
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
        "Calibration status:",
        calibration_status,
        "x:",
        x,
        "y:",
        y,
        "z:",
        z,
        "w:",
        w,
    )


def write_to_disk():
    global write_queue
    queue_size = len(write_queue)
    write_start = time.monotonic()
    with open("data.csv", "a") as f:
        while write_queue:
            item = write_queue.pop(0)
            f.write(
                "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9}\n".format(
                    item["timestamp"],
                    item["duration"],
                    item["stability"],
                    item["activity"],
                    item["activity_confidence"],
                    item["calibration_status"],
                    item["x"],
                    item["y"],
                    item["z"],
                    item["w"],
                )
            )

    print(
        "Finished writing to disk -- queue size / duration: ",
        queue_size,
        time.monotonic() - write_start,
    )
