//
//  Search.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/3/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire
import EasyToast

enum searchType {
    case movie
    case music
    case image
    case ebook
    case serial
    case album
    case none
}
var searchType_:searchType = .none

class Search: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var SearchResults:[AnyObject]!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var seachBar: UISearchBar!
    @IBOutlet var inputTextLabel: UILabel!
    var container: UIView = UIView()
    let cellId1 = "Item1"
    let cellId2 = "Item2"
    let cellId3 = "Item3"
    let cellId4 = "Item4"
    let cellId5 = "Item5"
    let cellId6 = "Item6"
    var newsPageSize:Int = 10
    var newsPageIndex:Int = 0
    var pageSize:Int = 10
    
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
            collectionView.register(VideoCell.self, forCellWithReuseIdentifier: self.cellId1)
            collectionView.register(MovieSerialCell.self, forCellWithReuseIdentifier: self.cellId6)
            collectionView.register(MusicCell.self, forCellWithReuseIdentifier: self.cellId2)
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: self.cellId3)
            collectionView.register(EbookCell.self, forCellWithReuseIdentifier: self.cellId4)
            collectionView.register(MusicAlbumCell.self, forCellWithReuseIdentifier: self.cellId5)
            collectionView.backgroundColor = UIColor.lightGray
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchResults = [AnyObject]()
        configCollectionView()
    }
    
    func configCollectionView()
    {
        view.addSubview(collectionView)
        //x
        let horizontalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: collectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        collectionView.backgroundColor = UIColor.white
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    @IBAction func doSearch(_ sender: Any) {
        
        if seachBar.text! == "" {
            
            return
        }
        self.view.endEditing(true)
        Searching()
    }
    
    func Searching()
    {
        let escapedString = self.seachBar.text!.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        var url:String!
        var url_dynamic_part:String!
        
        switch searchType_ {
            
        case .movie:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["movie_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        case .music:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["music_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        case .serial:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["movie_serial_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        case .image:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["image_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        case .album:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["music_album_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        case .ebook:
            url_dynamic_part = String.localizedStringWithFormat(singleton.URLS["ebook_search"]!, escapedString! , "\(newsPageIndex + 1)" , "\(pageSize)")
            break
            
        default:
            break
        }
        
        
        url = Singleton.getInstance().url_static_part + url_dynamic_part
        //let escapedString = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        showActivityIndicatory(uiView: self.view)
        Alamofire.request(url , method: .get , encoding: URLEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let data = response.result.value as! [String:AnyObject]
                
                if let a = data["data"]
                {
                    self.view.showToast(a as! String, position: .bottom, popTime: 2, dismissOnTap: false)
                    if a as! String == "Empty Param"
                    {
                        return
                    }
                    
                    if a as! String == "Bad Requests"
                    {
                        return
                    }
                }
                
                let itemsCount:Int = data["itemsCount"] as! Int
                self.newsPageSize = itemsCount/10 + 1
                self.newsPageIndex += 1
                
                DispatchQueue.main.async {
                    
                    if itemsCount == 0
                    {
                        self.view.showToast("نتیجه ای یافت نشد!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                
                switch searchType_ {
                    
                case .movie:
                    
                    let movies = data["movie"] as! [AnyObject]
                    for movie in movies
                    {
                        let newMovie = Movie(movie: movie)
                        self.SearchResults.append(newMovie)
                    }
                    
                    break
                    
                case .music:
                    let images = data["musics"] as! [AnyObject]
                    for movie in images
                    {
                        let newImage = Music(music: movie)
                        self.SearchResults.append(newImage)
                    }
                    break
                    
                case .serial:
                    let images = data["movie_serials"] as! [AnyObject]
                    for movie in images
                    {
                        let newImage = MovieSerial(movie: movie)
                        self.SearchResults.append(newImage)
                    }
                    break
                    
                case .image:
                    let images = data["Images"] as! [AnyObject]
                    for movie in images
                    {
                        let newImage = Image(image: movie)
                        self.SearchResults.append(newImage)
                    }
                    break
                    
                case .album:
                    
                    let images = data["musicalbums"] as! [AnyObject]
                    
                    for movie in images
                    {
                        let newImage = Music(music: movie)
                        self.SearchResults.append(newImage)
                    }
                    
                    break
                    
                case .ebook:
                    let images = data["ebooks"] as! [AnyObject]
                    for movie in images
                    {
                        let newImage = EBook(ebook: movie)
                        self.SearchResults.append(newImage)
                    }
                    break
                    
                default:
                    break
                }
                
                self.container.removeFromSuperview()
                break
                
            case .failure(let error):
                
                self.container.removeFromSuperview()
                print(error)
                break
            }
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
            }
        }
    }
}

extension Search
{
    //collView funcs
    //collView funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return SearchResults.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch searchType_ {
            
        case .movie:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! VideoCell
            
            let movie = SearchResults[indexPath.row] as! Movie
            
            cell.movie = (movie)
            
            cell.time.text = movie.Duration
            cell.Description.text = movie.Description
            cell.like.setTitle(movie.Likes, for: UIControlState.normal)
            
            if (movie.Picture_URLS[0]).contains("/")
            {
                cell.trailer.loadImageWithCasheWithUrl((movie.Picture_URLS[0]))
            }
            
            return cell
            
        case .music:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! MusicCell
            
            let music = SearchResults[indexPath.row] as! Music
            
            cell.music = music
            
            cell.like.setTitle(music.Likes, for: UIControlState.normal)
            cell.Description.text = music.Title
            if (music.Picture_URLS[0].contains("/"))
            {
                cell.trailer.loadImageWithCasheWithUrl((music.Picture_URLS[0]))
            }
            return cell
            
        case .serial:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId6, for: indexPath) as! MovieSerialCell
            
            let movie = SearchResults[indexPath.row] as! MovieSerial
            
            cell.serial = movie
            
            let episods = movie.Episodes!
            cell.Description.text = movie.Description
            cell.episodes.text = "\(String(describing: episods))" + "قسمت "
            if (movie.Picture_URLS[0]).contains("/")
            {
                cell.trailer.loadImageWithCasheWithUrl((movie.Picture_URLS[0]))
            }
            return cell
            
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ImageCell
            
            let image = SearchResults[indexPath.row] as! Image
            
            cell.image = image
            
            cell.like.setTitle(image.Likes, for: UIControlState.normal)
            if (image.URL.contains("/"))
            {
                cell.trialer.loadImageWithCasheWithUrl((image.URL)!)
            }
            
            return cell
            
        case .album:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId5, for: indexPath) as! MusicAlbumCell
            
            let music = SearchResults[indexPath.row] as! Music
            
            cell.album = music
            
            cell.like.setTitle(music.Likes, for: UIControlState.normal)
            cell.Description.text = music.Title
            if (music.Picture_URLS[0].contains("/"))
            {
                cell.trailer.loadImageWithCasheWithUrl((music.Picture_URLS[0]))
            }
            return cell
            
        case .ebook:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId4, for: indexPath) as! EbookCell
            
            let ebook = SearchResults[indexPath.row] as! EBook
            
            cell.ebook = ebook
            
            cell.like.setTitle(ebook.Likes, for: UIControlState.normal)
            cell.Description.text = ebook.Title
            if (ebook.Picture_Url.contains("/"))
            {
                cell.trailer.loadImageWithCasheWithUrl((ebook.Picture_Url)!)
            }
            return cell
            
        default:
            break
        }
        
        if indexPath.row + 1 == SearchResults.count {
            
            if self.newsPageSize < newsPageIndex
            {
                
            }
            else
            {
                Searching()
            }
        }
        else
        {
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch searchType_ {
            
        case .movie:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "moviePopup") as! moviePopup
            controller.movie = SearchResults[indexPath.row] as! Movie
            self.present(controller, animated: true, completion: nil)
            break
            
        case .music:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "musicPopup") as! musicPopup
            controller.music = SearchResults[indexPath.row] as! Music
            self.present(controller, animated: true, completion: nil)
            break
            
        case .serial:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "serialPopup") as! serialPopup
            controller.serial = SearchResults[indexPath.row] as! MovieSerial
            self.present(controller, animated: true, completion: nil)
            break
            
        case .image:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "imagePopup") as! imagePopup
            controller.image = SearchResults[indexPath.row] as! Image
            self.present(controller, animated: true, completion: nil)
            break
            
        case .album:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "albumPopup") as! albumPopup
            controller.album = SearchResults[indexPath.row] as! Music
            self.present(controller, animated: true, completion: nil)
            break
            
        case .ebook:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ebookPopup") as! ebookPopup
            controller.ebook = SearchResults[indexPath.row] as! EBook
            self.present(controller, animated: true, completion: nil)
            break
            
        default:
            break
        }
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
