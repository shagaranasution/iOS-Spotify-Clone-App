//
//  SCNewReleaseCollectionViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 29/08/23.
//

import Foundation

struct SCNewReleaseCollectionViewCellViewModel {
    private let album: SCAlbum
    
    init(album: SCAlbum) {
        self.album = album
    }
    
    public var albumName: String {
        return album.name
    }
    
    public var artworkURL: URL? {
        return URL(string: album.images.first?.url ?? "")
    }
    
    public var numberOfTracks: Int {
        return album.totalTracks
    }
    
    public var artistName: String {
        return album.artists.first?.name ?? "-"
    }
}
