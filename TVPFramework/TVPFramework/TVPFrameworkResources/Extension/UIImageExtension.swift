//
//  UIImageExtension.swift
//  TVPagePhase2
//


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
}
