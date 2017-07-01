//
//  DesignableLabel.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/1/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class DesignableLabel: UILabel {
    
    @IBInspectable var cornerRadius :CGFloat = 0.0 {
        
        didSet{
            self.layer.cornerRadius = (cornerRadius)
            layer.masksToBounds = true
        }
    }
}
