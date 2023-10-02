//
//  SCGetSearchResultsResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 11/09/23.
//

import Foundation

struct SCGetSearchResultsResponse: Codable {
    let albums: BaseSCGetSearchResultsResponse<SCAlbum>
    let artists: BaseSCGetSearchResultsResponse<SCSimplifiedArtist>
    let playlists: BaseSCGetSearchResultsResponse<SCSimplifiedPlaylist>
    let tracks: BaseSCGetSearchResultsResponse<SCTrack>
}

struct BaseSCGetSearchResultsResponse<Item: Codable>: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [Item]
}
