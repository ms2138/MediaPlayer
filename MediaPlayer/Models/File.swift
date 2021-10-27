//
//  File.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-26.
//

import Foundation

struct File: Comparable {
    var name: String
    var path: String
    var created: Date
    var modified: Date
    var size: Int64
    var isDirectory: Bool

    static func < (lhs: File, rhs: File) -> Bool {
        lhs.name < rhs.name
    }

    static func > (lhs: File, rhs: File) -> Bool {
        lhs.name > rhs.name
    }
}
