//
//  FileCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/25/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

protocol ebookPopupShow {
    
    func showEbookPopup(ebook: EBook)
}

class EbooksCell: UITableViewCell  , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var delegate:ebookPopupShow!
    
    let cellId = "Item"
    var newestEBooks:[Int:EBook] = [Int:EBook]()
    var newestEBooksIDs:[Int]!
    {
        didSet
        {
            collectionView.reloadData()
            collectionView.scrollsToTop = true
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    //collection view
    lazy var collectionView : UICollectionView! =
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            let width = ((SCREEN_SIZE.width) / 2) - 20
            let height = SCREEN_SIZE.width - SCREEN_SIZE.width/4
            layout.itemSize = CGSize(width: width, height: height)
            
            let collectionView : UICollectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(EbookCell.self, forCellWithReuseIdentifier: self.cellId)
            collectionView.backgroundColor = UIColor.lightGray
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: contentView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        collectionView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EbooksCell
{
    //collView funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return self.newestEBooks.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EbookCell
        
        let index = newestEBooksIDs[indexPath.row]
        let ebook = newestEBooks[index]
        
        cell.ebook = ebook
        
        cell.like.setTitle(ebook?.Likes, for: UIControlState.normal)
        cell.Description.text = ebook?.Title
        if (ebook?.Picture_Url.contains("/"))!
        {
            cell.trailer.loadImageWithCasheWithUrl((ebook?.Picture_Url)!)
        }
        
        if indexPath.row + 1 == self.newestEBooks.count {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MainHomeViewController1"), object: nil, userInfo: [ "tableViewCellIndex" : 3])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! EbookCell
        self.delegate.showEbookPopup(ebook: cell.ebook!)
    }
}
