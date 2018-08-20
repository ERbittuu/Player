//
//  MusicPlayerVC.swift
//  MusicPlayer
//
//  Created by Sanjay Shah on 16/08/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class MusicPlayerVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var playingButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelTimeGone: UILabel!
    @IBOutlet weak var labelTotalTime: UILabel!
    
    var song: Playlist?
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Player.shared.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setupUI(song: self.song!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPlayPauseAction(_ sender: UIButton) {
        if sender.isSelected {
            Player.shared.avPlayer.pause()
        }else{
            Player.shared.avPlayer.play()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func buttonPlayNextAction(_ sender: UIButton) {
        Player.shared.next()
    }
    
    @IBAction func buttonPlayPrevAction(_ sender: UIButton) {
        Player.shared.previous()
    }
    
    @IBAction func buttonShuffleSongsAction(_ sender: UIButton) {
        Player.shared.shuffleSongs()
    }
    
    @IBAction func buttonRepeatSongAction(_ sender: UIButton) {
        Player.shared.repeatSong()
    }
}

extension MusicPlayerVC {
    func setupUI(song: Playlist) {
        
        Player.shared.arrayAudio.append(song)
        
        Player.shared.currentAudioIndex = Player.shared.arrayAudio.count - 1
        
        imageView.setImage(imageURL: song.thumbURL)
        labelName.text = song.name
        labelDesc.text = song.desc
        playingButton.isSelected = true
        
        if (Player.shared.avPlayer == nil) {
            DispatchQueue.global(qos: .background).async {
                Player.shared.play()
            }
        }
    }
//    func setupAVPlayer(playlist: Playlist) {
//        DispatchQueue.global(qos: .background).async {
//            Player.shared.setup(playlist: playlist)
//        }
//    }
}

extension MusicPlayerVC: PlayerDelegate {
    func currentTimeChange() {
        let seconds = Player.shared.currentTime.seconds
        let currentTime = calculateTimeFromNSTimeInterval(seconds)
        
        labelTimeGone.text = "\(currentTime.minute):\(currentTime.second)"
        slider.value = Float(seconds)
    }
    
    func totalTime() {
        let seconds = Player.shared.totalTime.seconds
        let totalTime = calculateTimeFromNSTimeInterval(seconds)
        
        DispatchQueue.main.async {
            self.labelTotalTime.text = "\(totalTime.minute):\(totalTime.second)"
            self.slider.maximumValue = Float(seconds)
        }
    }
    
    func songChanged(playlist: Playlist) {
        setupUI(song: playlist)
    }
    
    //This returns song length
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        // let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
}

extension UIImageView {
    
    // Download image and set into given imageview
    func setImage(imageURL: String, placeholderImage: UIImage = #imageLiteral(resourceName: "temp")) {
        if imageURL != "" {
            let url = URL(string: imageURL)
            self.image = nil
            
            self.kf.indicatorType = .activity
            
            self.kf.setImage(with: url, placeholder: nil,
                             options: [.transition(.fade(1))],
                             progressBlock: nil,
                             completionHandler: nil)
        } else {
            self.image = placeholderImage
        }
    }
}
