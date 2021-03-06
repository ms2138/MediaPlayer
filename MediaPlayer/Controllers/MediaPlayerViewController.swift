//
//  MediaPlayerViewController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-31.
//

import UIKit

class MediaPlayerViewController: UIViewController {
    let mediaPlayer: MediaPlayerView
    var url: URL {
        willSet {
            mediaPlayer.loadVideo(from: newValue)
        }
    }

    init(streamURL url: URL) {
        self.mediaPlayer = MediaPlayerView()
        self.url = url

        super.init(nibName: nil, bundle: nil)

        mediaPlayer.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mediaPlayer)

        setupConstraints()

        navigationController?.setNavigationBarHidden(true, animated: false)

        mediaPlayer.close = {
            self.navigationController?.popViewController(animated: true)
        }

        mediaPlayer.fullScreen = {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }

        loadVideoStream(for: url)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mediaPlayer.stop()

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension MediaPlayerViewController {
    // MARK: - Media Player actions

    func loadVideoStream(for url: URL) {
        mediaPlayer.loadVideo(from: url)
        mediaPlayer.mediaControlView.autoFadeOutMediaControlView(afterDelay: 4.0)
    }
}
