//
//  MediaControlView.swift
//  MediaPlayer
//
//  Created by mani on 2021-09-27.
//

import UIKit

protocol MediaControlViewDelegate: class {
    func mediaControlView(controlView: MediaControlView, didPerformAction action: MediaControlView.Action)
    func mediaControlView(controlView: MediaControlView, slider: UISlider)
    func mediaControlView(controlView: MediaControlView, slider: UISlider, onSliderTapped position: Float)
}

class MediaControlView: UIView {
    enum Action {
        case play, pause, close
    }

    var mainView = UIView(frame: .zero)
    var topView = UIView(frame: .zero)
    var bottomView = UIView(frame: .zero)

    var currentTimeLabel = UILabel()
    var totalTimeLabel   = UILabel()

    var playButton = UIButton(type: UIButton.ButtonType.custom)
    var closeButton = UIButton(type: UIButton.ButtonType.custom)
    var positionSlider = UISlider()

    var delayItem: DispatchWorkItem?

    var isPlaying: Bool = false
    var isMediaControlShown: Bool = true

    weak var delegate: MediaControlViewDelegate?

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
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        positionSlider.translatesAutoresizingMaskIntoConstraints = false

        mainView.backgroundColor = UIColor(white: 0, alpha: 0.0)

        playButton.setImage(isPlaying ? UIImage(named: "pause") : UIImage(named: "play"),  for: .normal)
        playButton.setImage(isPlaying ? UIImage(named: "play") : UIImage(named: "pause"), for: .highlighted)

        closeButton.setImage(UIImage(named: "close"), for: .normal)

        positionSlider.maximumValue = 1.0
        positionSlider.minimumValue = 0.0
        positionSlider.value = 0.0

        addSubview(mainView)
        mainView.addSubview(topView)
        mainView.addSubview(bottomView)

        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(playButton)

        topView.addSubview(closeButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            topView.topAnchor.constraint(equalTo: mainView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50.0),

            bottomView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50.0),

            playButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            playButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50.0),
            playButton.widthAnchor.constraint(equalToConstant: 50.0),

            closeButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50.0),
            closeButton.widthAnchor.constraint(equalToConstant: 50.0),

            currentTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor),
            currentTimeLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 50.0),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 50.0),

            totalTimeLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -4.0),
            totalTimeLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            totalTimeLabel.heightAnchor.constraint(equalToConstant: 50.0),
            totalTimeLabel.widthAnchor.constraint(equalToConstant: 50.0),

            positionSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor),
            positionSlider.trailingAnchor.constraint(equalTo: totalTimeLabel.leadingAnchor),
            positionSlider.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            positionSlider.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}

extension MediaControlView {
    @objc func positionSliderValueChanged(sender: UISlider) {
        delegate?.mediaControlView(controlView: self, slider: positionSlider)
    }

    @objc func playButtonPressed(sender: UIButton) {
        isPlaying = !isPlaying
        playButton.setImage(isPlaying ? UIImage(named: "play") : UIImage(named: "pause"),  for: .normal)
        playButton.setImage(isPlaying ? UIImage(named: "pause") : UIImage(named: "play"), for: .highlighted)
        if (isPlaying == true) {
            delegate?.mediaControlView(controlView: self, didPerformAction: .pause)
        } else {
            delegate?.mediaControlView(controlView: self, didPerformAction: .play)
        }
    }

    @objc func closeButtonPressed(sender: UIButton) {
        delegate?.mediaControlView(controlView: self, didPerformAction: .close)
    }
}

extension MediaControlView {
    private func animateMediaControlViewDisplay(isVisible: Bool) {
        let alpha: CGFloat = isVisible ? 1.0 : 0.0
        isMediaControlShown = isVisible

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.topView.alpha = alpha
            weakSelf.bottomView.alpha = alpha
            weakSelf.mainView.backgroundColor = UIColor(white: 0, alpha: isVisible ? 0.2 : 0.0)
        }) { [weak self] (_) in
            if (isVisible == true) {
                self?.autoFadeOutMediaControlView()
            }
        }
    }

    func autoFadeOutMediaControlView() {
        delayItem?.cancel()
        delayItem = DispatchWorkItem { [weak self] in
            self?.animateMediaControlViewDisplay(isVisible: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0,
                                      execute: delayItem!)
    }
}
