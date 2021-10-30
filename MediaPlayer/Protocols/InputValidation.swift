//
//  InputValidation.swift
//  MediaPlayer
//
//  Created by mani on 2021-08-08.
//

import Foundation

protocol Validatable {
    associatedtype Validators

    func validate(_ functions: [Validators]) -> Bool
}

protocol Evaluatable {
    associatedtype Expression

    func evaluate(with condition: Expression) -> Bool
}
