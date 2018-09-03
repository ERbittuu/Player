//
//  CompactMusicPlayerVC.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import UIKit
import AVFoundation
import AVFoundation
import MediaPlayer

class FullScreenPlayer: UIViewController {

    @IBOutlet fileprivate weak var rewindButton: UIButton?
    @IBOutlet fileprivate weak var playPauseButton: UIButton?
    @IBOutlet fileprivate weak var forwardButton: UIButton?

    @IBOutlet fileprivate weak var songLabel: UILabel?
    @IBOutlet fileprivate weak var albumLabel: UILabel?
//    @IBOutlet fileprivate weak var artistLabel            : UILabel?

    @IBOutlet fileprivate weak var currentTimeLabel: UILabel?
    @IBOutlet fileprivate weak var trackDurationLabel: UILabel?
    @IBOutlet fileprivate weak var timeSlider: UISlider?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        timeSlider?.setThumbImage(#imageLiteral(resourceName: "round"), for: UIControlState())
        initPlaybackTimeViews()
        updateButtonStates()

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

}

// MARK: - IBActions

extension FullScreenPlayer {

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
        self.currentTimeLabel?.text = "-:-"
        self.trackDurationLabel?.text = "-:-"
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
        self.currentTimeLabel?.text = track?.displayablePlaybackTimeString() ?? "-:-"
        self.trackDurationLabel?.text = track?.displayableDurationString() ?? "-:-"
        self.timeSlider?.value = track?.currentProgress() ?? 0
    }
}
