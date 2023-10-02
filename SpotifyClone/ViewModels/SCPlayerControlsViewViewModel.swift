//
//  SCPlayerControlsViewViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 15/09/23.
//

import Foundation

struct SCPlayerControlsViewViewModel {
    private let title: String?
    private let subtitle: String?
    
    init(title: String?, subtitle: String?) {
        self.title = title
        self.subtitle = subtitle
    }
    
    public func getTitle() -> String {
        return title ?? ""
    }
    
    public func getSubtitle() -> String {
        return subtitle ?? ""
    }
}
