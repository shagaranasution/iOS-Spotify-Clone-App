//
//  SCSearchResultsViewControllerViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 11/09/23.
//

import Foundation

enum SCSearchResult {
    case albums(model: SCAlbum)
    case artists(model: SCSimplifiedArtist)
    case playlists(model: SCSimplifiedPlaylist)
    case tracks(model: SCTrack)
}

struct SCSearchResultsSection {
    let title: String
    let items: [SCSearchResult]
}

struct SCSearchResultsViewControllerViewModel {
    
    private let models: SCGetSearchResultsResponse
    
    init(model: SCGetSearchResultsResponse) {
        self.models = model
    }
    
    public var sections: [SCSearchResultsSection] {
        var searchResults: [SCSearchResult] = []
        searchResults.append(contentsOf: models.tracks.items.compactMap { SCSearchResult.tracks(model: $0) })
        searchResults.append(contentsOf: models.artists.items.compactMap { SCSearchResult.artists(model: $0) })
        searchResults.append(contentsOf: models.playlists.items.compactMap { SCSearchResult.playlists(model: $0) })
        searchResults.append(contentsOf: models.albums.items.compactMap { SCSearchResult.albums(model: $0) })
        
        let tracks = searchResults.filter {
            switch $0 {
            case .tracks : return true
            default: return false
            }
        }
        let artists = searchResults.filter {
            switch $0 {
            case .artists : return true
            default: return false
            }
        }
        let playlists = searchResults.filter {
            switch $0 {
            case .playlists : return true
            default: return false
            }
        }
        let albums = searchResults.filter {
            switch $0 {
            case .albums : return true
            default: return false
            }
        }
        
        return [
            SCSearchResultsSection(title: "Songs", items: tracks),
            SCSearchResultsSection(title: "Artists", items: artists),
            SCSearchResultsSection(title: "Playlists", items: playlists),
            SCSearchResultsSection(title: "Albums", items: albums),
        ]
    }
    
    public func getName(forItemAtIndex index: Int, section: Int) -> String {
        let result = sections[section].items[index]
        switch result {
        case .tracks(let model):
            return model.name
        case .artists(let model):
            return model.name
        case .playlists(let model):
            return model.name
        case .albums(let model):
            return model.name
        }
    }
    
    public func getArtworkURL(forItemAtIndex index: Int, section: Int) -> String {
        let result = sections[section].items[index]
        switch result {
        case .tracks(let model):
            return model.album?.images.first?.url ?? ""
        case .artists(let model):
            return model.images?.first?.url ?? ""
        case .playlists(let model):
            return model.images.first?.url ?? ""
        case .albums(let model):
            return model.images.first?.url ?? ""
        }
    }
    
    public func getSubtitle(forItemAtIndex index: Int, section: Int) -> String? {
        let result = sections[section].items[index]
        switch result {
        case .tracks(let model):
            return model.artists.compactMap {
                $0.name
            }.joined(separator: ",")
        case .artists:
            return nil
        case .playlists(let model):
            return model.owner.displayName ?? "Spotify"
        case .albums(let model):
            return model.artists.compactMap {
                $0.name
            }.joined(separator: ",")
        }
    }
    
}
