//
//  SCSimplifiedAlbum.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 27/08/23.
//

import Foundation

// MARK: - SimplifiedAlbum
struct SCSimplifiedAlbum: Codable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: SCExternalUrls
    let href: String
    let id: String
    let images: [SCImage]
    let name, releaseDate, releaseDatePrecision, type: String
    let uri: String
    let artists: [SCSimplifiedArtist]

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case type, uri, artists
    }
}

struct ExternalUrl: Codable {
    let spotify: String
}

struct SimplifiedAlbumImage: Codable {
    let url: String
    let height: Int
    let width: Int
}


