//
//  FirstController.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

    var isLocal = false
    
    var isList = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DataSource.data)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AudioPlayer.defaultPlayer.currentPlayList.count > 0 {
            openSwipePlayer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func webMusicClicked(_ sender: UIButton) {
        print(#function)
        isLocal = false
        isList = false
        self.navigationController?.dismissPopupBar(animated: true, completion: nil)
        self.performSegue(withIdentifier: "playerOpen", sender: nil)
    }
    
    var musicPlayerController : CompactMusicPlayerVC!
    
    func openSwipePlayer() {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        musicPlayerController = story.instantiateViewController(withIdentifier: "CompactMusicPlayerVC") as? CompactMusicPlayerVC
    
        self.musicPlayerController!.tracks.removeAll()
        self.musicPlayerController!.tracks.append(contentsOf: AudioPlayer.defaultPlayer.currentPlayList)
        self.musicPlayerController!.currentIndexPathRow = AudioPlayer.index
        self.navigationController?.popupBar.marqueeScrollEnabled = true
        self.navigationController?.presentPopupBar(withContentViewController: self.musicPlayerController!, animated: true, completion: nil)
    }
    
    @IBAction func localMusicClicked(_ sender: UIButton) {
        print(#function)
        isLocal = true
        isList = false
        self.navigationController?.dismissPopupBar(animated: true, completion: nil)
        self.performSegue(withIdentifier: "playerOpen", sender: nil)
    }
    
    @IBAction func playListMusicClicked(_ sender: UIButton) {
        print(#function)
        isList = true
        self.navigationController?.dismissPopupBar(animated: true, completion: nil)
        self.performSegue(withIdentifier: "playerOpen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playerOpen" {
            if let vc = segue.destination as? PlayerController {
                if isList {
                    vc.audios = DataSource.data
                    vc.singleSong = false
                } else {
                    vc.audios = isLocal ? [DataSource.data[1]] : [DataSource.data[0]]
                    vc.singleSong = true
                }
            }
        }
    }
}
