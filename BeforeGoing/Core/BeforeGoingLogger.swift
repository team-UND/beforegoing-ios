//
//  Logger.swift
//  BeforeGoing
//
//  Created by APPLE on 9/11/25.
//

import OSLog

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let data = OSLog(subsystem: subsystem, category: "Data")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

enum LogLevel {
    
    case network
    case data
    case error(error: Error)
    
    var category: String {
        switch self {
        case .network:
            "Network"
        case .data:
            "Data"
        case .error:
            "Error"
        }
    }
    
    var osLog: OSLog {
        switch self {
        case .network:
                .network
        case .data:
                .data
        case .error:
                .error
        }
    }
    
    var osLogType: OSLogType {
        switch self {
        case .network, .data:
                .default
        case .error:
                .error
        }
    }
}

struct BeforeGoingLogger {
    static let dateFormatter = DateFormatter()
    static var date: String {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    private static func log(
        level: LogLevel,
        message: Any,
        file: String,
        function: String
    ) {
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message)"
        let fileName = (file as NSString).lastPathComponent
    
        switch level {
        case .network:
            logger.log("[🛜 Network] [Date: \(date)] [\(fileName) -> \(function)]: \(logMessage)")
        case .data:
            logger.info("[📊 Data] [Date: \(date)] [\(fileName) -> \(function)]: \(logMessage)")
        case .error(let error):
            logger.error("[❌ Error] [Date: \(date)] [\(fileName) -> \(function)]: \(error.localizedDescription)")
        }
    }
    
    static func network(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .network, message: message, file: file, function: function)
    }
    
    static func data(
        _ message: Any,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .data, message: message, file: file, function: function)
    }
    
    static func error(
        _ error: Error,
        file: String = #file,
        function: String = #function
    ) {
        log(level: .error(error: error), message: "", file: file, function: function)
    }
}
