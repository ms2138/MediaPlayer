//
//  SMB2Client.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-26.
//

import Foundation
import AMSMB2

class SMB2Client {
    let url: URL
    let credential: URLCredential

    private var client: AMSMB2

    init?(url: URL, credential: URLCredential) {
        self.url = url
        self.credential = credential
        guard let client = AMSMB2(url: url, credential: credential) else { return nil }

        self.client = client
    }
}
