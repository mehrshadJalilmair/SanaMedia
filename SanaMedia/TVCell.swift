//
//  TVCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {

    @IBOutlet var container: UIView!
    @IBOutlet var _imageView: UIImageView!
    @IBOutlet var Title: UILabel!
    @IBOutlet var Decription: UILabel!
    
    var tv:TV!
    {
        didSet
        {
            updateCell()
        }
    }
    
    func updateCell()
    {
        Decription.text = tv?.Description
        Title.text = tv?.Title
        
        if (tv?.Icon)!.contains("/")
        {
            _imageView.loadImageWithCasheWithUrl((tv?.Icon)!)
        }
    }
    
    override func awakeFromNib() {
        
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        //container.backgroundColor = UIColor.white
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
