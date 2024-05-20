import Vapor
import Logging
import NIOCore
import NIOPosix

@MainActor
class Server {
    private var app: Application?
    private let hostname = "172.20.10.2"
    //private let hostname = "192.168.0.3"

    func start() async {
        do {
            var env = try Environment.detect()
            try LoggingSystem.bootstrap(from: &env)
            
            let app = try await Application.make(env)
            self.app = app
            try configure(app)
            app.http.server.configuration.port = 8080
            DataViewModel.sharedSingleton.port = app.http.server.configuration.port
            app.http.server.configuration.hostname = hostname
            
            // This must be called on the main thread
            let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
            app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")
            
            try await app.startup()
            DataViewModel.sharedSingleton.isRunning = true
            
            DataViewModel.sharedSingleton.ipAddress = app.http.server.configuration.hostname
        } catch {
            print("Failed to start server: \(error)")
            DataViewModel.sharedSingleton.isRunning = false
        }
    }

    func stop() {
        app?.shutdown()
        DataViewModel.sharedSingleton.isRunning = false
    }

    private func configure(_ app: Application) throws {
        try routes(app)
    }
}

func routes(_ app: Application) throws {
    app.post("data") { req -> HTTPStatus in
        let data = try req.content.decode(SensorReading.self)
        print("Received data: \(data)")
        saveDataToFile(data)
        
        let sufficientCalibration = data.calibration_status >= 2
        DataViewModel.sharedSingleton.markDataReceived(data: data, sufficientCalibration: sufficientCalibration)
        
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
