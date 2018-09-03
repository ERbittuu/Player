//
//  Data.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit

struct DataSource {

    private init() { }

    static var audioInfoList: [Audio] {

        let audioInfo1 = Audio(url: URL(string: "https://www.dropbox.com/s/an41oksek3rukvk/Nazm_Nazm.mp3?dl=1")!, title: "Nazm Nazm..", artist: "Arko, Aditya Dev, Bareilly Ki Barfi", image: #imageLiteral(resourceName: "nazm"), id: 0)

        let audioInfo2 = Audio(url: URL(string: "http://35.231.167.156/hls/-L-BHdNUzGNjxAh0un_P_trd.mp4/index.m3u8")!, title: "Hawayein..", artist: "Arijit Singh", image: #imageLiteral(resourceName: "Hawayein"), id: 0)

        let audioInfo3 = Audio(url: URL(string: "http://35.231.167.156/hls/-L-BHdNXPiGFIMSh99dV_trd.mp4/index.m3u8")!, title: "Blank Space", artist: "Max Martin, Taylor Swift, Shellback", image: #imageLiteral(resourceName: "TS"), id: 0)

        return [audioInfo1, audioInfo2, audioInfo3]
    }
}

struct Audio {
    let url: URL
    let title: String
    let artist: String
    let image: UIImage
    let id: Int
}
