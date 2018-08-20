//
//	Playlist.swift
//
//	Create by Sanjay Shah on 16/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class Playlist{

	var id : String!
	var musicURL : String!
	var name : String!
    var desc : String!
	var thumbURL : String!
    var isRepeat = false
	var playlist : [Playlist]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["id"].stringValue
		musicURL = json["musicURL"].stringValue
		name = json["name"].stringValue
        desc = json["desc"].stringValue
		thumbURL = json["thumbURL"].stringValue
		playlist = [Playlist]()
		let playlistArray = json["playlist"].arrayValue
		for playlistJson in playlistArray{
			let value = Playlist(fromJson: playlistJson)
			playlist.append(value)
		}
	}

}
