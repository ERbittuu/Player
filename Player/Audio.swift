//
//  Audio.swift
//  VKMusic
//


import UIKit
import SwiftyJSON

func ==(lhs: Audio, rhs: Audio) -> Bool {
    return lhs.url == rhs.url
}

class Audio : NSObject {
 
    var url = ""
    var title = "Unknown"
    var artist = "Unknown"
    var duration = 0
    var thumbnailImage : String!
    var id = 0
    var thumbnail_image: UIImage?

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        url = json["url"].stringValue
        title = json["title"].stringValue
        artist = json["artist"].stringValue
        duration = json["duration"].intValue
        thumbnailImage = json["thumbnail_image"].stringValue
        id = json["id"].intValue
    }
    
    init(withThumbnailImage timage: UIImage?, url: String, title: String, artist: String , duration: Int) {
        self.thumbnail_image = timage
        self.url = url
        self.title = title.stripped
        self.artist = artist.stripped
        self.duration = duration
    }
    
    //Used for Core Data loading Image
    init(withID id: Int, url: String, title: String, artist: String , duration: Int, t_img: UIImage?) {
        self.id = id
        self.url = url
        self.title = title.stripped
        self.artist = artist.stripped
        self.duration = duration
        self.thumbnail_image = t_img
    }
    
}
