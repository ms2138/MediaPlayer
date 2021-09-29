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

    var currentTimeLabel = UILabel()
    var totalTimeLabel   = UILabel()

    var playButton = UIButton(type: UIButton.ButtonType.custom)
    var positionSlider = UISlider()

    var isPlaying: Bool = false

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

        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        playButton.translatesAutoresizingMaskIntoConstraints = false
        positionSlider.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mainView)
        mainView.addSubview(topView)
        mainView.addSubview(bottomView)
        mainView.backgroundColor = UIColor(white: 0, alpha: 0.0)

        playButton.setImage(isPlaying ? UIImage(named: "pause") : UIImage(named: "play"),  for: .normal)
        playButton.setImage(isPlaying ? UIImage(named: "play") : UIImage(named: "pause"), for: .highlighted)

        positionSlider.maximumValue = 1.0
        positionSlider.minimumValue = 0.0
        positionSlider.value = 0.0

        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(playButton)
    }

    func setupConstraints() {

    }
}
