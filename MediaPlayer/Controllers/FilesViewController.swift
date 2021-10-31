//
//  FilesViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-30.
//

import UIKit

class FilesViewController: UITableViewController {
    var smbClient: SMB2Client
    var paths: [String]?
    var files = [File]()
    private var downloadAccessoryButton: UIButton {
        let accessoryButton = UIButton(type: .custom)
        accessoryButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        accessoryButton.addTarget(self, action: #selector(downloadFile), for: .touchUpInside)
        accessoryButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        accessoryButton.contentMode = .scaleAspectFit

        return accessoryButton
    }
    private var cancelAccessoryButton: UIButton {
        let accessoryButton = UIButton(type: .roundedRect)
        accessoryButton.addTarget(self, action: #selector(cancelDownload), for: .touchUpInside)
        accessoryButton.setTitle("0%", for: .normal)
        accessoryButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        accessoryButton.contentMode = .scaleAspectFit

        return accessoryButton
    }

    init(style: UITableView.Style, smbClient: SMB2Client) {
        self.smbClient = smbClient

        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if (files.count == 0) {
            guard let paths = paths else { return }

            let path = paths.joined(separator: "/")
            loadFiles(atPath: path)
        }
    }
}

extension FilesViewController {
    func loadFiles(atPath path: String) {
        smbClient.contentsOfDirectory(atPath: path, completion: { [weak self] (listOfFiles, error) in
            guard let weakSelf = self else { return }

            if let error = error {
                debugLog("Error: \(error)")
            } else {
                let filteredFiles = listOfFiles.filter { $0.name.first != "." }.sorted(by: { $0.name < $1.name })
                weakSelf.files = filteredFiles
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                }
            }
        })
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

            cell.accessoryView = downloadAccessoryButton
        }

        cell.textLabel?.text = file.name

        return cell
    }
}

extension FilesViewController {
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]

        if (file.isDirectory == true) {
            let filesViewController = FilesViewController(style: .plain, smbClient: smbClient)
            let paths = file.path.split(separator: "/", maxSplits: 1).compactMap { String($0) }
            filesViewController.paths = paths
            filesViewController.smbClient = smbClient

            navigationController?.pushViewController(filesViewController, animated: true)

        } else {

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FilesViewController {
    // MARK: - File operations

    @objc func downloadFile(sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        if let index = tableView.indexPathForRow(at: pointInTable) {
            let cell = tableView.cellForRow(at: index)

            let file = files[index.row]

            cell?.accessoryView = cancelAccessoryButton

            if let filename = file.path.split(separator: "/").compactMap({ String($0) }).last {
                let fileUrl = FileManager.default.pathToFile(filename: filename)

                smbClient.downloadItem(atPath: file.path, to: fileUrl, progress: { (one, two) in
                    let progress = Int((Double(one) / Double(two)) * 100)

                    DispatchQueue.main.async {
                        let button = cell?.accessoryView as! UIButton
                        button.setTitle("\(progress)%", for: .normal)
                    }

                }, completion: { (error) in
                    debugLog("Error \(error)")
                })
            }
        }
    }

    @objc func cancelDownload(sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        if let index = tableView.indexPathForRow(at: pointInTable) {
            let cell = tableView.cellForRow(at: index)

            let file = files[index.row]

            smbClient.cancelDownloadItem(atPath: file.path)

            cell?.accessoryView = downloadAccessoryButton
        }

    }
}
