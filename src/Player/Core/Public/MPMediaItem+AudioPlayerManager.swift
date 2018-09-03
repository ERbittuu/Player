//
//  MPMediaItem+AudioPlayerManager.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import MediaPlayer

extension MPMediaItem {

	/**
	Checks whether the item is a cloud item and if the asset URL is existing.

	- returns: A `Bool` which is true if the item is playable (the item isn't a cloud item and the asset URL exists.)
	*/
	public func isPlayable() -> Bool {
		return (self.isCloudItem == false && self.assetURL != nil)
	}
}
