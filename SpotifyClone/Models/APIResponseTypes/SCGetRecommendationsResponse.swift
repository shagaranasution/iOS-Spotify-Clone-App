//
//  SCGetRecommendationsResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 28/08/23.
//

import Foundation

// MARK: - SCGetRecommendationsResponse
struct SCGetRecommendationsResponse: Codable {
    let seeds: [SCRecommendationSeed]
    let tracks: [SCTrack]
}
