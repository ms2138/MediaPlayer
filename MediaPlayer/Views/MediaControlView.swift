//
//  MediaControlView.swift
//  MediaPlayer
//
//  Created by mani on 2021-09-27.
//

import UIKit

class MediaControlView: UIView {
    var mainView = UIView(frame: .zero)
    var topView = UIView(frame: .zero)
    var bottomView = UIView(frame: .zero)

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
        setupConstraints()
    }

    func setupUI() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {

    }
}
