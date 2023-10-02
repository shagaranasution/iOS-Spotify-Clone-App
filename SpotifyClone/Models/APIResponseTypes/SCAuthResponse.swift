//
//  SCAuthResponse.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 24/08/23.
//

import Foundation

struct SCAuthResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
}
