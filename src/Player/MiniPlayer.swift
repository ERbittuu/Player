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

class MiniPlayer: LNPopupCustomBarViewController {

    @IBOutlet fileprivate weak var rewindButton: UIButton?
    @IBOutlet fileprivate weak var playPauseButton: UIButton?
    @IBOutlet fileprivate weak var forwardButton: UIButton?

    @IBOutlet fileprivate weak var songLabel: UILabel?
    @IBOutlet fileprivate weak var albumLabel: UILabel?
    //    @IBOutlet fileprivate weak var artistLabel            : UILabel?

//    @IBOutlet fileprivate weak var currentTimeLabel: UILabel?
//    @IBOutlet fileprivate weak var trackDurationLabel: UILabel?
    @IBOutlet fileprivate weak var timeSlider: UISlider?

    weak var fullScreenPlayer: FullScreenPlayer?

    override var wantsDefaultPanGestureRecognizer: Bool {
        get {
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider?.setThumbImage(#imageLiteral(resourceName: "round"), for: UIControlState())
        
        self.initPlaybackTimeViews()
        self.updateButtonStates()

        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            self?.fullScreenPlayer?.updateButtonStates()
            self?.fullScreenPlayer?.updateSongInformation(with: track)

            self?.updateButtonStates()
            self?.updateSongInformation(with: track)
        })
        // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            self?.fullScreenPlayer?.updatePlaybackTime(track)

            self?.updatePlaybackTime(track)
        })

        clipCheck()
        preferredContentSize = CGSize(width: -1, height: 65)
        refreshAll()
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

    override func popupItemDidUpdate() {

    }

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

    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
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

    @IBAction func didChangeTimeSliderValue(_ sender: Any) {
        guard let newProgress = self.timeSlider?.value else {
            return
        }
        AudioPlayerManager.shared.seek(toProgress: newProgress)
    }

    func initPlaybackTimeViews() {
        self.timeSlider?.value = 0
        self.timeSlider?.maximumValue = 1.0
//        self.currentTimeLabel?.text = "-:-"
//        self.trackDurationLabel?.text = "-:-"
    }

    func updateButtonStates() {
        self.rewindButton?.isEnabled = AudioPlayerManager.shared.canRewind()
        let image = (AudioPlayerManager.shared.isPlaying() == true ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "music_play"))
        self.playPauseButton?.setImage(image, for: UIControlState())
        self.playPauseButton?.isEnabled = AudioPlayerManager.shared.canPlay()
        self.forwardButton?.isEnabled = AudioPlayerManager.shared.canForward()
    }

    func updateSongInformation(with track: AudioTrack?) {
        self.songLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String) ?? "-")"
        self.albumLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] as? String) ?? "-")"
        // self.artistLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyArtist] as? String) ?? "-")"
        self.updatePlaybackTime(track)
    }

    func updatePlaybackTime(_ track: AudioTrack?) {
//        self.currentTimeLabel?.text = track?.displayablePlaybackTimeString() ?? "-:-"
//        self.trackDurationLabel?.text = track?.displayableDurationString() ?? "-:-"
        self.timeSlider?.value = track?.currentProgress() ?? 0
    }
}
