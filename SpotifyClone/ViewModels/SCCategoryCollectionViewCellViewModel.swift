//
//  SCCategoryCollectionViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 07/09/23.
//

import Foundation

struct SCCategoryCollectionViewCellViewModel {
    
    private let category: SCCategory
    
    init(category: SCCategory) {
        self.category = category
    }
    
    public var name: String {
        return category.name
    }
    
    public var artworkURL: URL? {
        return URL(string: category.icons.first?.url ?? "")
    }
    
}
