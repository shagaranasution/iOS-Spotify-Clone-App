//
//  SCCategory.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 07/09/23.
//

import Foundation

struct SCCategory: Codable {
    let href: String
    let icons: [SCImage]
    let id, name: String
}
