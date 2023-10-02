//
//  SCSeed.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import Foundation

// MARK: - Seed
struct SCRecommendationSeed: Codable {
    let initialPoolSize, afterFilteringSize, afterRelinkingSize: Int
    let id: String
    let type: String
    let href: String?
}
