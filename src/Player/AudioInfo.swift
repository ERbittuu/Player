//
//  AudioInfo.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 9/3/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit
import MediaPlayer
import Kingfisher

class AudioInfo {

    var audio: String!
    var id: Int!
    var name: String!

    // audio use
    var url: URL!
    var title: String = ""
    var artist: String = ""
    var album: String = ""
    var thumbnailImageUrl: URL?
    var image: UIImage?

    var albumString: String {
        return album.isEmpty ? "Unknown" : album
    }
}

extension AudioInfo {

    var metadata: [String: NSObject] {

        var info = [String: NSObject]()

        info[MPMediaItemPropertyTitle] = self.title as NSObject?
        info[MPMediaItemPropertyAlbumTitle] = self.albumString as NSObject?
        info[MPMediaItemPropertyArtist] = self.albumString as NSObject?
        info[MPMediaItemPropertyArtwork] = self.mediaItemArtwork()

        return info
    }

    private func mediaItemArtwork() -> MPMediaItemArtwork? {

        let bSize = CGSize(width: 600, height: 600)
        if #available(iOS 10.0, *) {
            return MPMediaItemArtwork(boundsSize: bSize, requestHandler: { (_: CGSize) -> UIImage in
                if let img = self.image {
                    return img
                } else {

                    KingfisherManager.shared.retrieveImage(with: self.thumbnailImageUrl! ,
                                                           options: nil,
                                                           progressBlock: nil,
                                                           completionHandler: { image, _, _, _ in

                                                            DispatchQueue.main.async {
                                                                self.image = image
                                                                MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist: self.albumString,
                                                                                                                   MPMediaItemPropertyAlbumTitle: self.albumString,
                                                                                                                   MPMediaItemPropertyTitle: self.title,
                                                                                                                   MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: bSize, requestHandler: { (_) -> UIImage in
                                                                                                                    return self.image ?? UIImage()
                                                                                                                   })]
                                                            }
                    })
                    return UIImage()
                }
            })
        } else {
            return MPMediaItemArtwork(image: image ?? UIImage())
        }
    }

   static func from(audio: Audio) -> AudioInfo {

        let audioInfo = AudioInfo()
        audioInfo.url = audio.url
        audioInfo.title = audio.title
        audioInfo.artist = audio.artist
        audioInfo.album = audio.artist
        audioInfo.thumbnailImageUrl = URL(string: audio.imageURL)
        audioInfo.image = audio.image

        audioInfo.audio = audio.url.relativeString
        audioInfo.name = audio.title
        audioInfo.id = audio.id

        return audioInfo
    }
}
