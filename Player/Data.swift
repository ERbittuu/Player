//
//  Data.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DataSource {
    
    private init() { }
    
    static var data : [Audio] {
        
       let a1 = Audio(withID: 0, url: "https://www.dropbox.com/s/an41oksek3rukvk/Nazm_Nazm.mp3?dl=1", title: "Nazm Nazm..", artist: "Arko, Aditya Dev, Bareilly Ki Barfi", duration: 149, t_img: #imageLiteral(resourceName: "nazm") )

        var url: URL = Bundle.main.url(forResource: "Hawayein", withExtension: "mp3")!
        
        let a2 = Audio(withID: 1, url: url.relativeString, title: "Hawayein..", artist: "Arijit Singh", duration: 291, t_img: #imageLiteral(resourceName: "Hawayein"))

         url = Bundle.main.url(forResource: "Blank_Space", withExtension: "mp3")!

        let a3 = Audio(withID: 2, url: url.relativeString, title: "Blank Space", artist: "Max Martin, Taylor Swift, Shellback", duration: 272, t_img: #imageLiteral(resourceName: "TS"))
            
        return [a1, a2, a3]
    }
}
