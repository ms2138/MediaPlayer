//
//  LibraryViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-27.
//

import UIKit

class LibraryViewController: UITableViewController {
    private let reuseIdentifier = "MediaCell"

    var media = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Media"
    }
}

extension LibraryViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let filename = media[indexPath.row]

        cell.textLabel?.text = filename.lastPathComponent
        cell.imageView?.image = UIImage(systemName: "film")

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let file = media.remove(at: indexPath.row)
            let fileURL = FileManager.default.pathToFile(filename: file.lastPathComponent)
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                debugLog("Failed to delete \(fileURL)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
