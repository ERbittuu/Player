//
//  MiniPlayerController.swift
//  GTHubPlay
//
//  Created by Utsav Patel on 8/29/18.
//  Copyright © 2018 GTHub. All rights reserved.
//

import UIKit
import LNPopupController
import AVFoundation
import MediaPlayer
import Kingfisher

class MiniPlayer: LNPopupCustomBarViewController {

    @IBOutlet fileprivate weak var rewindButton: UIButton?
    @IBOutlet fileprivate weak var playPauseButton: UIButton?
    @IBOutlet fileprivate weak var forwardButton: UIButton?

    @IBOutlet fileprivate weak var songLabel: UILabel?
    @IBOutlet fileprivate weak var albumLabel: UILabel?

    @IBOutlet fileprivate weak var timeSlider: UISlider?
    @IBOutlet fileprivate weak var thumbImage: UIImageView?
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView?

    override var wantsDefaultPanGestureRecognizer: Bool {
        get {
            return false
        }
    }

    var changeManually = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider?.setThumbImage(#imageLiteral(resourceName: "round"), for: UIControlState())

        self.initPlaybackTimeViews()
        self.updateButtonStates()

        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            self?.updateButtonStates()
            self?.updateSongInformation(with: track)
        })
        // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in

            self?.updatePlaybackTime(track)
        })

        clipCheck()
        preferredContentSize = CGSize(width: -1, height: 65)
        refreshAll()
    }

    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAll()
    }

    func refreshAll() {
        updateButtonStates()
        updatePlaybackTime(AudioPlayerManager.shared.currentTrack)
        updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
    }

    override func popupItemDidUpdate() {}

    func clipCheck() {
        self.navigationController?.view.clipsToBounds = false
        self.view.clipsToBounds = false
        containingPopupBar.clipsToBounds = false

        DispatchQueue.main.async {
            for view in self.containingPopupBar.subviews {
                view.backgroundColor = UIColor.clear
            }
        }
    }
}

// MARK: - IBActions

extension MiniPlayer {

    @IBAction func didPressRewindButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.rewind()
    }

    @IBAction func didPressPlayPauseButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.togglePlayPause()
    }

    @IBAction func didPressForwardButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.forward()
    }

    @IBAction func didChangeTimeSliderValue(_ sender: UISlider, forEvent event: UIEvent) {
        guard let newProgress = self.timeSlider?.value else {
            AudioPlayerManager.shared.currentTrack?.showLoder = true
            play()
            self.changeManually = false
            return
        }///
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.changeManually = true
                AudioPlayerManager.shared.currentTrack?.showLoder = true
                AudioPlayerManager.shared.pause()
                self.playPauseButton?.isSelected = false
            case .moved:
                break
            default:
                seekPlayer(newProgress: newProgress)
            }
        }
    }

    func play() {
        self.playPauseButton?.isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AudioPlayerManager.shared.play()
            self.changeManually = false
        }
    }

    func seekPlayer(newProgress: Float) {
        AudioPlayerManager.shared.seek(toProgress: newProgress)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AudioPlayerManager.shared.currentTrack?.showLoder = true
            self.play()
        }
    }

    func initPlaybackTimeViews() {
        self.timeSlider?.value = 0
        self.timeSlider?.maximumValue = 1.0
        self.indicator?.stopAnimating()
    }

    func updateButtonStates() {
        self.rewindButton?.isEnabled = AudioPlayerManager.shared.canRewind()
        self.playPauseButton?.isSelected = AudioPlayerManager.shared.isPlaying()
        self.playPauseButton?.isEnabled = AudioPlayerManager.shared.canPlay()
        self.forwardButton?.isEnabled = AudioPlayerManager.shared.canForward()
    }

    func updateSongInformation(with track: AudioTrack?) {
        self.songLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String) ?? "-")"
        self.albumLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] as? String) ?? "-")"
        // self.artistLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyArtist] as? String) ?? "-")"
        self.updatePlaybackTime(track)

        // music image
        if let trackData = track,
            let info = trackData as? AudioURLTrack {

            self.playPauseButton?.isHidden = trackData.showLoder

            if trackData.showLoder {
                self.indicator?.startAnimating()
            } else {
                self.indicator?.stopAnimating()
            }

            if let image = info.audioInfo?.image {
                self.thumbImage?.image = image
            } else {
                self.thumbImage?.kf.setImage(with: info.audioInfo?.thumbnailImageUrl, placeholder: #imageLiteral(resourceName: "ArtPlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    info.audioInfo?.image = image
                    self.thumbImage?.image = image
                })
            }
        }
    }

    func updatePlaybackTime(_ track: AudioTrack?) {
        if changeManually {
            return
        }
        if let trackData = track, !trackData.showLoder {
            self.timeSlider?.value = trackData.currentProgress()
        }
    }
}
