//
//  albumPopup.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/3/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire

class albumPopup: UIViewController ,UITableViewDataSource , UITableViewDelegate{

    //vars
    var album:Music!
    var user_liked_this = false
    
    //views
    let imageView : UIImageView! = {
        
        let slider1Container = UIImageView()
        slider1Container.backgroundColor = UIColor.white
        slider1Container.translatesAutoresizingMaskIntoConstraints = false
        return slider1Container
    }()
    
    @IBOutlet var scrollView: UIScrollView!
    
    var playButton : DesignableButton! = {
        
        var button = DesignableButton()
        button.setImage(UIImage(named:"play"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self , action: #selector(musicPopup.playMusic), for: UIControlEvents.touchUpInside)
        return button
    }()
    let container1 : UIView! = {
        
        let slider1Container = UIView()
        slider1Container.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
        slider1Container.translatesAutoresizingMaskIntoConstraints = false
        return slider1Container
    }()
    let title_ : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    let line : UIView! = {
        
        let slider1Container = UIView()
        slider1Container.backgroundColor = UIColor.white
        slider1Container.translatesAutoresizingMaskIntoConstraints = false
        return slider1Container
    }()
    let ptitle_ : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    let country : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    let producer : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    let duration : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 15)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
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
    lazy var tableView : UITableView! = {
        
        
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
    
    lazy var tableViewMusics : UITableView! = {
        
        
        let tableView : UITableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(albumMusicCell.self, forCellReuseIdentifier: self.CellId1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //var
    let CellId = "CellId"
    let CellId1 = "CellId1"
    var comments:[Comment] = [Comment]()
    var musics:[Music] = [Music]()
    var commentsPageSize:Int = 10
    var commentsPageIndex:Int = 0
    var pageSize:Int = 10
    var type = "album"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(album.Id)
        
        initView()
        self.scrollView.layer.cornerRadius = 5
        self.scrollView.layer.masksToBounds = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        configTableView()
        check_like()
    }
    
    func configTableView()
    {
        scrollView.addSubview(tableView)
        //x
        let horizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: likesCount, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +4)
        //w
        let widthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 320.0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initView()
    {
        scrollView.addSubview(imageView)
        
        //x
        var horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //w
        var widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        var heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height/2 - 10)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        print(self.album.Picture_URLS)
        imageView.loadImageWithCasheWithUrl(self.album.Picture_URLS[0])
        
        scrollView.addSubview(playButton)
        //x
        horizontalConstraint = NSLayoutConstraint(item: playButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: playButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -25)
        //w
        widthConstraint = NSLayoutConstraint(item: playButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        //h
        heightConstraint = NSLayoutConstraint(item: playButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        playButton.cornerRadius = 25
        playButton.backgroundColor = UIColor.white
        
        scrollView.addSubview(container1)
        //x
        horizontalConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 170)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        scrollView.bringSubview(toFront: playButton)
        
        container1.addSubview(title_)
        //x
        horizontalConstraint = NSLayoutConstraint(item: title_, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: title_, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.top, multiplier: 1, constant: +25)
        //w
        widthConstraint = NSLayoutConstraint(item: title_, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: title_, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        title_.text = self.album.Title
        
        container1.addSubview(line)
        //x
        horizontalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: title_, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +1)
        //w
        widthConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 1)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        container1.addSubview(ptitle_)
        //x
        horizontalConstraint = NSLayoutConstraint(item: ptitle_, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: ptitle_, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: line, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: ptitle_, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: ptitle_, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        ptitle_.text = "خواننده : " + self.album.Singer
        
        container1.addSubview(country)
        //x
        horizontalConstraint = NSLayoutConstraint(item: country, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: country, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ptitle_, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: country, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: country, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        country.text = "مدت زمان : " + self.album.Duration
        
        container1.addSubview(producer)
        //x
        horizontalConstraint = NSLayoutConstraint(item: producer, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: producer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: country, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: producer, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: producer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        producer.text = "سال تولید : " + self.album.Production_Year
        
        container1.addSubview(duration)
        //x
        horizontalConstraint = NSLayoutConstraint(item: duration, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: duration, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: producer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: duration, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: duration, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        duration.text = "امتیاز کاربران : " + self.album.Rate + "/5"
        
        scrollView.addSubview(tableViewMusics)
        //x
       horizontalConstraint = NSLayoutConstraint(item: tableViewMusics, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //y
         verticalConstraint = NSLayoutConstraint(item: tableViewMusics, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
         widthConstraint = NSLayoutConstraint(item: tableViewMusics, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
         heightConstraint = NSLayoutConstraint(item: tableViewMusics, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150.0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        scrollView.addSubview(leaveComment)
        //x
        horizontalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -36)
        //y
        verticalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tableViewMusics, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        //h
        heightConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint , heightConstraint])
        
        scrollView.addSubview(like)
        //x
        horizontalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: +36)
        //y
        verticalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tableViewMusics, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        //widthConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        //h
        heightConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , heightConstraint])
        
        scrollView.addSubview(likesCount)
        //x
        horizontalConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: like, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: +5)
        //y
        verticalConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: like, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: likesCount, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , heightConstraint])
        likesCount.text = self.album.Likes!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height:
            imageView.frame.height + container1.frame.height +
                like.frame.height + tableView.frame.height + tableViewMusics.frame.height + 10)
        getComments()
        getChild()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
}

extension albumPopup
{
    //press image slider index
    func itemPressedAtIndex(index: Int) {}
    
