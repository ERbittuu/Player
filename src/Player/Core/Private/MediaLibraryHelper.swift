//
//  HSMediaLibraryHelper.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import UIKit
import MediaPlayer

class HSMediaLibraryHelper: NSObject {

	class func mediaItem(persistentID: MPMediaEntityPersistentID) -> MPMediaItem? {
		let predicate = MPMediaPropertyPredicate(value: NSNumber(value: persistentID as UInt64), forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
		let predicates: Set = [predicate]
		return MPMediaQuery(filterPredicates: predicates).items?.first
	}
}
