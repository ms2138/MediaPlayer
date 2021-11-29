//
//  FilesViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-30.
//

import UIKit
import AHDownloadButton

class FilesViewController: UITableViewController {
    var smbClient: SMB2Client
    var paths: [String]?
    var share: String?
    var files = [File]()
    var downloadAccessoryButtons = [Int: AHDownloadButton]()

    init(style: UITableView.Style, smbClient: SMB2Client) {
        self.smbClient = smbClient

        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = paths?.last {
            navigationItem.title = path
        } else {
            navigationItem.title = share
        }

        if (files.count == 0) {
            guard let paths = paths else { return }

            let path = paths.joined(separator: "/")
            loadFiles(atPath: path)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        smbClient.cancelAllDownloads()
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

            if let button = downloadAccessoryButtons[indexPath.row] {
                cell.accessoryView = button
            } else {
                let downloadButton = AHDownloadButton()
                downloadButton.frame = CGRect(x: 0, y: 0, width: 44, height: 24)
                downloadButton.downloadedButtonTitleSidePadding = 8.0
                downloadButton.downloadingButtonCircleLineWidth = 2.0
                downloadButton.didTapDownloadButtonAction = { button, state in
                    self.downloadFile(button: button, state: state)
                }

                downloadAccessoryButtons[indexPath.row] = downloadButton
                cell.accessoryView = downloadButton
            }
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
            filesViewController.share = share
            filesViewController.smbClient = smbClient

            navigationController?.pushViewController(filesViewController, animated: true)

        } else {
            let path = NSString(string: file.path)
            switch path.pathExtension {
                case "mkv", "mp4", "avi", "mpg", "wmv":
                    guard let share = share else { return }
                    var urlComponents = URLComponents()
                    urlComponents.scheme = self.smbClient.url.scheme
                    urlComponents.host = self.smbClient.url.host
                    urlComponents.user = self.smbClient.credential.user
                    urlComponents.password = self.smbClient.credential.password
                    urlComponents.path = "/" + [share, file.path].joined(separator: "/")

                    if let authorizedStream = urlComponents.url {
                        let mediaPlayerViewController = MediaPlayerViewController(streamURL: authorizedStream)
                        mediaPlayerViewController.hidesBottomBarWhenPushed = true

                        navigationController?.pushViewController(mediaPlayerViewController, animated: true)
                    }
                default:
                    break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FilesViewController {
    // MARK: - File operations

    func downloadFile(button: AHDownloadButton, state: AHDownloadButton.State) {
        let pointInTable: CGPoint = button.convert(button.bounds.origin, to: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: pointInTable) {

            let file = files[indexPath.row]
            switch state {
                case .startDownload:
                    if let filename = file.path.split(separator: "/").compactMap({ String($0) }).last {
                        let fileUrl = FileManager.default.pathToFile(filename: filename)

                        button.state = .pending

                        smbClient.downloadItem(atPath: file.path, to: fileUrl, progress: { (one, two) in
                            let progress = CGFloat((Double(one) / Double(two)))

                            DispatchQueue.main.async {
                                button.progress = progress
                                button.state = .downloading
                            }
                        }, completion: { (error, state) in
                            if (state == .cancelled) {
                                button.state = .startDownload
                            } else {
                                button.state = .downloaded
                            }
                        })
                    }
                case .pending:
                    break
                case .downloading:
                    self.smbClient.cancelDownload(atPath: file.path)
                case .downloaded:
                    self.openFile(sender: button)

            }
        }
    }

    func openFile(sender: AHDownloadButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: pointInTable) {
            let file = files[indexPath.row]

            let pathToFile = FileManager.default.pathToFile(filename: file.name)

            let mediaPlayerViewController = MediaPlayerViewController(streamURL: pathToFile)
            mediaPlayerViewController.hidesBottomBarWhenPushed = true

            navigationController?.pushViewController(mediaPlayerViewController, animated: true)

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
