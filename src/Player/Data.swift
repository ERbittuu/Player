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

        let audioInfo1 = Audio(url: URL(string: "https://s3-us-west-2.amazonaws.com/sa-gt-hub-dev-stage/content/PIFqaZHXGfEmrBB1RaWV601D.mp3/PIFqaZHXGfEmrBB1RaWV601D.mp3.m3u8")!,
                               title: "Nazm Nazm..",
                               artist: "Arko, Aditya Dev, Bareilly Ki Barfi",
                               image: #imageLiteral(resourceName: "nazm"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        let audioInfo2 = Audio(url: URL(string: "https://s3-us-west-2.amazonaws.com/sa-gt-hub-dev-stage/content/PIFqaZHXGfEmrBB1RaWV601D.mp3/PIFqaZHXGfEmrBB1RaWV601D.mp3.m3u8")!,
                               title: "Hawayein..",
                               artist: "Arijit Singh",
                               image: #imageLiteral(resourceName: "Hawayein"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        let audioInfo3 = Audio(url: URL(string: "https://s3-us-west-2.amazonaws.com/sa-gt-hub-dev-stage/content/PIFqaZHXGfEmrBB1RaWV601D.mp3/PIFqaZHXGfEmrBB1RaWV601D.mp3.m3u8")!,
                               title: "Blank Space",
                               artist: "Max Martin, Taylor Swift, Shellback",
                               image: #imageLiteral(resourceName: "TS"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        return [audioInfo1, audioInfo2, audioInfo3]
    }
}

struct Audio {
    let url: URL
    let title: String
    let artist: String
    let image: UIImage?
    let imageURL: String
    let id: Int
}
