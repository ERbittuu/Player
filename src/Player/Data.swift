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
                               title: "1. Nazm Nazm..",
                               artist: "Arko, Aditya Dev, Bareilly Ki Barfi",
                               image: nil,
                               imageURL: "https://images.pexels.com/photos/67636/rose-blue-flower-rose-blooms-67636.jpeg?auto=compress&cs=tinysrgb&h=350",
                               id: 0)

        let audioInfo2 = Audio(url: URL(string: "https://www.sample-videos.com/audio/mp3/crowd-cheering.mp3")!,
                               title: "2. Hawayein..",
                               artist: "Arijit Singh",
                               image: nil,
                               imageURL: "http://d6iwr8uhn6sxp.cloudfront.net/uploads/property/banner/1_1_e14d37f40348ea9c44c72ea7c7d51c12.jpg",
                               id: 0)

        let audioInfo3 = Audio(url: URL(string: "https://www.sample-videos.com/audio/mp3/wave.mp3")!,
                               title: "3. Blank Space",
                               artist: "Max Martin, Taylor Swift, Shellback",
                               image: #imageLiteral(resourceName: "TS"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        let audioInfo4 = Audio(url: URL(string: "https://archive.org/download/testmp3testfile/testmp3testfile_64kb.m3u")!,
                               title: "4. Blank Space",
                               artist: "Max Martin, Taylor Swift, Shellback",
                               image: #imageLiteral(resourceName: "TS"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        let audioInfo5 = Audio(url: URL(string: "https://archive.org/download/testmp3testfile/mpthreetest.mp3")!,
                               title: "5. Blank Space",
                               artist: "Max Martin, Taylor Swift, Shellback",
                               image: #imageLiteral(resourceName: "TS"),
                               imageURL: "https://sa-gt-hub-dev-stage.s3.amazonaws.com/content/ed1e73e0-adb2-11e8-a4a4-59ce937e6d4a/ZHP4xiw4JEn0eC2X-4K9fFEM.jpg",
                               id: 0)

        return [audioInfo1, audioInfo2, audioInfo3, audioInfo4, audioInfo5]
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
