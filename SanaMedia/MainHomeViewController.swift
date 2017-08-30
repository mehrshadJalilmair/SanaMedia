//
//  MainHomeViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Cosmos
import PDFReader
import Alamofire
var adType:String!
var adUrl:String!
import AVFoundation
import AVKit

class MainHomeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , moviePopupShow , serialPopupShow , musicPopupShow , albumPopupShow , imagePopupShow , ebookPopupShow , UIDocumentInteractionControllerDelegate{
    
    var container: UIView = UIView()
    
    @IBOutlet var feedBackView: UIView!
    @IBOutlet var opinion: FloatLabelTextField!
    @IBOutlet var rate5: CosmosView!
    @IBOutlet var rate4: CosmosView!
    @IBOutlet var rate3: CosmosView!
    @IBOutlet var rate2: CosmosView!
    @IBOutlet var rate1: CosmosView!
    
    //show dialogs when pressing items in sectios in home
    var popupMovie:Movie!
    var popupMusic:Music!
    var popupImage:Image!
    var popupAlbum:Music!
    var popupSerial:MovieSerial!
    var popupEBook:EBook!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        //feedBackView.removeFromSuperview()
    }
    
    
    @IBAction func closeRating(_ sender: Any) {
        
        feedBackView.removeFromSuperview()
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
    
    func FeedBack()
    {
        self.view.addSubview(feedBackView)
        feedBackView.center = self.view.center
    }
    
    
    @IBAction func sendFeedBack(_ sender: Any) {
        
        showActivityIndicatory(uiView: self.view)
        let url_dynamic_part = singleton.URLS["survay"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "question1":"کیفیت گرافیک سایت",
            "question2":"کیفیت ویدئو",
            "question3":"کیفیت موزیک",
            "question4":"کیفیت عکس",
            "question5":"کیفیت کتاب",
            "answer1":rate1.rating,
            "answer2":rate2.rating,
            "answer3":rate3.rating,
            "answer4":rate4.rating,
            "answer5":rate5.rating,
            "comment":opinion.text!
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["Survay_Register"]
                {
                    if status == "true"
                    {
                        DispatchQueue.main.async {
                            
                            self.view.showToast("نظر شما ثبت شد.", position: .bottom, popTime: 2, dismissOnTap: false)
                            self.feedBackView.removeFromSuperview()
                        }
                    }
                    else
                    {
                        self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                else
                {
                    self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                
                break
                
            case .failure( _):
                DispatchQueue.main.async {
                    
                    self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                break
            }
            self.container.removeFromSuperview()
        }
    }
    
    func showMoviePopup(movie: Movie) {
        
        DispatchQueue.main.async {
            
            self.popupMovie = movie
            self.performSegue(withIdentifier: "moviePopup", sender: self)
        }
    }
    func showSerialPopup(serial:MovieSerial) {
        
        DispatchQueue.main.async {
            
            self.popupSerial = serial
            self.performSegue(withIdentifier: "serialPopup", sender: self)
        }
    }
    func showImagePopup(image: Image) {
        
        DispatchQueue.main.async {
            
            self.popupImage = image
            self.performSegue(withIdentifier: "imagePopup", sender: self)
        }
    }
    func showEbookPopup(ebook: EBook) {
        
        DispatchQueue.main.async {
            
            self.popupEBook = ebook
            self.performSegue(withIdentifier: "ebookPopup", sender: self)
        }
    }
    func showAlbumPopup(album: Music) {
        
        DispatchQueue.main.async {
            
            self.popupAlbum = album
            self.performSegue(withIdentifier: "albumPopup", sender: self)
        }
    }
    func showMusicPopup(music: Music) {
        
        DispatchQueue.main.async {
            
            self.popupMusic = music
            self.performSegue(withIdentifier: "musicPopup", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier!
        {
        case "moviePopup":
            let nextScene =  segue.destination as? moviePopup
            nextScene?.movie = popupMovie
            break
            
        case "serialPopup":
            let nextScene =  segue.destination as? serialPopup
            nextScene?.serial = popupSerial
            break
            
        case "imagePopup":
            let nextScene =  segue.destination as? imagePopup
            nextScene?.image = popupImage
            break
            
        case "ebookPopup":
            let nextScene =  segue.destination as? ebookPopup
            nextScene?.ebook = popupEBook
            break
            
        case "albumPopup":
            let nextScene =  segue.destination as? albumPopup
            nextScene?.album = popupAlbum
            break
            
        case "musicPopup":
            let nextScene =  segue.destination as? musicPopup
            nextScene?.music = popupMusic
            break
        default:
            break
        }
    }
    
    
    // continue to coding
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var mostLikes: DesignableButton!
    @IBOutlet weak var recentDate: DesignableButton!
    
    //table view
    let CellId0 = "VideosCellId"
    let CellId1 = "ImagesCellId"
    let CellId2 = "MusicsCellId"
    let CellId3 = "EbooksCellId"
    let CellId4 = "MusicAlbumsCellId"
    let CellId5 = "MovieSerialsCellId"
    
    lazy var tableView : UITableView! =
    {
        let tableView : UITableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(VideosCell.self, forCellReuseIdentifier: self.CellId0)
        tableView.register(MusicsCell.self, forCellReuseIdentifier: self.CellId2)
        tableView.register(ImagesCell.self, forCellReuseIdentifier: self.CellId1)
        tableView.register(EbooksCell.self, forCellReuseIdentifier: self.CellId3)
        tableView.register(MusicsAlbumsCell.self, forCellReuseIdentifier: self.CellId4)
        tableView.register(MovieSerialsCell.self, forCellReuseIdentifier: self.CellId5)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let sectionHeaderSize = CGFloat(45.0)
    let tableViewSectionsTitle:[String] = ["فیلم ها" , "تصاویر" , "موسیقی" , "کتاب" , "آلبوم موسیقی" , "سریال"]
    
    
    //: Main tab vars
    var newestMovies:[Int:Movie] = [Int:Movie]()
    var newestMoviesIDs:[Int] = [Int]()
    var newestMusics:[Int:Music] = [Int:Music]()
    var newestMusicsIDs:[Int] = [Int]()
    var newestImages:[Int:Image] = [Int:Image]()
    var newestImagesIDs:[Int] = [Int]()
    var newestEBooks:[Int:EBook] = [Int:EBook]()
    var newestEBooksIDs:[Int] = [Int]()
    var newestMusicAlbums:[Int:Music] = [Int:Music]()
    var newestMusicAlbumsIDs:[Int] = [Int]()
    var newestMovieSerials:[Int:MovieSerial] = [Int:MovieSerial]()
    var newestMovieSerialsIDs:[Int] = [Int]()
    
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    
    //: uses in ip dynamic part for page indexing
    var queryType:String = "date"
    var moviesPageSize:Int = 10
    var moviesPageIndex:Int = 0
    var musicsPageSize:Int = 10
    var musicsPageIndex:Int = 0
    var imagesPageSize:Int = 10
    var imagesPageIndex:Int = 0
    var ebooksPageSize:Int = 10
    var ebooksPageIndex:Int = 0
    var musicAlbumsPageSize:Int = 10
    var musicAlbumsPageIndex:Int = 0
    var movieSerialsPageSize:Int = 10
    var movieSerialsPageIndex:Int = 0
    let pageSize:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: navBar)
        configTableView()
        getInitData()
        
        checkInterview()
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
//        DispatchQueue.main.async {
//
//            if let url = URL(string: "http://192.168.123.100/hls/bunny.mp4/index.m3u8"){
//
//                print(url)
//                var player1:AVPlayer!
//                var controller1:AVPlayerViewController!
//                player1 = AVPlayer(url: url)
//                controller1=AVPlayerViewController()
//                controller1.player=player1
//                //controller.view.frame = self.view.frame
//                //self.view.addSubview(controller.view)
//                //self.addChildViewController(controller)
//                //player.play()
//                self.present(controller1, animated: true) {
//                    player1.play()
//
//                }
//            }
//        }
        
//        if let url = URL(string: "http://omoor-daneshjooei.iut.ac.ir/sites/omoor-daneshjooei.iut.ac.ir/files/files/at.pdf") {
//
//            //UIApplication.shared.openURL(url)
//
//            let data = try! Data(contentsOf: url)
//            //Get the local docs directory and append your local filename.
//            var docURL = (FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)).last as URL?
//            docURL = (docURL?.appendingPathComponent( "myFileName_\(Date().description).pdf") as! URL)
//
//            //Lastly, write your file to the disk.
//            do
//            {
//                try data.write(to: docURL! as URL)
//            }
//            catch(_)
//            {
//
//            }
//        }
        
        
//        DispatchQueue.main.async {
//            let remotePDFDocumentURLPath = "http://omoor-daneshjooei.iut.ac.ir/sites/omoor-daneshjooei.iut.ac.ir/files/files/at.pdf"
//            let remotePDFDocumentURL = URL(string: remotePDFDocumentURLPath)!
//            let document = PDFDocument(url: remotePDFDocumentURL)!
//            let readerController = PDFViewController.createNew(with: document)
//
//            //self.navigationController?.pushViewController(readerController, animated: true)
//
//            let navigationController = UINavigationController(rootViewController: readerController)
//            self.present(navigationController, animated: true, completion: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //: adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: NSNotification.Name(rawValue: "MainHomeViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMoreItem(_:)), name: NSNotification.Name(rawValue: "MainHomeViewController1"), object: nil) // for scrolling more
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //: removing observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MainHomeViewController"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MainHomeViewController1"), object: nil) // for scrolling more
    }
    
    func getInitData()
    {
        if let token = UserDefaults.standard.value(forKey: "token")
        {
            User.getInstance().token = token as! String
        }
        else
        {
            User.getInstance().token = ""
        }
        
        //: getting init data
        self.getNewest(urlKey: "newest_movies" , function: "getNewestMovies" , pageSize: pageSize , pageIndex:  moviesPageIndex)
        self.getNewest(urlKey: "newest_musics" , function: "getNewestMusics" , pageSize: pageSize , pageIndex:  musicsPageIndex)
        self.getNewest(urlKey: "newest_ebooks" , function: "getNewestEBooks" , pageSize: pageSize , pageIndex:  ebooksPageIndex)
        self.getNewest(urlKey: "newest_images" , function: "getNewestImages" , pageSize: pageSize , pageIndex:  imagesPageIndex)
        self.getNewest(urlKey: "newest_music_album" , function: "getNewestMusicAlbums" , pageSize: pageSize , pageIndex:  musicAlbumsPageIndex)
        self.getNewest(urlKey: "newest_moive_serials" , function: "getNewestMovieSerials" , pageSize: pageSize , pageIndex:  musicAlbumsPageIndex)
    }
    
    //: handles requests for getting newest movies to server
    func getNewest(urlKey:String , function:String , pageSize:Int , pageIndex:Int)
    {
        requestType = .get
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS[urlKey]!, "\(pageSize)" , "\(pageIndex+1)" , queryType)
        singleton.requestToServer(requestType: requestType, requesterData: ["url_dynamic_part":url_dynamic_part , "func":function , "class":"MainHomeViewController"], body: [:])
    }
    
    //: handles data when recieved from server
    @objc func notificationReceived(_ notification: Notification)
    {
        let error = notification.userInfo?["error"] as! String
        let data = notification.userInfo?["data"] as! [String:AnyObject]
        let function = notification.userInfo?["func"] as!String
        
        switch function {
            
        case "getNewestMovies":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMovies(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestMusics":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMusics(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestEBooks":
            
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestEBooks(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
            
        case "getNewestImages":
            
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestImages(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
        case "getNewestMusicAlbums":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMusicAlbums(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
        case "getNewestMovieSerials":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestMovieSerials(data: data)
                    DispatchQueue.main.async { //ui thread
                        
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                //show error
            }
            break
            
        default:
            break
        }
    }
    
    func getNewestMovies(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let movies:[AnyObject] = data["movie"] as! [AnyObject]
        
        adType = data["advertisementtype"] as! String
        adUrl = data["advertisementurl"] as! String
        
        
        self.moviesPageIndex += 1
        self.moviesPageSize = itemsCount/10 + 1
        
        for movie in movies {
            
            let newMovie = Movie(movie: movie)
            self.newestMovies[newMovie.Id] = newMovie
            self.newestMoviesIDs.append(newMovie.Id)
        }
    }
    
    func getNewestMusics(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let musics:[AnyObject] = data["musics"] as! [AnyObject]
        
        self.musicsPageSize = itemsCount/10 + 1
        self.musicsPageIndex += 1
        
        for music in musics {
            
            let newMusic = Music(music: music)
            self.newestMusics[newMusic.Id] = newMusic
            self.newestMusicsIDs.append(newMusic.Id)
        }
    }
    
    func getNewestEBooks(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let ebooks:[AnyObject] = data["ebooks"] as! [AnyObject]
        
        self.ebooksPageSize = itemsCount/10 + 1
        self.ebooksPageIndex += 1
        
        for ebook in ebooks {
            
            let newEbook = EBook(ebook: ebook)
            self.newestEBooks[newEbook.Id] = newEbook
            self.newestEBooksIDs.append(newEbook.Id)
        }
    }
    
    func getNewestImages(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let Images:[AnyObject] = data["Images"] as! [AnyObject]
        
        self.imagesPageSize = itemsCount/10 + 1
        self.imagesPageIndex += 1
        
        for image in Images {
            
            let newImage = Image(image: image)
            self.newestImages[newImage.Id] = newImage
            self.newestImagesIDs.append(newImage.Id)
        }
        
    }
    
    func getNewestMusicAlbums(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let musics:[AnyObject] = data["musics_album"] as! [AnyObject]
        
        self.musicAlbumsPageSize = itemsCount/10 + 1
        self.musicAlbumsPageIndex += 1
        
        for music in musics {
            
            let newMusic = Music(music: music)
            self.newestMusicAlbums[newMusic.Id] = newMusic
            self.newestMusicAlbumsIDs.append(newMusic.Id)
        }
    }
    
    func getNewestMovieSerials(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let movies:[AnyObject] = data["movie_serials"] as! [AnyObject]
        
        self.movieSerialsPageSize = itemsCount/10 + 1
        self.movieSerialsPageIndex += 1
        
        for movie in movies {
            
            let newMovie = MovieSerial(movie: movie)
            self.newestMovieSerials[newMovie.Id] = newMovie
            self.newestMovieSerialsIDs.append(newMovie.Id)
        }
    }
    
    @IBAction func sortInDateOrder(_ sender: Any) {
        
        if queryType == "date"
        {
            return
        }
        initArrays()
        queryType = "date"
        recentDate.backgroundColor = UIColor(red: 226/255, green: 64/255, blue: 129/255, alpha: 1)
        mostLikes.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        getInitData()
    }
 
    @IBAction func sortInLikeOrder(_ sender: Any) {
        
        if queryType == "like"
        {
            return
        }
        initArrays()
        queryType = "like"
        mostLikes.backgroundColor = UIColor(red: 226/255, green: 64/255, blue: 129/255, alpha: 1)
        recentDate.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        getInitData()
    }
    
    func initArrays()
    {
        moviesPageSize = 10
        moviesPageIndex = 0
        musicsPageSize = 10
        musicsPageIndex = 0
        imagesPageSize = 10
        imagesPageIndex = 0
        ebooksPageSize = 10
        ebooksPageIndex = 0
        musicAlbumsPageSize = 10
        musicAlbumsPageIndex = 0
        movieSerialsPageSize = 10
        movieSerialsPageIndex = 0
        
        newestMovies = [Int:Movie]()
        newestMoviesIDs = [Int]()
        newestMusics = [Int:Music]()
        newestMusicsIDs = [Int]()
        newestEBooks = [Int:EBook]()
        newestEBooksIDs = [Int]()
        newestImages = [Int:Image]()
        newestImagesIDs = [Int]()
        newestMusicAlbums = [Int:Music]()
        newestMusicAlbumsIDs = [Int]()
        newestMovieSerials = [Int:MovieSerial]()
        newestMovieSerialsIDs = [Int]()
    }
    
    @objc func loadMoreItem(_ notification: Notification)
    {
        let tableViewCellIndex = notification.userInfo?["tableViewCellIndex"] as! Int
        switch tableViewCellIndex {
            
        case 0:
            if moviesPageSize < moviesPageIndex
            {
                return
            }
            self.getNewest(urlKey: "newest_movies" , function: "getNewestMovies" , pageSize: pageSize , pageIndex:  moviesPageIndex)
            break
            
        case 2:
            if musicsPageSize < musicsPageIndex
            {
                return
            }
            self.getNewest(urlKey: "newest_musics" , function: "getNewestMusics" , pageSize: pageSize , pageIndex:  musicsPageIndex)
            break
            
        case 3:
            if ebooksPageSize < ebooksPageIndex
            {
                return
            }
            self.getNewest(urlKey: "newest_ebooks" , function: "getNewestEBooks" , pageSize: pageSize , pageIndex:  ebooksPageIndex)
            break
            
        case 1:
            if imagesPageSize < imagesPageIndex
            {
                return
            }
            self.getNewest(urlKey: "newest_images" , function: "getNewestImages" , pageSize: pageSize , pageIndex:  imagesPageIndex)
            break
            
        case 4:
            if musicAlbumsPageSize < musicAlbumsPageSize
            {
                return
            }
            self.getNewest(urlKey: "newest_music_album" , function: "getNewestMusicAlbums" , pageSize: pageSize , pageIndex:  musicAlbumsPageIndex)
            break
            
        case 5:
            if musicAlbumsPageSize < musicAlbumsPageIndex
            {
                return
            }
            self.getNewest(urlKey: "newest_moive_serials" , function: "getNewestMovieSerials" , pageSize: pageSize , pageIndex:  musicAlbumsPageIndex)
            break

        default:
            break
        }
    }
    
    @IBAction func profileClicked(_ sender: Any) {
     
        if User.getInstance().isLogin()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "RegisterLoginViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension MainHomeViewController{
    
    
    func configTableView()
    {
        view.addSubview(tableView)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mostLikes, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: SCREEN_SIZE.height - (self.tabBarController?.tabBar.frame.size.height)! - navBar.frame.size.height - mostLikes.frame.size.height)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView:UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: sectionHeaderSize))
        let label = UILabel()
        label.backgroundColor = UIColor.white
        //line.backgroundColor = UIColor.orange
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //w
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: sectionHeaderSize)
        //h
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: headerView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.font = UIFont(name: "American Typewriter" , size: 18)
        label.text = "   \(tableViewSectionsTitle[section])"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return tableViewSectionsTitle[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return SCREEN_SIZE.width - SCREEN_SIZE.width/4
            
            
        case 1:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
            
        case 2:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
            
        case 3:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
        case 4:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
        case 5:
            return SCREEN_SIZE.width/2 + SCREEN_SIZE.width/4
            
        default:
            break
        }
        
        return SCREEN_SIZE.width - SCREEN_SIZE.width/4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId0, for: indexPath) as! VideosCell
            cell.newestMovies = self.newestMovies
            cell.newestMoviesIDs = self.newestMoviesIDs
            cell.delegate = self
            return cell
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId1, for: indexPath) as! ImagesCell
            cell.newestImages = self.newestImages
            cell.newestImagesIDs = self.newestImagesIDs
            cell.delegate = self
            return cell
            
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId2, for: indexPath) as! MusicsCell
            cell.newestMusics = self.newestMusics
            cell.newestMusicsIDs = self.newestMusicsIDs
            cell.delegate = self
            return cell
            
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId3, for: indexPath) as! EbooksCell
            cell.newestEBooks = self.newestEBooks
            cell.newestEBooksIDs = self.newestEBooksIDs
            cell.delegate = self
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId4, for: indexPath) as! MusicsAlbumsCell
            cell.newestMusics = self.newestMusicAlbums
            cell.newestMusicsIDs = self.newestMusicAlbumsIDs
            cell.delegate = self
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId5, for: indexPath) as! MovieSerialsCell
            cell.newestMovieSerials = self.newestMovieSerials
            cell.newestMovieSerialsIDs = self.newestMovieSerialsIDs
            cell.delegate = self
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func checkInterview()
    {
        if let boool = UserDefaults.standard.value(forKey: "interviewed")
        {
            if boool as! Bool == true
            {
                
            }
            else
            {
                let count = UserDefaults.standard.value(forKey: "counter") as! Int
                if count % 8 == 0 && count >= 8
                {
                    FeedBack()
                    UserDefaults.standard.set(count + 1 , forKey: "counter")
                }
                else
                {
                    UserDefaults.standard.set(count + 1 , forKey: "counter")
                }
            }
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "interviewed")
            UserDefaults.standard.set(0 , forKey: "counter")
        }
    }
}

