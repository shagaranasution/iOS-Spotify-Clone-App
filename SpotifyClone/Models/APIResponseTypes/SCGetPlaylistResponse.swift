//
//  SCGetPlaylistResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 30/08/23.
//

import Foundation

// MARK: - SCGetPlaylistResponse
struct SCGetPlaylistResponse: Codable {
    let collaborative: Bool
    let description: String?
    let externalUrls: SCExternalUrls
    let followers: SCFollowers
    let href, id: String
    let images: [SCImage]
    let name: String
    let owner: SCOwner
    let scGetAlbumDetailsResponsePublic: Bool
    let snapshotID: String
    let tracks: SCGetPlaylistTracks
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case collaborative, description
        case externalUrls = "external_urls"
        case followers, href, id, images, name, owner
        case scGetAlbumDetailsResponsePublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
    }
}

// MARK: - Tracks
struct SCGetPlaylistTracks: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SCPlaylistTrack]
}
