//
//  String+EXT.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-05.
//

import Foundation

extension String: Evaluatable {
    func evaluate(with condition: String) -> Bool {
        guard let range = range(of: condition, options: .regularExpression, range: nil, locale: nil) else {
            return false
        }

        return range.lowerBound == startIndex && range.upperBound == endIndex
    }
}
