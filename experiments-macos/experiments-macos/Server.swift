import Vapor
import Logging
import NIOCore
import NIOPosix

func routes(_ app: Application) throws {
    app.post("data") { req -> HTTPStatus in
        let data = try req.content.decode(DataModel.self)
        print("Received data: \(data)")
        saveDataToFile(data)
        return .ok
    }
}

struct DataModel: Content {
    var timestamp: TimeInterval
    var duration: Int
    var stability: String
    var activity: String
    var activity_confidence: Int
    var roll: Double
    var pitch: Double
    var yaw: Double
    var calibration_status: Int
}

func saveDataToFile(_ data: DataModel) {
    let log = "\(data.timestamp),\(data.duration),\(data.stability),\(data.activity),\(data.activity_confidence),\(data.roll),\(data.pitch),\(data.yaw),\(data.calibration_status)\n"
    let fileURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("data_log.txt")
    do {
        let handle = try FileHandle(forWritingTo: fileURL)
        handle.seekToEndOfFile()
        if let data = log.data(using: .utf8) {
            handle.write(data)
        }
        handle.closeFile()
    } catch {
        do {
            try log.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
}
