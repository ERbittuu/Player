//
//  AudioPlayerManager+RemoteControl.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import UIKit

extension AudioPlayerManager {

	public func remoteControlReceivedWithEvent(_ event: UIEvent?) {
		if let event = event {
			switch event.subtype {
			case UIEventSubtype.remoteControlPlay:
				self.play()
			case UIEventSubtype.remoteControlPause:
				self.pause()
			case UIEventSubtype.remoteControlNextTrack:
				self.forward()
			case UIEventSubtype.remoteControlPreviousTrack:
				self.rewind()
			case UIEventSubtype.remoteControlTogglePlayPause:
				self.togglePlayPause()
			default:
				break
			}
		}
	}
}
