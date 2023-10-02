//
//  SCSimplifiedArtist.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import Foundation

struct SCSimplifiedArtist: Codable {
    let externalUrls: SCExternalUrls
    let href: String
    let id, name, type, uri: String
    let images: [SCImage]?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri, images
    }
}
