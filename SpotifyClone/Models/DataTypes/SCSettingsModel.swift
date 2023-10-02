//
//  SCSettingsModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 25/08/23.
//

import Foundation

struct SCSettingSection {
    let title: String
    let options: [SCSettingSectionOption]
}

struct SCSettingSectionOption {
    let title: String
    let handler: () -> Void
}
