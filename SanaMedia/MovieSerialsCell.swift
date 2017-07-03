//
//  MovieSerialsCell.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/23/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

protocol serialPopupShow {
    
    func showSerialPopup(serial: MovieSerial)
}

class MovieSerialsCell:UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    var delegate:serialPopupShow!
    
    let cellId = "Item"
    var newestMovieSerials:[Int:MovieSerial] = [Int:MovieSerial]()
    var newestMovieSerialsIDs:[Int]!
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
            collectionView.register(MovieSerialCell.self, forCellWithReuseIdentifier: self.cellId)
            collectionView.backgroundColor = UIColor.white
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


extension MovieSerialsCell
{
    //collView funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return self.newestMovieSerials.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MovieSerialCell
        
        let index = newestMovieSerialsIDs[indexPath.row]
        let movie = newestMovieSerials[index]
        
        cell.serial = movie
        
        let episods = movie?.Episodes!
        cell.Description.text = movie?.Description
        cell.episodes.text = "\(String(describing: episods!))" + "قسمت "
        if (movie?.Picture_URLS[0])!.contains("/")
        {
            cell.trailer.loadImageWithCasheWithUrl((movie?.Picture_URLS[0])!)
        }
        
        if indexPath.row + 1 == self.newestMovieSerials.count {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MainHomeViewController1"), object: nil, userInfo: [ "tableViewCellIndex" : 5])
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MovieSerialCell
        self.delegate.showSerialPopup(serial: cell.serial!)
    }
}
