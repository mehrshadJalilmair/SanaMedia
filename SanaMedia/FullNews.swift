//
//  FullNews.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/26/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import EasyToast
import Alamofire

class FullNews: UIViewController , UITableViewDataSource , UITableViewDelegate{

    //view
    @IBOutlet var scrollVew: UIScrollView!
    var newsImage:UIImageView! = {
        
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.white
        return iv
    }()
    var date:DesignableButton! = {
        
        let btn = DesignableButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        btn.titleLabel?.textColor = UIColor.white
        return btn
    }()
    var newsTitle:UILabel! = {
        
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.white
        title.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        title.textAlignment = .center
        return title
    }()
    var newsContent:UILabel! = {
        
        var Content = UILabel()
        Content.translatesAutoresizingMaskIntoConstraints = false
        Content.textColor = UIColor.black
        Content.backgroundColor = UIColor.lightGray
        Content.textAlignment = .center
        Content.numberOfLines = 0
        Content.lineBreakMode = .byWordWrapping
        Content.sizeToFit()
        return Content
    }()
    var leaveComment:UIButton! =
    {
        var btn = UIButton(type: UIButtonType.system)
        btn.setImage(UIImage(named:"comment"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(leavingComment), for: UIControlEvents.touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.gray
        return btn
    }()
    
    var like:UIButton! =
    {
        var btn = UIButton(type: UIButtonType.system)
        btn.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(Like), for: UIControlEvents.touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.gray
        return btn
    }()
    var likesCount:UILabel! = {
       
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        return label
    }()
    lazy var tableView : UITableView! =
        {
            let tableView : UITableView = UITableView(frame: self.view.frame)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.register(CommentCell.self, forCellReuseIdentifier: self.CellId)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
    }()

    //var
    var news:News!
    let CellId = "CellId"
    var comments:[Comment] = [Comment]()
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    //: uses in ip dynamic part for page indexing
    var commentsPageSize:Int = 10
    var commentsPageIndex:Int = 0
    var pageSize:Int = 10
    var type = "news"
    var user_liked_this = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        like.isEnabled = false
        self.scrollVew.layer.cornerRadius = 5
        self.scrollVew.layer.masksToBounds = true
        initView()
        configTableView()
        check_like()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //: adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: NSNotification.Name(rawValue: "FullNewsViewController"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //: removing observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FullNewsViewController"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scrollVew.contentSize = CGSize(width: self.scrollVew.frame.width, height:
            newsImage.frame.height + newsTitle.frame.height + newsContent.frame.height +
                like.frame.height + tableView.frame.height + 10)
        getComments()
    }
    
    func initView()
    {
        scrollVew.addSubview(newsImage)
        //x
        var horizontalConstraint = NSLayoutConstraint(item: newsImage, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: newsImage, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        //w
        var widthConstraint = NSLayoutConstraint(item: newsImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        var heightConstraint = NSLayoutConstraint(item: newsImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.height, multiplier: 1/3, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        if self.news.Image_Url.contains("/")
        {
            newsImage.loadImageWithCasheWithUrl(self.news.Image_Url)
        }
        
        scrollVew.addSubview(date)
        //x
        horizontalConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 5)
        //y
        verticalConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 5)
        //h
        heightConstraint = NSLayoutConstraint(item: date, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint])
        let s:NSString = NSString(string: (news?.Date)!)
        let Date = s.substring(with: NSRange(location: 0 , length: 16))
        self.date.setTitle(Date, for: UIControlState.normal)
        self.date.cornerRadius = 3
        
        scrollVew.addSubview(newsTitle)
        //x
        horizontalConstraint = NSLayoutConstraint(item: newsTitle, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: newsTitle, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: newsImage, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: newsTitle, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: newsTitle, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint , heightConstraint])
        newsTitle.text = self.news.Title
        
