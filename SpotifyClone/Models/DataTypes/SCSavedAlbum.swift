//
//  SCSavedAlbum.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/09/23.
//

import Foundation

struct SCSavedAlbum: Codable {
    let addedAt: String
    let album: SCAlbum
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case album
    }
}
