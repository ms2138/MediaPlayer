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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
