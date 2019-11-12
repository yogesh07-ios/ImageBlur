//
//  ViewController.swift
//  Effect
//
//  Created by inheritex on 07/11/19.
//  Copyright © 2019 inheritex. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var imgBackground:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let panGest = UIPanGestureRecognizer(target: self, action: #selector(self.moveFigure(_:)))
        panGest.maximumNumberOfTouches = 1
        self.imgBackground.isUserInteractionEnabled = true
        self.imgBackground.addGestureRecognizer(panGest)
        //self.view.addGestureRecognizer(panGest)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
             let rect =  self.imgBackground.getImageViewAspectHeight()
             self.imgBackground.bounds.size.height = rect
        })
        
        self.imgBackground.layer.borderColor = UIColor.black.cgColor
        self.imgBackground.layer.borderWidth = 1.0
    }
    
    func croppIngimage(byImageName imageToCrop: UIImage?, to rect: CGRect) -> UIImage? {
        
        let imageRef = imageToCrop?.cgImage?.cropping(to: rect)
        var cropped: UIImage? = nil
        if let imageRef = imageRef {
            cropped = UIImage(cgImage: imageRef)
        }
       
        return cropped
    
    }
    
    func addImage(to img: UIImage?, withImage2 img2: UIImage?, andRect cropRect: CGRect) -> UIImage? {
        
        let size = CGSize(width: imgBackground.image!.size.width, height: imgBackground.image!.size.height)
        UIGraphicsBeginImageContext(size)
        
        let pointImg1 = CGPoint(x: 0, y: 0)
        img?.draw(at: pointImg1)
        
        let pointImg2 = cropRect.origin
        img2?.draw(at: pointImg2)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
   
    func roundedRectImage(from image: UIImage?, withRadious radious: CGFloat) -> UIImage? {
        
        if radious == 0.0 {
            return image
        }
        
        if image != nil {
            
            let imageWidth = image?.size.width
            let imageHeight = image?.size.height
            
            let rect = CGRect(x: 0.0, y: 0.0, width: imageWidth ?? 0.0, height: imageHeight ?? 0.0)
            let window = UIApplication.shared.windows[0]
            let scale = window.screen.scale
            UIGraphicsBeginImageContextWithOptions(rect.size, _: false, _: scale)
            
            let context = UIGraphicsGetCurrentContext()
            context?.beginPath()
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: radious, y: radious)
            
            let rectWidth = rect.width / radious
            let rectHeight = rect.height / radious
            
            context?.move(to: CGPoint(x: rectWidth, y: rectHeight / 2.0))
            context?.addArc(tangent1End: CGPoint(x: rectWidth, y: rectHeight), tangent2End: CGPoint(x: rectWidth / 2.0, y: rectHeight), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: 0.0, y: rectHeight), tangent2End: CGPoint(x: 0.0, y: rectHeight / 2.0), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: 0.0, y: 0.0), tangent2End: CGPoint(x: rectWidth / 2.0, y: 0.0), radius: radious)
            context?.addArc(tangent1End: CGPoint(x: rectWidth, y: 0.0), tangent2End: CGPoint(x: rectWidth, y: rectHeight / 2.0), radius: radious)
            context?.restoreGState()
            context?.closePath()
            context?.clip()
            
            image?.draw(in: CGRect(x: 0.0, y: 0.0, width: imageWidth ?? 0.0, height: imageHeight ?? 0.0))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
        return nil
    }
    
   
    
    @objc func moveFigure(_ sender:UIPanGestureRecognizer){
        var croppedImg: UIImage? = nil
        
        //let touch = touches.first
        var currentPoint = sender.location(in: self.imgBackground)
        
       
        let ratioW: Double = Double(imgBackground.image!.size.width / imgBackground.frame.size.width)
        let ratioH: Double = Double(imgBackground.image!.size.height / imgBackground.frame.size.height)

        
        currentPoint.x *= CGFloat(ratioW)
        currentPoint.y *= CGFloat(ratioH)
        
        let circleSizeW = 25 * ratioW
        let circleSizeH = 25 * ratioH
        
        
       currentPoint.x = CGFloat((Double(currentPoint.x ) - circleSizeW / 2 < 0) ? 0 : Double(currentPoint.x ) - circleSizeW / 2)
        currentPoint.y = CGFloat((Double(currentPoint.y ) - circleSizeH / 2 < 0) ? 0 : Double(currentPoint.y ) - circleSizeH / 2)
        
        
        let cropRect = CGRect(x: currentPoint.x , y: currentPoint.y , width: CGFloat(circleSizeW), height: CGFloat(circleSizeH))
        
        print(String(format: "x %0.0f, y %0.0f, width %0.0f, height %0.0f", cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height))
        
        croppedImg = croppIngimage(byImageName: imgBackground?.image, to: cropRect)
        
        // Blur Effect
        croppedImg = croppedImg?.withGaussianBlur9()
        
        
        // Contrast Effect
        // croppedImg = [croppedImg imageWithContrast:50];
       
        croppedImg = roundedRectImage(from: croppedImg, withRadious: 4)
        
        imgBackground.image = addImage(to: imgBackground.image, withImage2: croppedImg, andRect: cropRect)
        
       
    }

}


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

