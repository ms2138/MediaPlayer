//
//  UITextField+EXT.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-08.
//

import UIKit

extension UITextField: Validatable {
    func validate(_ functions: [(String) -> Bool]) -> Bool {
        return functions.map { $0(self.text ?? "") }.allSatisfy { $0 == true }
    }
}

extension UITextField {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true

        shake.fromValue = [self.center.x - 6, self.center.y]
        shake.toValue = [self.center.x + 6, self.center.y]
        self.layer.add(shake, forKey: "position")
    }
}
