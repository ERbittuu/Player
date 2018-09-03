//
//  AudioInfo.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 9/3/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit
import MediaPlayer

class AudioInfo {

    var audio: String!
    var id: Int!
    var name: String!

    // audio use
    var url: URL!
    var title: String = ""
    var artist: String = ""
    var album: String = ""
    var thumbnailImageUrlString: String?
    var image: UIImage = #imageLiteral(resourceName: "ArtPlaceholder")

//    /**
//     * Instantiate the instance using the passed json values to set the properties values
//     */
//    init(fromJson json: JSON!) {
//        if json.isEmpty {
//            return
//        }
//        audio = json["audio"].stringValue
//        id = json["id"].intValue
//        name = json["name"].stringValue
//
//        self.url = URL(string: audio!)
//        self.title = self.name ?? "Unknown"
//        self.artist = self.name ?? "Unknown"
//    }
//
    var albumString: String {
        return (album.isEmpty || album == "Unknown") ? title : "Unknown"
    }

    func downloadImage(imageUrl: URL) {
        DispatchQueue.global().async {
//            KingfisherManager.shared.retrieveImage(with: imageUrl,
//                                                   options: nil,
//                                                   progressBlock: nil,
//                                                   completionHandler: { image, _, _, _ in
//                                                    self.image = image ?? #imageLiteral(resourceName: "ArtPlaceholder")
//            })
        }
    }
}

extension AudioInfo {

    var metadata: [String: NSObject] {

        var info = [String: NSObject]()

        info[MPMediaItemPropertyTitle] = self.title as NSObject?
        info[MPMediaItemPropertyAlbumTitle] = self.albumString as NSObject?
        info[MPMediaItemPropertyArtist] = self.albumString as NSObject?
        info[MPMediaItemPropertyArtwork] = self.mediaItemArtwork(from: self.image)

        return info
    }

    private func mediaItemArtwork(from image: UIImage) -> MPMediaItemArtwork? {

        if #available(iOS 10.0, *) {
            return MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_: CGSize) -> UIImage in
                return image
            })
        } else {
            return MPMediaItemArtwork(image: image)
        }
    }
}
