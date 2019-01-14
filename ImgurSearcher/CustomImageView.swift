//
//  UIImageViewExtension.swift
//  ImgurSearcher
//
//  Created by Mohamed Ayadi on 1/13/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {
    
    var urlString: String?
    
    func loadImage(with url: URL){
        
        urlString = url.absoluteString
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = self.frame
        self.addSubview(spinner)
        image = nil
        //If image has already been loaded, pull from cache instead of loading twice
        if let image = imageCache.object(forKey: NSString(string: url.absoluteString)) as? UIImage {
            self.image = image
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            return
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                DispatchQueue.main.async {
                    guard let data = data,
                        let imageToCache = UIImage(data: data) else {return}
                    if self.urlString == url.absoluteString {
                        self.image = imageToCache
                        spinner.stopAnimating()
                        spinner.removeFromSuperview()
                    }
                    imageCache.setObject(imageToCache, forKey: NSString(string: url.absoluteString))
                    if let error = error {
                        print ("Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
}

