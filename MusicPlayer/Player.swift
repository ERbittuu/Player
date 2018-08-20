//
//  Player.swift
//  MusicPlayer
//
//  Created by Sanjay Shah on 16/08/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate {
    func currentTimeChange()
    func totalTime()
    func songChanged(playlist: Playlist)
}

class Player {
    
    var avPlayer:AVPlayer!
    var avAsset: AVAsset!
    var avPlayerItem: AVPlayerItem!
    
    var currentTime: CMTime!
    var totalTime: CMTime!
    
    var arrayAudio: [Playlist]!
    var currentAudioIndex: Int!
    var isShuffleOn = false
    var isRepeatOn = false
    
    var delegate: PlayerDelegate?
    
    static let shared = Player()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play() {
        setupAVAsset(url: arrayAudio[currentAudioIndex].musicURL)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayer.play()
        updateTimer()
    }
    
    func replacePlay(url: String) {
        setupAVAsset(url: url)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
    }
    
    func setupAVAsset(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        avAsset = AVURLAsset(url: url, options: nil)
        avPlayerItem = AVPlayerItem(asset: avAsset)
        self.totalTime = avAsset.duration
        self.delegate?.totalTime()
    }
    
    func updateTimer() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (time) in
            
            if self.avPlayer.status == .readyToPlay {
                self.currentTime = Player.shared.avPlayer.currentTime()
                self.delegate?.currentTimeChange()
            }
        }
    }
    
    func next() {
        currentAudioIndex = currentAudioIndex + 1
        
        guard arrayAudio.count != currentAudioIndex else {
            currentAudioIndex = currentAudioIndex - 1
            return
        }
        
        DispatchQueue.main.async {
            self.replacePlay(url: self.arrayAudio[self.currentAudioIndex].musicURL)
        }
    }
    
    func previous() {
        currentAudioIndex = currentAudioIndex - 1
        
        guard currentAudioIndex >= 0 else {
            currentAudioIndex = currentAudioIndex + 1
            return
        }
        
        DispatchQueue.main.async {
            self.replacePlay(url: self.arrayAudio[self.currentAudioIndex].musicURL)
        }
    }
    
    func shuffleSongs() {
        isShuffleOn = true
        self.arrayAudio.shuffle()
    }
    
    func repeatSong() {
        
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        guard arrayAudio.count - 1 != currentAudioIndex else {
            return
        }
        
        next()
        self.delegate?.songChanged(playlist: arrayAudio[currentAudioIndex])
    }
}
