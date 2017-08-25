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
        
        let urll:String = Singleton.getInstance().url_static_part + url_
        
        let escapedAddress = urll.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        //let urlpath = String(format: "\(String(describing: escapedAddress))")
        
        
        let url = URL(string: escapedAddress!)
        //print(url!)
        //print(singleton.url_static_part + url_)
        if url == nil
        {
            return
        }
        
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
                    self.image = nil
                }
            })
        }).resume()
    }
}
