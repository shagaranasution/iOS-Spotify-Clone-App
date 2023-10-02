//
//  SCFeaturePlaylistCollectionViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 29/08/23.
//

import Foundation

struct SCFeaturePlaylistCollectionViewCellViewModel {
    private let playlist: SCSimplifiedPlaylist
    
    init(playlist: SCSimplifiedPlaylist) {
        self.playlist = playlist
    }
    
    public var playlistName: String {
        return playlist.name
    }
    
    public var artworkURL: URL? {
        return URL(string: playlist.images.first?.url ?? "")
    }
    
    public var creatorName: String {
        return playlist.owner.displayName ?? "-"
    }
}
