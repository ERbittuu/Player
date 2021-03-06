//
//  AudioURLTrack+Metadata.swift
//  MusicPlayer
//
//  Created by Utsav Patel on 8/22/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.

import AVFoundation
import MediaPlayer

// MARK: - Metadata

extension AudioURLTrack {

	internal func extractMetadata() {
        AudioPlayerManager.shared.didUpdateMetadata()
//        return
//        playerLog("Extracting meta data of player item with url: \(String(describing: self.url))")
//        self.playerItem?.asset.load(.commonMetadata, completion: { [weak self] (items: [AVMetadataItem]) in
//            let parsedMetadata = self?.parseMetadataItems(items)
//            self?.nowPlayingInfo?.merge((parsedMetadata ?? [:]), uniquingKeysWith: { (_, new) -> NSObject in
//                return new
//            })
//
//            // Inform the player about the updated meta data
//            AudioPlayerManager.shared.didUpdateMetadata()
//        })
	}

	/// Extract necessary info from loaded metadata items.
	/// By default only the Title, AlbumName, Artist and Artwork values will be kept.
	/// Override to add any other metadata.
	///
	/// - Parameter items: Array of fully loaded metadata items.
	/// - Returns: Dictionary for metadata key values.
	open func parseMetadataItems(_ items: [AVMetadataItem]) -> [String: NSObject] {
        let info = [String: NSObject]()
//        for metadataItem in items {
//            if let key = metadataItem.commonKey {
//                switch key {
//                case AVMetadataKey.commonKeyTitle        :
//                    break;
//                    info[MPMediaItemPropertyTitle] = metadataItem.stringValue as NSObject?
//                case AVMetadataKey.commonKeyAlbumName    :
//                    break;
//                    info[MPMediaItemPropertyAlbumTitle] = metadataItem.stringValue as NSObject?
//                case AVMetadataKey.commonKeyArtist        :
//                    break;
//                    info[MPMediaItemPropertyArtist] = metadataItem.stringValue as NSObject?
//                case AVMetadataKey.commonKeyArtwork        :
//                    info[MPMediaItemPropertyArtwork] = self.mediaItemArtwork(from: metadataItem.dataValue)
//                default                                    :
//                    continue
//                }
//            }
//        }

		return info
	}

    func mediaItemArtwork(from data: Data?) -> MPMediaItemArtwork? {
		guard
			let data = data,
			let image = UIImage(data: data) else {
				return nil
		}

		if #available(iOS 10.0, *) {
			return MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_: CGSize) -> UIImage in
				return image
			})
		} else {
			return MPMediaItemArtwork(image: image)
		}
	}
}
