//
//  ContentSize.swift
//  BerryQuest
//
//  Created by 김수경 on 10/14/24.
//

import UIKit

enum ContentSize {
    static var screenWidth: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.width
        }
        return UIScreen.main.bounds.size.width
    }
    static var screenHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.height
        }
        return UIScreen.main.bounds.size.height
    }

    case bottomSheetMax
    case thumbImage
}

extension ContentSize {
    var size: CGSize {
        switch self {
        case .bottomSheetMax:
            return CGSize(width: ContentSize.screenWidth, height: ContentSize.screenHeight * 0.8)
        case .thumbImage:
            return CGSize(width: ContentSize.screenWidth * 0.25, height: ContentSize.screenWidth * 0.25)
        }
    }
}

