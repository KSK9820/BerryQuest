//
//  UIImage+Extension.swift
//  BerryQuest
//
//  Created by 김수경 on 10/12/24.
//

import UIKit

extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
}
