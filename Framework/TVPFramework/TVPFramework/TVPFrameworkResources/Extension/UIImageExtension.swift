

import UIKit

extension UIImage {
    
    //Image download with lazy loading
    //Loads image asynchronously
    public func loadFromURL(url: NSURL, callback: @escaping (UIImage)->()) {
        
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async {
            
            let imageData = NSData(contentsOf: url as URL)
            if let data = imageData {
                DispatchQueue.main.async(execute: {
                    if let image = UIImage(data: data as Data) {
                        callback(image)
                    }
                })
            }
        }
    }
    public func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
