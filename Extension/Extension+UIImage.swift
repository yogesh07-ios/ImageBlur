//
//  Extension+UIImage.swift
//  Effect
//
//  Created by inheritex on 13/11/19.
//  Copyright © 2019 inheritex. All rights reserved.
//

import Foundation
extension UIImage{
    func imageWithGaussianBlur9() -> UIImage? {
        let weight = [0.1270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162]
        // Blur horizontally
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[0]))
        for x in 1..<5 {
            draw(in: CGRect(x: CGFloat(x), y: 0, width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[x]))
            draw(in: CGRect(x: CGFloat(-x), y: 0, width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[x]))
        }
        let horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Blur vertically
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: scale)
        horizBlurredImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[0]))
        for y in 1..<5 {
            horizBlurredImage?.draw(in: CGRect(x: 0, y: CGFloat(y), width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[y]))
            horizBlurredImage?.draw(in: CGRect(x: 0, y: CGFloat(-y), width: size.width, height: size.height), blendMode: .normal, alpha: CGFloat(weight[y]))
        }
        let blurredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //
        return blurredImage
    }
}
