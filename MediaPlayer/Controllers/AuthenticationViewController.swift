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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if sender.textColor == .red {
            if #available(iOS 13.0, *) {
                sender.textColor = .label
            } else {
                sender.textColor = .black
            }
        }
    }
}
