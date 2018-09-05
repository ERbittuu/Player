//
//  AudioPlayerManager+URL.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import MediaPlayer

extension AudioPlayerManager {

	// MARK: - Play

//    public func play(urlString string: String) {
//        self.play(url: URL(string: string))
//    }
//
//    public func play(urlStrings strings: [String], at startIndex: Int) {
//        self.play(urls: AudioURLTrack.convertToURLs(strings), at: startIndex)
//    }

    func playGTAudioInfo(audioInfo: AudioInfo) {
        if let track = AudioURLTrack(url: audioInfo.url) {
            track.audioInfo = audioInfo
            self.play(track)
        }
    }

    func playGTAudioInfoList(playlist: [AudioInfo]) {

        let newList = playlist.map { (audioInfo) -> AudioURLTrack in
            if let track = AudioURLTrack(url: audioInfo.url) {
                track.audioInfo = audioInfo
                return track
            }
            return AudioURLTrack(url: nil)!
        }
        self.play(newList, at: 0)
    }

//    public func play(url urlToPlay: URL?) {
//        if let track = AudioURLTrack(url: urlToPlay) {
//            self.play(track)
//        }
//    }

//    public func play(urls urlsToPlay: [URL?], at startIndex: Int) {
//        // Play the first track directly and add the other tracks to the queue in the background
//        if let firstPlayableItem = AudioURLTrack.firstPlayableItem(urlsToPlay, at: startIndex) {
//            // Play the first track directly
//            self.play(firstPlayableItem.track)
//            // Split the tracks into an array which contain the ones which have to be prepended and appended to queue
//            var urlsToPrepend = Array(urlsToPlay)
//            if firstPlayableItem.index > 0 {
//                // If the index of the first playable URL is greater than 0 there are URL to prepend
//                urlsToPrepend.removeSubrange(firstPlayableItem.index..<urlsToPrepend.count)
//            }
//            var urlsToAppend = Array(urlsToPlay)
//            urlsToAppend.removeSubrange(0..<(firstPlayableItem.index + 1))
//            // Append the remaining URL to the queue in the background
//            // As the creation of the tracks takes some time, we avoid a blocked UI
//            self.addToQueueInBackground(prepend: urlsToPrepend, append: urlsToAppend, to: self.queueGeneration)
//        }
//    }
//
//    fileprivate func addToQueueInBackground(prepend urlsToPrepend: [URL?], append urlsToAppend: [URL?], to queueGeneration: Int) {
//        DispatchQueue.global().async {
//            let itemsToPrepend = AudioURLTrack.makeTracks(of: urlsToPrepend, withStartIndex: 0)
//            let itemsToAppend = AudioURLTrack.makeTracks(of: urlsToAppend, withStartIndex: 0)
//            DispatchQueue.main.async {
//                self.prepend(itemsToPrepend.tracks, toQueue: queueGeneration)
//                self.append(itemsToAppend.tracks, toQueue: queueGeneration)
//            }
//        }
//    }

	// MARK: - Helper

	public func isPlaying(urlString string: String) -> Bool {
		return self.isPlaying(url: URL(string: string))
	}

	public func isPlaying(url urlToCheck: URL?) -> Bool {
		return (self.isPlaying() == true && self.currentTrack?.identifier() == urlToCheck?.absoluteString)
	}
}

// New For GT

//extension AudioPlayerManager {
//
//    func playGT(audio audios: [AudioInfo], at startIndex: Int) {
//
//        let urlsToPlay = audios.map { $0.url }
//
//        // Play the first track directly and add the other tracks to the queue in the background
//        if let firstPlayableItem = AudioURLTrack.firstPlayableItem(urlsToPlay, at: startIndex) {
//            // Play the first track directly
//            self.play(firstPlayableItem.track)
//            firstPlayableItem.track.initNowPlayingInfo()
//
//            let au = audios.filter({ (audio) -> Bool in
//                return audio.url == firstPlayableItem.track.url!
//            }).first!
//
//            firstPlayableItem.track.nowPlayingInfo?.merge((au.metadata ), uniquingKeysWith: { (_, new) -> NSObject in
//                return new
//            })
//
//            // Split the tracks into an array which contain the ones which have to be prepended and appended to queue
//            var urlsToPrepend = Array(urlsToPlay)
//            if firstPlayableItem.index > 0 {
//                // If the index of the first playable URL is greater than 0 there are URL to prepend
//                urlsToPrepend.removeSubrange(firstPlayableItem.index..<urlsToPrepend.count)
//            }
//            var urlsToAppend = Array(urlsToPlay)
//            urlsToAppend.removeSubrange(0..<(firstPlayableItem.index + 1))
//
//            let appendAudios = urlsToAppend.map { (url) -> AudioInfo in
//                return audios.filter({ (audio) -> Bool in
//                    return audio.url == url
//                }).first!
//            }
//
//            let prependAudios = urlsToAppend.map { (url) -> AudioInfo in
//                return audios.filter({ (audio) -> Bool in
//                    return audio.url == url
//                }).first!
//            }
//
//            // Append the remaining URL to the queue in the background
//            // As the creation of the tracks takes some time, we avoid a blocked UI
//            self.addToQueueInBackgroundGT(prepend: prependAudios, append: appendAudios, to: self.queueGeneration)
//        }
//    }
//
//    fileprivate func addToQueueInBackgroundGT(prepend audioToPrepend: [AudioInfo], append audioToAppend: [AudioInfo], to queueGeneration: Int) {
//        DispatchQueue.global().async {
//
//            let urlsToAppend = audioToAppend.map { $0.url }
//            let urlsToPrepend = audioToPrepend.map { $0.url }
//
//            let itemsToPrepend = AudioURLTrack.makeTracks(of: urlsToPrepend, withStartIndex: 0)
//            let itemsToAppend = AudioURLTrack.makeTracks(of: urlsToAppend, withStartIndex: 0)
//
//            var itemsToPrependTracks = [AudioURLTrack]()
//            var itemsToAppendTracks = [AudioURLTrack]()
//
//            for (index, track) in itemsToPrepend.tracks.enumerated() {
//                track.initNowPlayingInfo()
//
//                track.nowPlayingInfo?.merge((audioToPrepend[index].metadata ), uniquingKeysWith: { (_, new) -> NSObject in
//                    return new
//                })
//                itemsToPrependTracks.append(track)
//            }
//
//            for (index, track) in itemsToAppend.tracks.enumerated() {
//                track.initNowPlayingInfo()
//
//                track.nowPlayingInfo?.merge((audioToAppend[index].metadata ), uniquingKeysWith: { (_, new) -> NSObject in
//                    return new
//                })
//                itemsToAppendTracks.append(track)
//            }
//
//            DispatchQueue.main.async {
//                self.prepend(itemsToPrependTracks, toQueue: queueGeneration)
//                self.append(itemsToAppendTracks, toQueue: queueGeneration)
//
//                for track in itemsToPrependTracks {
//                    print(track.nowPlayingInfo ?? "No")
//                }
//
//                for track in itemsToAppendTracks {
//                    print(track.nowPlayingInfo ?? "No")
//                }
//
//            }
//        }
//    }
//}
