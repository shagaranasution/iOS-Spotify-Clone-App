//
//  SCPlaylistTrack.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 30/08/23.
//

import Foundation

struct SCPlaylistTrack: Codable {
    let addedAt: String
    let addedBy: SCOwner?
    let isLocal: Bool
    let track: SCTrack?

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case track
    }
}
