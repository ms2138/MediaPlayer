//
//  AuthenticationViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-27.
//

import UIKit

class AuthenticationViewController: UITableViewController, UITextFieldDelegate {
    var serverCell: TextInputCell!
    var usernameCell: TextInputCell!
    var passwordCell: TextInputCell!
    let connectButtonItem = UIBarButtonItem(title: "Connect",
                                            style: .done,
                                            target: self,
                                            action: #selector(connect))
    let activityIndicatorButtonItem = UIBarButtonItem(customView: UIActivityIndicatorView(style: .medium))
    private let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Server"

        let indicator = activityIndicatorButtonItem.customView as! UIActivityIndicatorView
        indicator.hidesWhenStopped = true

        self.navigationItem.leftBarButtonItem = activityIndicatorButtonItem
        self.navigationItem.rightBarButtonItem = connectButtonItem

        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        serverCell.textField.becomeFirstResponder()
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TextInputCell(style: .default, reuseIdentifier: "InputCell")

        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        cell.textField.autocapitalizationType = .none
        cell.textField.tag = indexPath.row

        switch indexPath.row {
            case 0:
                cell.label.text = "Server"
                cell.textField.placeholder = "Server"
                cell.keyboardType = .URL
                cell.textField.returnKeyType = .next
                serverCell = cell
            case 1:
                cell.label.text = "Username"
                cell.textField.placeholder = "Username"
                cell.textField.textContentType = .username
                cell.textField.returnKeyType = .next
                usernameCell = cell
            case 2:
                cell.label.text = "Password"
                cell.textField.placeholder = "Password"
                cell.textField.textContentType = .password
                cell.textField.isSecureTextEntry = true
                cell.textField.returnKeyType = .done
                passwordCell = cell
            default:
                break
        }

        return cell
    }
}

extension AuthenticationViewController {
    @IBAction func connect() {
        if serverCell.textField.validate([validator.isIPAddressValid]) == false {
            handleTextfieldValidation(in: serverCell.textField,
                                      message: "Please enter a valid IP address")
        }

        if usernameCell.textField.validate([validator.isUsernameValid]) == false {
            handleTextfieldValidation(in: usernameCell.textField,
                                      message: "Please enter a valid username")
        }

        if let host = serverCell.textField.text,
           let username = usernameCell.textField.text, let password = passwordCell.textField.text {
            let newHost = "smb://" + host

            self.navigationItem.rightBarButtonItem?.isEnabled = true

            if let url = URL(string: newHost) {

                let credential = URLCredential(user: username, password: password, persistence: URLCredential.Persistence.forSession)

                guard let smbClient = SMB2Client(url: url, credential: credential) else { return }

                let indicator = self.navigationItem.leftBarButtonItem?.customView as! UIActivityIndicatorView
                indicator.startAnimating()

                smbClient.listShares { [unowned self] (shares, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: "Failed to connect to server") {
                                self.navigationItem.rightBarButtonItem?.isEnabled = true
                                indicator.stopAnimating()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            let sharesViewController = SharesViewController(style: .plain, smbClient: smbClient)
                            sharesViewController.shares = shares
                            self.navigationController?.pushViewController(sharesViewController, animated: true)
                            indicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}

extension AuthenticationViewController {
    // MARK: - Alerts

    func showAlert(title: String, message: String? = nil, dismiss: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            dismiss?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension AuthenticationViewController {
    // MARK: - Text field validation and changes

    func handleTextfieldValidation(in textField: UITextField, message: String) {
        textField.text = ""
        let placeholderTextColor = UIColor(red: 236.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        textField.attributedPlaceholder = NSAttributedString(string: message,
                                                             attributes:
                                                                [NSAttributedString.Key.foregroundColor: placeholderTextColor])
        textField.textColor = .red
        textField.shake()

        textField.becomeFirstResponder()
    }

    @objc func textDidChange(sender: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = (serverCell.textField.validate([validator.isIPAddressValid]) == true
                                                                && usernameCell.textField.validate([validator.isUsernameValid]) == true)

        if sender.textColor == .red {
            if #available(iOS 13.0, *) {
                sender.textColor = .label
            } else {
                sender.textColor = .black
            }
        }
    }
}

extension AuthenticationViewController {
    // MARK: - Text field delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            connect()
            return true
        } else {
            let cells = tableView.cells as! [TextInputCell]
            let cell = cells[(textField.tag + 1) % cells.count]
            cell.textField.becomeFirstResponder()
        }
        return true
    }
}
