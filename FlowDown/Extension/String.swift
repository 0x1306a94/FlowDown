//
//  String.swift
//  FlowDown
//
//  Created by 秋星桥 on 2/2/25.
//

import Foundation
import UIKit

extension String {
    var sanitizedFileName: String {
        components(separatedBy: .init(charactersIn: #"/\:?%*|"<>"#)).joined(separator: "_")
    }
}

extension String {
    func textToImage(size: CGFloat = 64) -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: size)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context

        return image ?? UIImage()
    }
}
