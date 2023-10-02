//
//  SCNewReleasesResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 27/08/23.
//

import Foundation

// MARK: - SCNewReleasesResponse
struct SCGetNewReleasesResponse: Codable {
    let albums: SCAlbumsPages
}

// MARK: - Albums
struct SCAlbumsPages: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SCAlbum]
}
