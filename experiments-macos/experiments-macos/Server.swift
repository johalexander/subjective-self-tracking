import Vapor
import Logging
import NIOCore
import NIOPosix

func routes(_ app: Application) throws {
    app.post("data") { req -> HTTPStatus in
        let data = try req.content.decode(SensorReading.self)
        print("Received data: \(data)")
        saveDataToFile(data)
        
        DataViewModel.sharedSingleton.markDataReceived()
        
        return .ok
    }
}

struct SensorReading: Content, Codable {
    var timestamp: TimeInterval
    var duration: Int
    var stability: String
    var activity: String
    var activity_confidence: Int
    var calibration_status: Int
    var w: Double
    var x: Double
    var y: Double
    var z: Double
}

func saveDataToFile(_ data: SensorReading) {
    let log = "\(data.timestamp),\(data.duration),\(data.stability),\(data.activity),\(data.activity_confidence),\(data.calibration_status),\(data.w),\(data.x),\(data.y),\(data.z),\n"
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
