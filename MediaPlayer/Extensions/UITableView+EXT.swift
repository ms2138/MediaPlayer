//
//  UITableView+EXT.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-08.
//

import Foundation

extension UITableView {
    var cells: [UITableViewCell] {
        return (0..<self.numberOfSections).map { section in
            (0..<self.numberOfRows(inSection: section)).compactMap { row in
                self.cellForRow(at: IndexPath(row: row, section: section))
            }}.flatMap { $0 }
    }
}
