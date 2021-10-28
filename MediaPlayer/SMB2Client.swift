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
    private var activeDownloads = [Int: Bool]()

    private var client: AMSMB2

    init?(url: URL, credential: URLCredential) {
        self.url = url
        self.credential = credential
        guard let client = AMSMB2(url: url, credential: credential) else { return nil }

        self.client = client
    }
}

extension SMB2Client {
    func listShares(completion: @escaping ([Share], Error?) -> Void) {
        var shares = [Share]()
        var error: Error?

        client.listShares { result in
            switch result {
                case .success(let listOfShares):
                    for entry in listOfShares {
                        let share = Share(name: entry.name, comment: entry.comment)
                        shares.append(share)
                    }
                case .failure(let err):
                    error = err
            }
            completion(shares, error)
        }
    }

    func connectShare(name: String, completion: @escaping (Error?) -> Void) {
        client.connectShare(name: name) { error in
            completion(error)
        }
    }

    func contentsOfDirectory(atPath path: String, completion: @escaping ([File], Error?) -> Void) {
        var files = [File]()
        var error: Error?

        client.contentsOfDirectory(atPath: path) { result in
            switch result {
                case .success(let listOfFiles):
                    for entry in listOfFiles {
                        let file = File(name: entry[.nameKey] as! String,
                                        path: entry[.pathKey] as! String,
                                        created: entry[.creationDateKey] as! Date,
                                        modified: entry[.contentModificationDateKey] as! Date,
                                        size: entry[.fileSizeKey] as! Int64,
                                        isDirectory: entry[.isDirectoryKey] as! Bool
                        )
                        files.append(file)
                    }
                case .failure(let err):
                    error = err

            }

            completion(files, error)
        }
    }

    func downloadItem(atPath path: String, to url: URL, progress: @escaping (Int64, Int64) -> Void, completion: @escaping (Error) -> Void) -> Int {
        let hashValue = path.hashValue

        activeDownloads[hashValue] = true

        let progress = AMSMB2.ReadProgressHandler.init { [weak self] (one, two) -> Bool in
            progress(one, two)

            return self?.activeDownloads[hashValue] ?? false
        }

        client.downloadItem(atPath: path, to: url, progress: progress) { [weak self] (error) in
            guard let weakSelf = self else { return }

            if let isDownloading = weakSelf.activeDownloads[hashValue], isDownloading == false {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("Failed to delete")
                }
            }

            weakSelf.activeDownloads.removeValue(forKey: hashValue)
        }

        return hashValue
    }

}
