//
//  Validator.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-08.
//

import Foundation

class Validator {
    func isIPAddressValid(text: String) -> Bool {
        let regexp = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        return text.evaluate(with: regexp)
    }

    func isPortNumberValid(text: String) -> Bool {
        let regexp = "^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
        return text.evaluate(with: regexp)
    }
    
    func isUsernameValid(text: String) -> Bool {
        let regexp = "^[a-zA-Z0-9]+$"
        return text.evaluate(with: regexp)
    }
}
