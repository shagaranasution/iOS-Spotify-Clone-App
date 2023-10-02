//
//  SCUserProfile.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import Foundation

// MARK: - SCUserProfile
struct SCUserProfile: Codable {
    let country, displayName, email: String
    let explicitContent: ExplicitContent
    let externalUrls: SCExternalUrls
    let followers: SCFollowers
    let href, id: String
    let images: [SCImage]
    let product, type, uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers, href, id, images, product, type, uri
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled, filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}
