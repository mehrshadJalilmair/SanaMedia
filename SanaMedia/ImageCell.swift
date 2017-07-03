//
//  ImageCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/25/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var image:Image?
    
    let container : UIView! =
    {
        var container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let trialer : UIImageView! =
    {
        var trialer = UIImageView()
        trialer.translatesAutoresizingMaskIntoConstraints = false
        trialer.contentMode = .scaleToFill
        return trialer
    }()
    
    let line : UIView! =
    {
        var line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        return line
    }()
    
    let like : DesignableButton! =
    {
        var like = DesignableButton()
        like.translatesAutoresizingMaskIntoConstraints = false
        like.setImage(UIImage(named:"heart-outline (1)"), for: UIControlState.normal)
        like.tintColor = UIColor.white
        like.cornerRadius = 3
        //like.setImage(UIImage(named:"fluid_graph"), for: .normal)
        like.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        like.setTitleColor(UIColor.white, for: UIControlState.normal)
        return like
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        //x
        var horizontalConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        //w
        var widthConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        var heightConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -2)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        container.layer.cornerRadius = 2
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        
        container.addSubview(trialer)
        //x
        horizontalConstraint = NSLayoutConstraint(item: trialer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: trialer, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: trialer, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: trialer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -30)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        container.addSubview(line)
        //x
        horizontalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: trialer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        container.addSubview(like)
        //x
        horizontalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: line, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 2)
        //y
        verticalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
