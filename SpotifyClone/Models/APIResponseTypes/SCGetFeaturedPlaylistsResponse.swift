//
//  SCGetFeaturedPlaylistsResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 27/08/23.
//

import Foundation

// MARK: - SCGetFeaturedPlaylistsResponse
struct SCGetFeaturedPlaylistsResponse: Codable {
    let message: String?
    let playlists: SCPlaylists
}

// MARK: - Playlists
struct SCPlaylists: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SCSimplifiedPlaylist]
}

// MARK: - SimplifiedPlaylist
struct SCSimplifiedPlaylist: Codable {
    let collaborative: Bool
    let description: String?
    let externalUrls: SCExternalUrls
    let href: String
    let id: String
    let images: [SCImage]
    let name: String
    let owner: SCOwner
    let itemPublic: Bool?
    let snapshotID: String
    let tracks: SCTracks
    let type, uri: String
    let primaryColor: String?

    enum CodingKeys: String, CodingKey {
        case collaborative, description
        case externalUrls = "external_urls"
        case href, id, images, name, owner
        case itemPublic = "public"
        case snapshotID = "snapshot_id"
        case tracks, type, uri
        case primaryColor = "primary_color"
    }
}

// MARK: - Tracks
struct SCTracks: Codable {
    let href: String
    let total: Int
}

