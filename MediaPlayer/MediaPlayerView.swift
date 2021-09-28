//
//  MediaPlayerView.swift
//  MediaPlayer
//
//  Created by mani on 2021-09-27.
//

import UIKit

class MediaPlayerView: UIView {
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let mediaView = UIView(frame: .zero)
    private let mediaPlayer = VLCMediaPlayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .white

        mediaView.isUserInteractionEnabled = false
        mediaView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(mediaView)
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mediaView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mediaView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])

        mediaPlayer.drawable = mediaView
    }
}
