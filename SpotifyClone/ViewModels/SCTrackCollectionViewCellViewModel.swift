//
//  SCTrackCollectionViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 29/08/23.
//

import Foundation

struct SCTrackCollectionViewCellViewModel {
    private let track: SCTrack
    
    init(track: SCTrack) {
        self.track = track
    }
    
    public var trackName: String {
        return track.name
    }
    
    public var album: SCAlbum? {
        return track.album
    }
    
    public var artworkURL: URL? {
        guard let album = album else {
            return nil
        }
        
        return URL(string: album.images.first?.url ?? "")
    }
    
    public var artistName: String {
        return track.artists.enumerated().reduce("") {
            let (index, value) = $1
            
            if index == 0 {
                return $0 + value.name
            }
            
            return $0 + ", " + value.name
        }
    }
    
}
