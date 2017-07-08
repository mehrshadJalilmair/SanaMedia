//
//  albumMusicCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/8/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class albumMusicCell: UITableViewCell {
    
    var music:Music!
    {
        didSet
        {
            updateUI()
        }
    }
    
    func updateUI()
    {
        self.name.text = self.music.Title
        self.duratioin.text = self.music.Duration
    }
    
    var icon:UIImageView! =
    {
        var imagev = UIImageView()
        imagev.translatesAutoresizingMaskIntoConstraints = false
        imagev.image = UIImage(named:"ic_music")
        return imagev
    }()
    var line:UIView! =
    {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
        return view
    }()
    var name:UILabel! =
    {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
        return view
    }()
    var duratioin:UILabel! =
    {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
        return view
    }()
    
    override func awakeFromNib() {
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(icon)
        //x
        var horizontalConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        //w
        var widthConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
        //h
        var heightConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint ,heightConstraint])
        
        contentView.addSubview(name)
        //x
        horizontalConstraint = NSLayoutConstraint(item: name, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5)
        //w
        widthConstraint = NSLayoutConstraint(item: name, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: name, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, widthConstraint, heightConstraint])
        
        contentView.addSubview(duratioin)
        //x
        horizontalConstraint = NSLayoutConstraint(item: duratioin, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: duratioin, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: duratioin, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, widthConstraint, heightConstraint])
        
        contentView.addSubview(line)
        //x
         horizontalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: duratioin, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //y
         verticalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //w
         widthConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: contentView.frame.width - 15)
        //h
         heightConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint ,heightConstraint])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
