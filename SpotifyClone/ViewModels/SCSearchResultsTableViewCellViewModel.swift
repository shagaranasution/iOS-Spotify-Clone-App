//
//  SCSearchResultsTableViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 12/09/23.
//

import Foundation

struct SCSearchResultsTableViewCellViewModel {
    private let name: String
    private var subtitle: String?
    private let artworkUrlString: String
    
    init(name: String, subtitle: String? = nil, artworkUrlString: String) {
        self.name = name
        self.subtitle = subtitle
        self.artworkUrlString = artworkUrlString
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getSubtitle() -> String? {
        return self.subtitle
    }
    
    public func getArtworkURL() -> URL? {
        return URL(string: self.artworkUrlString)
    }
}
