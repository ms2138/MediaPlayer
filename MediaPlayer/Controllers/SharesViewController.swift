//
//  SharesViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-30.
//

import UIKit

class SharesViewController: UITableViewController {
    private let reuseIdentifier = "ShareCell"

    var shares = [Share]()
    var smbClient: SMB2Client

    init(style: UITableView.Style, smbClient: SMB2Client) {
        self.smbClient = smbClient

        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        if (shares.count == 0) {
            loadShares()
        }
    }
}

extension SharesViewController {
    func loadShares() {
        smbClient.listShares { [unowned self] (shares, error) in
            DispatchQueue.main.async {
                let sharesViewController = SharesViewController(style: .plain, smbClient: smbClient)
                sharesViewController.shares = shares
                self.navigationController?.pushViewController(sharesViewController, animated: true)
            }
        }
    }
}

extension SharesViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shares.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let share = shares[indexPath.row]

        cell.imageView?.image = UIImage(systemName: "folder")
        cell.textLabel?.text = share.name

        return cell
    }
}

extension SharesViewController {
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let share = shares[indexPath.row]

        smbClient.connectShare(name: share.name, completion: { [weak self] (error) in
            guard let weakSelf = self else { return }

            if let error = error {
                debugLog("Error: \(error)")
            } else {
                DispatchQueue.main.async {
                    let filesViewController = FilesViewController(style: .plain, smbClient: weakSelf.smbClient)

                    filesViewController.paths = [String]()
                    filesViewController.smbClient = weakSelf.smbClient

                    weakSelf.navigationController?.pushViewController(filesViewController, animated: true)
                }
            }
        })

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
