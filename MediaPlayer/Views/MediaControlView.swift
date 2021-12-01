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
        case play, pause, close, fullScreen
    }

    var mainView = UIView(frame: .zero)
    var topView = UIView(frame: .zero)
    var bottomView = UIView(frame: .zero)

    var currentTimeLabel = UILabel()
    var totalTimeLabel   = UILabel()
    var titleLabel = UILabel()

    var playButton = UIButton(type: UIButton.ButtonType.custom)
    var closeButton = UIButton(type: UIButton.ButtonType.custom)
    var fullScreenButton = UIButton(type: UIButton.ButtonType.custom)
    var positionSlider = UISlider()

    var delayItem: DispatchWorkItem?

    var isPlaying: Bool = false {
        willSet {
            playButton.setImage(newValue == true ? UIImage(named: "pause") : UIImage(named: "play"), for: .normal)
            playButton.setImage(newValue == true ? UIImage(named: "play") : UIImage(named: "pause"), for: .highlighted)
        }
    }
    var isMediaControlShown: Bool = true

    private var tapGesture: UITapGestureRecognizer!

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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        playButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        positionSlider.translatesAutoresizingMaskIntoConstraints = false

        mainView.backgroundColor = UIColor.clear

        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)

        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)

        totalTimeLabel.textColor = UIColor.white
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.font = UIFont.systemFont(ofSize: 12)
        totalTimeLabel.text = "00:00"

        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.font = UIFont.systemFont(ofSize: 12)
        currentTimeLabel.text = "00:00"

        positionSlider.maximumValue = 1.0
        positionSlider.minimumValue = 0.0
        positionSlider.value = 0.0
        positionSlider.setThumbImage(UIImage(named: "thumb"), for: .normal)

        titleLabel.text = "Title"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center

        fullScreenButton.setImage(UIImage(named: "fullscreen"), for: .normal)
        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonPressed), for: .touchUpInside)

        addSubview(mainView)
        mainView.addSubview(topView)
        mainView.addSubview(bottomView)

        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(playButton)
        bottomView.addSubview(positionSlider)

        topView.addSubview(closeButton)
        topView.addSubview(titleLabel)
        topView.addSubview(fullScreenButton)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        addGestureRecognizer(tapGesture)

        let positionSliderTapGesture = UITapGestureRecognizer(target: self, action:#selector(positionSliderTapped))
        positionSlider.addGestureRecognizer(positionSliderTapGesture)
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

            titleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: fullScreenButton.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: topView.topAnchor),

            fullScreenButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            fullScreenButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            fullScreenButton.heightAnchor.constraint(equalToConstant: 50.0),
            fullScreenButton.widthAnchor.constraint(equalToConstant: 50.0),

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
    // MARK: - Media control view action methods

    @objc func positionSliderValueChanged(sender: UISlider) {
        delegate?.mediaControlView(controlView: self, slider: positionSlider)
    }

    @objc func positionSliderTapped(sender: UIGestureRecognizer) {
        let slider = sender.view as! UISlider
        if (slider.isHighlighted) {
            return
        }
        let point = sender.location(in: slider)
        let percentage = point.x / slider.bounds.size.width;
        let delta = Float(percentage) * (slider.maximumValue - slider.minimumValue);
        let value = slider.minimumValue + delta;

        delegate?.mediaControlView(controlView: self, slider: slider, onSliderTapped: value)
    }

    @objc func playButtonPressed(sender: UIButton) {
        if (isPlaying == true) {
            delegate?.mediaControlView(controlView: self, didPerformAction: .pause)
        } else {
            delegate?.mediaControlView(controlView: self, didPerformAction: .play)
        }
        isPlaying = !isPlaying
    }

    @objc func closeButtonPressed(sender: UIButton) {
        delegate?.mediaControlView(controlView: self, didPerformAction: .close)
    }

    @objc func fullScreenButtonPressed(sender: UIButton) {
        delegate?.mediaControlView(controlView: self, didPerformAction: .fullScreen)
    }

    @objc open func onTapGesture(_ gesture: UITapGestureRecognizer) {
        animateMediaControlViewDisplay(isVisible: !isMediaControlShown)
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
                self?.autoFadeOutMediaControlView(afterDelay: 3.0)
            }
        }
    }

    func autoFadeOutMediaControlView(afterDelay delay: Double) {
        delayItem?.cancel()
        delayItem = DispatchWorkItem { [weak self] in
            self?.animateMediaControlViewDisplay(isVisible: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay,
                                      execute: delayItem!)
    }
}
