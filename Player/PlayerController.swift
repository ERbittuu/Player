//
//  PlayerController.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerController: UIViewController {

    var audios: [Audio]?
    var singleSong: Bool = false
    
    @IBOutlet weak var repeateButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var progressSong: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioPlayer.defaultPlayer.delegate = self
    }
    
    func playSong(num: Int) {
        AudioPlayer.defaultPlayer.pause()
        AudioPlayer.index = num
        DispatchQueue.main.async {
            self.startInfoSet(for: num)
            self.progressSong.value = Float(0.0)
            self.shuffleButton.isEnabled = !self.singleSong
            self.repeateButton.isEnabled = !self.singleSong
            self.nextButton.isEnabled = !self.singleSong
            self.prevButton.isEnabled = !self.singleSong
        }
    }
    
    func startInfoSet(for num: Int) {
        let audio = audios![num]
        SongName.text = audio.title
        artistName.text = audio.artist
        progressSong.maximumValue = Float(audio.duration)
        imageThumb.image = audio.thumbnail_image!
        startTime.text = " 00:00"
        endTime.text = "00:00 "
        // autoPlay song
        DispatchQueue.global().async {
            AudioPlayer.defaultPlayer.playAudio(fromURL: URL(string: audio.url))
        }
        playPauseButton.setImage(#imageLiteral(resourceName: "MPPause"), for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.playSong(num: 0)
            let audioList = self.singleSong ? [self.audios![0]] : self.audios
            AudioPlayer.defaultPlayer.setPlayList(audioList!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func suufleClicked(_ sender: UIButton) {
    }
    
    @IBAction func repeatClicked(_ sender: UIButton) {
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        if playPauseButton.imageView?.image == #imageLiteral(resourceName: "MPPlay") {
            playPauseButton.setImage(#imageLiteral(resourceName: "MPPause"), for: UIControlState())
            AudioPlayer.defaultPlayer.play()
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "MPPlay"), for: UIControlState())
            AudioPlayer.defaultPlayer.pause()
        }
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        AudioPlayer.defaultPlayer.next()
    }
    
    @IBAction func prevClicked(_ sender: UIButton) {
        AudioPlayer.defaultPlayer.previous()
    }
    
    @IBAction func progressChanged(_ sender: UISlider, forEvent event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                // handle drag began
                AudioPlayer.defaultPlayer.pause()
                startTime.text = " \(Int(sender.value).toAudioString)"
                print(Int(sender.value).toAudioString)
                playPauseButton.setImage(#imageLiteral(resourceName: "MPPlay"), for: UIControlState())
                
            case .moved:
                // handle drag moved
                startTime.text = " \(Int(sender.value).toAudioString)"
                endTime.text = "-\((Int(AudioPlayer.defaultPlayer.currentAudio.duration) - Int(sender.value)).toAudioString) "
                
            case .ended:
                // handle drag ended
                let value = sender.value
                let time = CMTime(value: Int64(value), timescale: 1)
                AudioPlayer.defaultPlayer.seekToTime(time)
                playPauseButton.setImage(#imageLiteral(resourceName: "MPPause"), for: UIControlState())
                
                AudioPlayer.defaultPlayer.play()
                
            default:
                break
            }
        }
    }
}


extension PlayerController : AudioPlayerDelegate {
    func audioDidChangeTime(_ time: Int64) {
        //Unhide play button and hide activity indicator
//        activityIndicator.stopAnimating()
//        fullPlayerPlayPauseButton.isHidden = false
        
        let progressValue = Float(time) / Float(AudioPlayer.defaultPlayer.currentAudio.duration)
        popupItem.progress = progressValue
        
        progressSong.value = Float(time)
        
        startTime.text = " \(Int(time).toAudioString)"
        endTime.text = "-\((Int(AudioPlayer.defaultPlayer.currentAudio.duration) - Int(time)).toAudioString) "
        
    }

    func playerWillPlayNexAudio() {
        var nextIndex = AudioPlayer.index + 1
        
        if nextIndex > (AudioPlayer.defaultPlayer.currentPlayList.count - 1) {
            nextIndex = 0
        }
        playSong(num: nextIndex)
    }

    func playerWillPlayPreviousAudio() {
        var nextIndex = AudioPlayer.index - 1
        
        if nextIndex < 0 {
            nextIndex = AudioPlayer.defaultPlayer.currentPlayList.count - 1
        }
        playSong(num: nextIndex)
    }

    func receivedArtworkImage(_ image: UIImage) {

    }
}