    @objc func playMusic()
    {
        
    }
    
    @objc func leavingComment()
    {
        if User.getInstance().token == ""
        {
            self.view.showToast("ابتدا از منوی سمت راست ثبت نام کنید یا وارد شوید!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        
        self.performSegue(withIdentifier: "comment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "comment"
        {
            let vc = segue.destination as! leaveComment
            vc.type = "music_album"
            vc.id = self.album.Id
        }
    }
    
    func check_like()
    {
        
        let url_dynamic_part = singleton.URLS["check_like"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":"music_album",
            "id":self.album.Id,
            ] as [String : Any]
        
        print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                guard let _ = value["liked"] else
                {
                    self.like.isEnabled = true
                    self.user_liked_this = false
                    self.like.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
                    return
                }
                
                let str = value["liked"]
                
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
                    
                    //self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                break
            }
            self.like.isEnabled = true
        }
    }
    
    @objc func Like()
    {
        if User.getInstance().token == ""
        {
            self.view.showToast("ابتدا از منوی سمت راست ثبت نام کنید یا وارد شوید!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        
        let url_dynamic_part = singleton.URLS["like"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":"music_album",
            "id":self.album.Id,
            "like":(user_liked_this ? "-1" : "+1")
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
                            self.album.Likes = "\(Int(self.album.Likes)! + 1)"
                            self.user_liked_this = true
                            self.like.setImage(UIImage(named:"shapes"), for: UIControlState.normal)
                        }
                        else
                        {
                            self.album.Likes = "\(Int(self.album.Likes)! - 1)"
                            self.user_liked_this = false
                            self.like.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
                        }
                        self.likesCount.text = self.album.Likes
                    }
                    else
                    {
                        
                    }
                }
                else
                {
                    //self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                
                break
                
            case .failure( _):
                DispatchQueue.main.async {
                    
                    //self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                break
            }
            self.like.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if tableView == tableViewMusics
        {
            return musics.count
        }
        return self.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tableViewMusics
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId1, for: indexPath) as! albumMusicCell
            cell.music = self.musics[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.comment = comment
        
        if indexPath.row + 1 == self.comments.count {
            
            if commentsPageSize <= commentsPageIndex
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
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
        if tableView == tableViewMusics
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "musicPopup") as! musicPopup
            controller.music = musics[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            return
        }
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tableViewMusics
        {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableViewMusics
        {
            return 50.0
        }
        return UITableViewAutomaticDimension
    }
    
    func getComments()
    {
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["get_comments"]!, self.type , "\(self.album.Id!)" ,  "\(self.commentsPageIndex+1)" , "\(self.pageSize)")
        requestToServer(url_dynamic_part: url_dynamic_part)
    }
    
    //: handles requests to server
    func requestToServer(url_dynamic_part:String)
    {
        let url_dynamic_part = url_dynamic_part
        let url = Singleton.getInstance().url_static_part + url_dynamic_part
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let data = response.result.value as! [String:AnyObject]
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
                        
                        //self.view.showToast("نظری ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                
                self.tableView.reloadData()
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        }
    }
    
    func getChild()
    {
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["music_album_childs"]!, "\(self.album.Id!)")
        requestToServer1(url_dynamic_part: url_dynamic_part)
    }
    
    //: handles requests to server
    func requestToServer1(url_dynamic_part:String)
    {
        let url_dynamic_part = url_dynamic_part
        let url = Singleton.getInstance().url_static_part + url_dynamic_part
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if response.result.value == nil
                {
                    DispatchQueue.main.async {
                        
                        //self.view.showToast("آهنگی ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                    return
                }
                
                let data = response.result.value as! [String:AnyObject]
                let Musics = data["Musics"] as! [AnyObject]
                
                for item in Musics {
                    
                    let newNews = Music(music: item)
                    self.musics.append(newNews)
                }
                
                if self.musics.count == 0
                {
                    DispatchQueue.main.async {
                        
                        //self.view.showToast("آهنگی ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                self.tableViewMusics.reloadData()
                break
                
            case .failure(let _):
                
                //print(error)
                break
            }
        }
    }
}




