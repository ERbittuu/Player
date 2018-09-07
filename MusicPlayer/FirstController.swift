//
//  FirstController.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

    var fullScreenPlayer: FullScreenPlayer {
        let story = UIStoryboard(name: "Main", bundle: nil)
        return story.instantiateViewController(withIdentifier: "FullScreenPlayer") as! FullScreenPlayer
    }

    var miniPlayer: MiniPlayer {
        let story = UIStoryboard(name: "Main", bundle: nil)
        return story.instantiateViewController(withIdentifier: "MiniPlayer") as! MiniPlayer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioPlayerManager.shared.setup()
    }

    func openSwipePlayer() {

        if let tabBarController = self.tabBarController {
            tabBarController.popupBar.customBarViewController = miniPlayer
            tabBarController.popupContentView.popupCloseButtonStyle = .none
            tabBarController.popupInteractionStyle = .snap
            tabBarController.presentPopupBar(withContentViewController: fullScreenPlayer, animated: true, completion: nil)
            return
        }
        if let navigationController = self.navigationController {
            navigationController.popupBar.customBarViewController = miniPlayer
            navigationController.popupContentView.popupCloseButtonStyle = .none
            navigationController.popupInteractionStyle = .snap
            navigationController.presentPopupBar(withContentViewController: fullScreenPlayer, animated: true, completion: nil)
            return
        }

        popupBar.customBarViewController = miniPlayer
        popupContentView.popupCloseButtonStyle = .none
        popupInteractionStyle = .snap
        presentPopupBar(withContentViewController: fullScreenPlayer, animated: true, completion: nil)
    }

    @IBAction func openSwipePlayerClicked(_ sender: UIButton) {
        if AudioPlayerManager.shared.isPlaying() {
            openSwipePlayer()
        } else {
            playerLog("AudioPlayerManager not paying any song")
        }
    }

    @IBAction func playSongClicked(_ sender: UIButton) {
        // Add to queue
    }
    
    @IBAction func playNextClicked(_ sender: UIButton) {
        // play next
    }

    @IBAction func playListSongClicked(_ sender: UIButton) {
        AudioPlayerManager.shared.playGTAudioInfoList(playlist: DataSource.audioInfoList.map({ (audio) -> AudioInfo in
            return AudioInfo.from(audio: audio)
        }))
    }
}
