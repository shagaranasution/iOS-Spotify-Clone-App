//
//  SCLibraryTableViewCellViewModel.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 21/09/23.
//

import Foundation

protocol SCLibraryTableViewCellViewModelDataSource: AnyObject {
    var title: String { get }
    var subtitle: String { get }
    var artworkImageURL: URL? { get }
}

struct SCLibraryTableViewCellViewModel {
    
    private let title: String
    private let subtitle: String?
    private let artworkImageURLString: String?
    
    init(title: String, subtitle: String?, artworkImageURLString: String?) {
        self.title = title
        self.subtitle = subtitle
        self.artworkImageURLString = artworkImageURLString
    }
    
    public func getTitle() -> String {
        return title
    }
    
    public func getSubtitle() -> String {
        return subtitle ?? ""
    }
    
    public func getArtworkImageURL() -> URL? {
        return URL(string: artworkImageURLString ?? "")
    }
    
}
