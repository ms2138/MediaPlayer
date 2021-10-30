//
//  AuthenticationViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-27.
//

import UIKit

class AuthenticationViewController: UITableViewController {
    var serverCell: TextInputCell!
    var usernameCell: TextInputCell!
    var passwordCell: TextInputCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AuthenticationViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
