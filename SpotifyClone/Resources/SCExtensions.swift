//
//  SCExtensions.swift
//  SpotifyClone
//
//  Created by Shagara F Nasution on 22/08/23.
//

import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    var safeAreaTop: CGFloat {
        top + safeAreaInsets.top
    }
    
    var safeAreaBottom: CGFloat {
        return bottom - safeAreaInsets.bottom
    }
    
    var safeAreaLeft: CGFloat {
        return left + safeAreaInsets.left
    }
    
    var safeAreaRight: CGFloat {
        return right - safeAreaInsets.right - safeAreaInsets.left
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }

}

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
    
}

extension String {
    
    func formattedDate() -> String {
        guard let date = DateFormatter.dateFormatter.date(from: self) else {
            return self
        }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
}

extension DateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
}


extension Notification.Name {
    static let albumSavedNotification = Notification.Name("albumSavedNotification")
}

