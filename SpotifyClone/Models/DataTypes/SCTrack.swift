//
//  SCTrack.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import Foundation

// MARK: - Track
struct SCTrack: Codable {
    var album: SCAlbum?
    let artists: [SCSimplifiedArtist]
    let availableMarkets: [String]
    let discNumber, durationMS: Int
    let explicit: Bool
    let externalIDS: SCExternalIDS?
    let externalUrls: SCExternalUrls
    let href, id: String
    let isPlayable: Bool?
    let linkedFrom: SCLinkedFrom?
    let restrictions: Restrictions?
    let name: String
    let popularity: Int?
    let previewURL: String?
    let trackNumber: Int
    let type, uri: String
    let isLocal: Bool

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case restrictions
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
        case isLocal = "is_local"
    }
}

struct Restrictions: Codable {
    let reason: String
}

// MARK: - LinkedFrom
struct SCLinkedFrom: Codable {
    let externalUrls: SCExternalUrls
    let href: String
    let id, name, type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}
