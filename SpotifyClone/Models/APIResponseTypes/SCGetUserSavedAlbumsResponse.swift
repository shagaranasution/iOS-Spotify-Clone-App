//
//  SCGetUserSavedAlbumsResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/09/23.
//

import Foundation

struct SCGetUserSavedAlbumsResponse: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SCSavedAlbum]
}
