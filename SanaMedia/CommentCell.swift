//
//  CommentCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/27/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var line:UIView! =
    {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.purple
        return view
    }()
    var date:UILabel! =
    {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.white
        view.textColor = UIColor.lightGray
        return view
    }()
    var content:UILabel! =
    {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor.white
        view.textAlignment = .right
        view.textColor = UIColor.black
        view.numberOfLines = 1
        return view
    }()
    
    
    var comment:Comment!
    {
        didSet
        {
            updateCell()
        }
    }
    
    func updateCell()
    {
        contentView.addSubview(date)
        //x
        var horizontalConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -3)
        //y
        let verticalConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: +6)
        
        //h
        var heightConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint])
        
        contentView.addSubview(content)
        //x
        horizontalConstraint = NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -3)
        //w
        var widthConstraint = NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: date, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +1)
        NSLayoutConstraint.activate([horizontalConstraint, widthConstraint, heightConstraint])
        
        contentView.addSubview(line)
        //x
        horizontalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: content, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +1)
        //w
         widthConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: +1)
        NSLayoutConstraint.activate([horizontalConstraint, widthConstraint, heightConstraint])
        
        let s:NSString = NSString(string: (comment?.Date)!)
        let Date = s.substring(with: NSRange(location: 0 , length: 16))
        self.date.text = Date
        
        self.content.text = comment.Content!
    }
    
    override func awakeFromNib() {
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
