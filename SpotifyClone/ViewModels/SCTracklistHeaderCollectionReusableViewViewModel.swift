//
//  SCTracklistHeaderCollectionReusableViewViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 04/09/23.
//

import Foundation

enum HeaderTypes {
    case playlist(model: SCSimplifiedPlaylist)
    case album(model: SCAlbum)
}

struct SCTracklistHeaderCollectionReusableViewViewModel {
    
    private let type: HeaderTypes
    
    init(type: HeaderTypes) {
        self.type = type
    }
    
    public var playlistName: String {
        switch type {
        case .playlist(let model):
            return model.name
        case .album(let model):
            return model.name
        }
    }
    
    public var description: String {
        switch type {
        case .playlist(let model):
            return model.description ?? ""
        case .album(let model):
            return model.releaseDate.formattedDate()
        }
    }
    
    public var ownerName: String {
        switch type {
        case .playlist(let model):
            return model.owner.displayName ?? "Spotify"
        case .album(let model):
            return model.artists.compactMap { $0.name }.joined(separator: ", ")
        }
    }
    
    public var artworkURL: URL? {
        switch type {
        case .playlist(let model):
            return URL(string: model.images.first?.url ?? "")
        case .album(let model):
            return URL(string: model.images.first?.url ?? "")
        }
    }
    
}
