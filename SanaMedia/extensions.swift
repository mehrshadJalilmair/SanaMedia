//
//  extensions.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/25/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageWithCasheWithUrl(_ url_ : String){
        
        self.image = nil
        
        if let imageCached = imageCache.object(forKey: "\(url_)" as AnyObject) as? UIImage{
            
            self.image = imageCached
            return
        }
        
        let url = URL(string: singleton.url_static_part + url_)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data : data!){
                    
                    imageCache.setObject(downloadedImage , forKey: url_ as AnyObject)
                    self.image = downloadedImage
                }
                else
                {
                    //self.image = UIImage(named: "")
                }
            })
        }).resume()
    }
}
