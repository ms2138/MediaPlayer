//
//  FilesViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-30.
//

import UIKit

class FilesViewController: UITableViewController {
    var smbClient: SMB2Client
    var files = [File]()

    init(style: UITableView.Style, smbClient: SMB2Client) {
        self.smbClient = smbClient

        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FilesViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") ?? UITableViewCell(style: .subtitle,
                                                                                                reuseIdentifier: "FileCell")

        let file = files[indexPath.row]

        if file.isDirectory == true {
            cell.imageView?.image = UIImage(systemName: "folder")
        } else {
            cell.imageView?.image = UIImage(systemName: "doc")
            cell.detailTextLabel?.text = ByteCountFormatter.string(fromByteCount: file.size, countStyle: .file)

            let accessoryButton = UIButton(type: .custom)
            accessoryButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
            accessoryButton.addTarget(self, action: #selector(downloadFile), for: .touchUpInside)
            accessoryButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            accessoryButton.contentMode = .scaleAspectFit

            cell.accessoryView = accessoryButton as UIView
        }

        cell.textLabel?.text = file.name

        return cell
    }
}

extension FilesViewController {
    @objc func downloadFile(sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        if let index = tableView.indexPathForRow(at: pointInTable) {

            let file = files[index.row]

            if let filename = file.path.split(separator: "/").compactMap({ String($0) }).last {
                let fileUrl = FileManager.default.pathToFile(filename: filename)

                let hashValue = smbClient.downloadItem(atPath: file.path, to: fileUrl, progress: { (one, two) in
                    let progress = Int((Double(one) / Double(two)) * 100)

                    debugLog("Progress \(progress)")
                }, completion: { [weak self] (error) in
                    debugLog("Error \(error)")
                })
            }
        }
    }
}
