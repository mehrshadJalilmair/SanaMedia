//
//  DesignableButton.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/19/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var borderWidth :CGFloat = 0.0 {
        
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.black.withAlphaComponent(0.5) {
        
        didSet{
            self.layer.borderColor = (borderColor.cgColor)
        }
    }
    
    @IBInspectable var cornerRadius :CGFloat = 0.0 {
        
        didSet{
            self.layer.cornerRadius = (cornerRadius)
        }
    }
}