        scrollVew.addSubview(newsContent)
        //x
        horizontalConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: newsTitle, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint])//heightConstraint])
        newsContent.text = self.news.Content
        
        
        scrollVew.addSubview(leaveComment)
        //x
        horizontalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -36)
        //y
        verticalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: newsContent, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        //h
        heightConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint , heightConstraint])
        
        
        scrollVew.addSubview(like)
        //x
        horizontalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: +36)
        //y
        verticalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: newsContent, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        //widthConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        //h
        heightConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , heightConstraint])

        
        scrollVew.addSubview(likesCount)
        //x
        horizontalConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: like, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: +5)
        //y
        verticalConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: like, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , heightConstraint])
        likesCount.text = news.Likes!
    }
    func configTableView()
    {
        scrollVew.addSubview(tableView)
        //x
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: likesCount, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +4)
        //w
        let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollVew, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 320.0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension FullNews
{
    @IBAction func closePopUp(_ sender: Any) {
        
        self.dismiss(animated: true) {
        }
    }
    @objc func leavingComment()
    {
        print("leavingComment")
    }
    
    func check_like()
    {
        let url_dynamic_part = singleton.URLS["check_like"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":"news",
            "id":self.news.Id,
            ] as [String : Any]
        
        print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:AnyObject]
                let str = value["liked"] as! String
                
                if str == "true"
                {
                    self.user_liked_this = true
                    self.like.setImage(UIImage(named:"shapes"), for: UIControlState.normal)
                    
                }
                else if str == "false" || str == "Empty"
                {
                    self.user_liked_this = false
                    self.like.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
                }
                
                break
                
            case .failure( _):
                DispatchQueue.main.async {
                    
                    self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                break
            }
            self.like.isEnabled = true
        }
    }
    
    @objc func Like()
    {
        let url_dynamic_part = singleton.URLS["like"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":"news",
            "id":self.news.Id,
            "like":(user_liked_this ? -1 : 1)
            ] as [String : Any]
        
        print(body)
        
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["data"]
                {
                    if status == "OK"
                    {
                        if !self.user_liked_this
                        {
                            self.news.Likes = "\(Int(self.news.Likes)! + 1)"
                            self.user_liked_this = true
                            self.like.setImage(UIImage(named:"shapes"), for: UIControlState.normal)
                        }
                        else
                        {
                            self.news.Likes = "\(Int(self.news.Likes)! - 1)"
                            self.user_liked_this = false
                            self.like.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
                        }
                        
                        self.likesCount.text = self.news.Likes
                    }
                    else
                    {
                        
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
            self.like.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.comment = comment
        
        if indexPath.row + 1 == self.comments.count {
            
            if commentsPageSize < commentsPageIndex
            {
                
            }
            else
            {
                getComments()
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func getComments()
    {
        //: getting init data
        self.getData(urlKey: "get_comments" , function: "getCommentsData" , pageSize: commentsPageSize , pageIndex:  commentsPageIndex)
    }
    
    //: handles requests for getting newest to server
    func getData(urlKey:String , function:String , pageSize:Int , pageIndex:Int)
    {
        requestType = .get
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS[urlKey]!, self.type , "\(self.news.Id!)" ,  "\(pageSize)" , "\(pageIndex+1)")
        singleton.requestToServer(requestType: requestType, requesterData: ["url_dynamic_part":url_dynamic_part , "func":function , "class":"FullNewsViewController"], body: [:])
    }
    
    //: handles data when recieved from server
    @objc func notificationReceived(_ notification: Notification)
    {
        let error = notification.userInfo?["error"] as! String
        let data = notification.userInfo?["data"] as! [String:AnyObject]
        let function = notification.userInfo?["func"] as!String
        
        switch function {
            
        case "getCommentsData":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getCommentsData(data: data)
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
    
    func getCommentsData(data:[String:AnyObject])
    {
        print(data["Comments"] as! [AnyObject])
        print(self.news.Id)
        let itemsCount:Int = data["itemsCount"] as! Int
        let _Comments = data["Comments"] as! [AnyObject]
        
        self.commentsPageIndex += 1
        self.commentsPageSize = itemsCount/10 + 1
        
        for item in _Comments {
            
            let newNews = Comment(comment: item)
            self.comments.append(newNews)
        }
        
        if itemsCount == 0
        {
            DispatchQueue.main.async {
                
                self.view.showToast("نظری ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
            }
        }
    }
}
