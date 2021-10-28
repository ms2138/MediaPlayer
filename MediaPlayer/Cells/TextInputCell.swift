//
//  TextInputCell.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-27.
//

import Foundation

class TextInputCell: UITableViewCell {
    let stackView = UIStackView(frame: .zero)
    let textField = UITextField(frame: .zero)
    let label = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    private func setupUI() {
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)

        contentView.addSubview(stackView)
    }
}
