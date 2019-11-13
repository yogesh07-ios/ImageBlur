//
//  Extension+UIImageView.swift
//  Effect
//
//  Created by inheritex on 13/11/19.
//  Copyright © 2019 inheritex. All rights reserved.
//

import Foundation
extension UIImageView{
    func getImageViewAspectHeight(_ width:CGFloat = UIScreen.main.bounds.width ,maxHeight:CGFloat = UIScreen.main.bounds.height) -> CGFloat{
        
        let w:CGFloat = (self.image?.size.width)! > width ? width : (self.image?.size.width)!
        let size = CGSize(width: w, height: maxHeight)
        if let image = self.image {
            let ratio = image.size.width / image.size.height
            if image.size.height < maxHeight {
                if image.size.width >  image.size.height{
                    let newHeight = (size.width / ratio)
                    if newHeight == image.size.height{
                        return size.width / ratio
                    }
                    return newHeight > maxHeight ? maxHeight : newHeight
                }else{
                    let newHeight = (image.size.height * ratio)
                    if newHeight == image.size.width{
                        return size.width / ratio
                    }
                    return newHeight > maxHeight ? maxHeight : newHeight
                }
            }
            
            
            if image.size.width >  image.size.height{
                let newHeight = (size.width / ratio)
                if newHeight == image.size.height{
                    return size.width / ratio
                }
                return newHeight > maxHeight ? maxHeight : newHeight
            }else{
                let newHeight = (image.size.height * ratio)
                if newHeight == image.size.width{
                    return size.width / ratio
                }
                return newHeight > maxHeight ? maxHeight : newHeight
            }
            
            
        }
        return maxHeight
    }
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        
        return CGRect(x: x, y: y, width: size.width , height: size.height)
    }
}
