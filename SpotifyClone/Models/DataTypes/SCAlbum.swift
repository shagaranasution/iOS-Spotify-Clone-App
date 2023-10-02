//
//  SCAlbum.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import Foundation

// MARK: - Album
struct SCAlbum: Codable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: SCExternalUrls
    let href, id: String
    let images: [SCImage]
    let name, releaseDate, releaseDatePrecision: String
    let restrictions: Restrictions?
    let type, uri: String
    let copyrights: [SCCopyright]?
    let externalIDS: SCExternalIDS?
    let genres: [SCGenre]?
    let label: String?
    let popularity: Int?
    let albumGroup: String?
    let artists: [SCSimplifiedArtist]

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case restrictions, type, uri, copyrights
        case externalIDS = "external_ids"
        case genres, label, popularity
        case albumGroup = "album_group"
        case artists
    }
}
