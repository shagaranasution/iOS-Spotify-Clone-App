//
//  SCOwner.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 30/08/23.
//

import Foundation

struct SCOwner: Codable {
    let externalUrls: SCExternalUrls
    let followers: SCFollowers?
    let href, id, type, uri: String
    let displayName, name: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, href, id, type, uri
        case displayName = "display_name"
        case name
    }
}
