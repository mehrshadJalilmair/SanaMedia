//
//  NewsCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet var container: UIView!
    @IBOutlet var _imageView: UIImageView!
    @IBOutlet var Title: UILabel!
    @IBOutlet var Content: UILabel!
    @IBOutlet var date: DesignableButton!
    @IBOutlet var likesCount: DesignableButton!
    
    var news:News!
    {
        didSet
        {
            updateCell()
        }
    }
    
    func updateCell()
    {
        Content.text = news?.Content
        Title.text = news?.Title
        likesCount.setTitle(news?.Likes!, for: UIControlState.normal)
        
        let s:NSString = NSString(string: (news?.Date)!)
        let date = s.substring(with: NSRange(location: 0 , length: 16))
        self.date.setTitle(date, for: UIControlState.normal)
        
        
        if (news?.Image_Url)!.contains("/")
        {
            _imageView.loadImageWithCasheWithUrl((news?.Image_Url)!)
        }
    }
    
    override func awakeFromNib() {
        
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
