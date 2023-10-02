//
//  SCGetAlbumResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 30/08/23.
//

import Foundation

// MARK: - SCGetAlbumResponse
struct SCGetAlbumResponse: Codable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: SCExternalUrls
    let href, id: String
    let images: [SCImage]
    let name, releaseDate, releaseDatePrecision: String
    let restrictions: Restrictions?
    let type, uri: String
    let artists: [SCSimplifiedArtist]
    let tracks: SCAlbumTracks
    let copyrights: [SCCopyright]
    let externalIDS: SCExternalIDS?
    let genres: [SCGenre]?
    let label: String
    let popularity: Int

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case restrictions, type, uri, artists, tracks, copyrights
        case externalIDS = "external_ids"
        case genres, label, popularity
    }
}

// MARK: - Tracks
struct SCAlbumTracks: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SCTrack]
}
