//
//  Log.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import UIKit

// MARK: - Log

func playerLog(_ message: String = "", file: String = #file, function: String = #function, line: Int = #line) {
	if AudioPlayerManager.verbose == true {
		if (AudioPlayerManager.detailedLog == true),
			let className = URL(string: file)?.lastPathComponent.components(separatedBy: ".").first {
			let log = "\(Date()) - [\(className)].\(function)[\(line)]: \(message)"
			print(log)
		} else {
			print(message)
		}
	}
}
