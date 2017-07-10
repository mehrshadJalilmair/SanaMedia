//
//  MusicFilter.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/10/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//
//

import UIKit
import Alamofire


var MusicGenres:[String] = [String]()
var FilterMusics:[Music] = [Music]()

class MusicFilter: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var container: UIView = UIView()
    
    let cellId = "Item"
    var newsPageSize:Int = 10
    var newsPageIndex:Int = 0
    var pageSize:Int = 10
    
    let CellId5 = "TVCellId"
    lazy var tableView : UITableView! =
        {
            let tableView : UITableView = UITableView(frame: self.view.frame)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.register(genreCellTableViewCell.self, forCellReuseIdentifier: self.CellId5)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
    }()
    
    let topButton:DesignableButton! = {
        
        var btn = DesignableButton()
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ژانرها", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(MovieFilter.GenresClicked), for: .touchUpInside)
        btn.borderWidth = 0.25
        return btn
    }()
    
    //collection view
    lazy var collectionView : UICollectionView! =
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            let width = ((SCREEN_SIZE.width) / 2) - 5
            let height = SCREEN_SIZE.width - SCREEN_SIZE.width/4
            
            layout.itemSize = CGSize(width: width, height: height)
            
            let collectionView : UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(MusicCell.self, forCellWithReuseIdentifier: self.cellId)
            collectionView.backgroundColor = UIColor.lightGray
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        configTableView()
        configCollectionView()
        
        collectionView.isHidden = true
    }
    
    func initView()
    {
        self.view.addSubview(topButton)
        //x
        let horizontalConstraint = NSLayoutConstraint(item: topButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: topButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: topButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: topButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40.0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func configTableView()
    {
        view.addSubview(tableView)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func configCollectionView()
    {
        view.addSubview(collectionView)
        //x
        let horizontalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topButton, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        collectionView.backgroundColor = UIColor.white
    }
    
    @objc func GenresClicked()
    {
        if MusicGenres.count > 0
        {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = true
        
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["genres"]!, "music")
        let url = Singleton.getInstance().url_static_part + url_dynamic_part
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let data = response.result.value as! [String:AnyObject]
                //let itemsCount:Int = Int(data["itemsCount"] as! String)!
                let _Genres = data["Genres"] as! [AnyObject]
                
                MusicGenres = [String]()
                
                for genre in _Genres
                {
                    let name = genre["Main_Genre"] as! String
                    MusicGenres.append(name)
                }
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        }
    }
    
    var selectedGenreIndex = 0
    func GenresSelected()
    {
        let genre_first_level = MusicGenres[selectedGenreIndex]
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["musics_by_genre"]!, "\(pageSize)" , "\(newsPageIndex+1)" , genre_first_level)
        let url = Singleton.getInstance().url_static_part + url_dynamic_part
        
        showActivityIndicatory(uiView: self.view)
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let data = response.result.value as! [String:AnyObject]
                let itemsCount:Int = data["itemsCount"] as! Int
                let images = data["music"] as! [AnyObject]
                
                self.newsPageSize = itemsCount/10 + 1
                self.newsPageIndex += 1
                
                for movie in images
                {
                    let newImage = Music(music: movie)
                    FilterMusics.append(newImage)
                }
                
                DispatchQueue.main.async {
                    
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        }
        self.container.removeFromSuperview()
    }
}
extension MusicFilter
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MusicGenres.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId5, for: indexPath) as! genreCellTableViewCell
        cell.textLabel?.text = MusicGenres[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.textAlignment = .right
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        selectedGenreIndex = indexPath.row
        self.newsPageSize = 10
        self.newsPageIndex = 0
        FilterMusics = [Music]()
        GenresSelected()
    }
    
    //collView funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return FilterMusics.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MusicCell
        
        let music = FilterMusics[indexPath.row]
        
        cell.music = music
        
        cell.like.setTitle(music.Likes, for: UIControlState.normal)
        cell.Description.text = music.Title
        if (music.Picture_URLS[0].contains("/"))
        {
            cell.trailer.loadImageWithCasheWithUrl((music.Picture_URLS[0]))
        }
        
        if indexPath.row + 1 == FilterMusics.count {
            
            if self.newsPageSize < newsPageIndex
            {
                
            }
            else
            {
                GenresSelected()
            }
        }
        else
        {
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "musicPopup") as! musicPopup
        controller.music = FilterMusics[indexPath.row]
        self.present(controller, animated: true, completion: nil)
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)//UIColorFromHex(0xffffff, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
}







