//
//  SCCategories.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 07/09/23.
//

import Foundation

struct SCCategories: Codable {
    let href: String
    let items: [SCCategory]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
