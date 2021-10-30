//
//  Logging.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-07.
//

import Foundation

public func debugLog<T>(_ object: @autoclosure () -> T, _ file: String = #file,
                        _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let value = object()
    let filename = URL(string: file)?.lastPathComponent ?? "Unknown file"
    let queue = Thread.isMainThread ? "UI" : "BG"

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = formatter.string(from: date)

    print("\(timestamp) {\(queue)} \(filename) \(function)[\(line)]: " + String(reflecting: value))
    #endif
}
