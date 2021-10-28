//
//  FileManager+EXT.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-22.
//

import Foundation

extension FileManager {
    func pathToFile(filename name: String) -> URL {
        let documentDirectories = self.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(name)
    }
}
