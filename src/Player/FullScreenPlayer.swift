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

    @IBOutlet fileprivate weak var currentTimeLabel: UILabel?
    @IBOutlet fileprivate weak var trackDurationLabel: UILabel?
    @IBOutlet fileprivate weak var timeSlider: UISlider?

    @IBOutlet fileprivate weak var thumbImage: UIImageView?
    @IBOutlet fileprivate weak var backImage: UIImageView?
    @IBOutlet fileprivate weak var indicator: UIActivityIndicatorView?

    @IBOutlet fileprivate weak var shufflePlayListButton: UIButton?
    @IBOutlet fileprivate weak var repeatSongButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        timeSlider?.setThumbImage(#imageLiteral(resourceName: "round"), for: UIControlState())

        backImage?.blurView.setup(style: UIBlurEffectStyle.dark, alpha: 0.9).enable()

        view.backgroundColor = UIColor.clear
        // timeSlider?.setThumbImage(#imageLiteral(resourceName: "round"), for: UIControlState())
        initPlaybackTimeViews()
        updateButtonStates()

        // Listen to the player state updates. This state is updated if the play, pause or queue state changed.
        AudioPlayerManager.shared.addPlayStateChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            self?.updateButtonStates()
            self?.updateSongInformation(with: track)
        })
        // Listen to the playback time changed. Thirs event occurs every `AudioPlayerManager.PlayingTimeRefreshRate` seconds.
        AudioPlayerManager.shared.addPlaybackTimeChangeCallback(self, callback: { [weak self] (track: AudioTrack?) in
            self?.updatePlaybackTime(track)
        })

        refreshAll()
    }
//    var changeManually = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAll()
    }

    func refreshAll() {
        updateButtonStates()
        updatePlaybackTime(AudioPlayerManager.shared.currentTrack)
        updateSongInformation(with: AudioPlayerManager.shared.currentTrack)
    }

    deinit {
        // Stop listening to the callbacks
        AudioPlayerManager.shared.removePlayStateChangeCallback(self)
        AudioPlayerManager.shared.removePlaybackTimeChangeCallback(self)
    }
}

// MARK: - IBActions

extension FullScreenPlayer {

    @IBAction func dissmissPlayer(_ sender: AnyObject) {
        if let tabBarController = self.tabBarController {
            tabBarController.popupPresentationContainer?.closePopup(animated: true, completion: nil)
            return
        }
        if let navigationController = self.navigationController {
            navigationController.popupPresentationContainer?.closePopup(animated: true, completion: nil)
            return
        }
        popupPresentationContainer?.closePopup(animated: true, completion: nil)
    }

    @IBAction func didPressRewindButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.rewind()
    }

    @IBAction func didPressPlayPauseButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.togglePlayPause()
    }

    @IBAction func didPressForwardButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.forward(fource: true)
    }

    @IBAction func didPressRepeatButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.repeatSong = !AudioPlayerManager.shared.repeatSong
    }

    @IBAction func didPressShuffleButton(_ sender: AnyObject) {
        AudioPlayerManager.shared.shufflePlayList = !AudioPlayerManager.shared.shufflePlayList
    }

    @IBAction func didChangeTimeSliderValue(_ sender: UISlider, forEvent event: UIEvent) {
        guard let newProgress = self.timeSlider?.value else {
//            AudioPlayerManager.shared.currentTrack?.showLoder = true
            play()
//            self.changeManually = false
            return
        }///
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
//                self.changeManually = true
//                AudioPlayerManager.shared.currentTrack?.showLoder = true
                AudioPlayerManager.shared.pause()
                self.playPauseButton?.isSelected = false
            case .moved:
//                if let currentTrack = AudioPlayerManager.shared.currentTrack {
//                    self.currentTimeLabel?.text = AudioTrack.displayableString(from: TimeInterval((currentTrack.durationInSeconds() ?? 0) * newProgress))
//                }
                print("changed")
            default:
                seekPlayer(newProgress: newProgress)
            }
        }
    }

    func play() {
        self.playPauseButton?.isSelected = true
        AudioPlayerManager.shared.play()
//        self.changeManually = false
    }

    func seekPlayer(newProgress: Float) {
        AudioPlayerManager.shared.seek(toProgress: newProgress)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            AudioPlayerManager.shared.currentTrack?.showLoder = true
            self.play()
        }
    }

    func initPlaybackTimeViews() {
        self.timeSlider?.value = 0
        self.timeSlider?.maximumValue = 1.0
        self.currentTimeLabel?.text = AudioTrack.Formats.durationStringForNilObject
        self.trackDurationLabel?.text = AudioTrack.Formats.durationStringForNilObject
        self.indicator?.stopAnimating()
    }

    func updateButtonStates() {
        self.rewindButton?.isEnabled = AudioPlayerManager.shared.canRewind()
        self.playPauseButton?.isSelected = AudioPlayerManager.shared.isPlaying()
        self.playPauseButton?.isEnabled = AudioPlayerManager.shared.canPlay()
        self.forwardButton?.isEnabled = AudioPlayerManager.shared.canForward()

        self.repeatSongButton?.tintColor = AudioPlayerManager.shared.repeatSong ? .white : .gray
        self.shufflePlayListButton?.tintColor = AudioPlayerManager.shared.shufflePlayList ? .white : .gray
    }

    func updateSongInformation(with track: AudioTrack?) {
        self.songLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String) ?? "-")"
        self.albumLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyAlbumTitle] as? String) ?? "-")"
        // self.artistLabel?.text = "\((track?.nowPlayingInfo?[MPMediaItemPropertyArtist] as? String) ?? "-")"
        self.updatePlaybackTime(track)

        // music image
        if let trackData = track,
            let info = trackData as? AudioURLTrack {

            self.playPauseButton?.alpha = trackData.showLoder ? 0 : 1

            if trackData.showLoder {
                self.indicator?.startAnimating()
            } else {
                self.indicator?.stopAnimating()
            }

            if let image = info.audioInfo?.image {
                self.thumbImage?.image = image
                self.backImage?.image = image
            } else {
                self.thumbImage?.kf.setImage(with: info.audioInfo?.thumbnailImageUrl, placeholder: #imageLiteral(resourceName: "ArtPlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    info.audioInfo?.image = image
                    self.thumbImage?.image = image
                    self.backImage?.image = image
                })
            }
        }
    }

    func updatePlaybackTime(_ track: AudioTrack?) {

        if let trackData = track, !trackData.showLoder {
//            if changeManually {
//                return
//            }
            self.timeSlider?.value = trackData.currentProgress()
            self.currentTimeLabel?.text = track?.displayablePlaybackTimeString() ?? AudioTrack.Formats.durationStringForNilObject
            self.trackDurationLabel?.text = track?.displayableDurationString() ?? AudioTrack.Formats.durationStringForNilObject
        }
    }
}
