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

        var url: URL = Bundle.main.url(forResource: "Hawayein", withExtension: "mp3")!
        let audioInfo2 = Audio(url: url, title: "Hawayein..", artist: "Arijit Singh", image: #imageLiteral(resourceName: "Hawayein"), id: 0)

        url = Bundle.main.url(forResource: "Blank_Space", withExtension: "mp3")!

        let audioInfo3 = Audio(url: url, title: "Blank Space", artist: "Max Martin, Taylor Swift, Shellback", image: #imageLiteral(resourceName: "TS"), id: 0)

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
