//
//  serialPopup.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/3/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire
import LIHImageSlider

class serialPopup: UIViewController , LIHSliderDelegate , UITableViewDataSource , UITableViewDelegate {

    //vars
    var serial:MovieSerial!
    var user_liked_this = false
    
    //views
    //slider (container + LIHSliderViewController)
    var slider1: LIHSlider!
    let slider1Container : UIView! = {
        
        let slider1Container = UIView()
        slider1Container.backgroundColor = UIColor.white
        slider1Container.translatesAutoresizingMaskIntoConstraints = false
        return slider1Container
    }()
    fileprivate var sliderVc1: LIHSliderViewController!
    @IBOutlet var scrollView: UIScrollView!

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
    let rate : UILabel! = {
        
        let label = UILabel()
        label.font = UIFont(name: "Times New Roman", size: 15)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    lazy var episodestableView : UITableView! = {
        
        
        let tableView : UITableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(movieSerialCellInPopup.self, forCellReuseIdentifier: self.CellId1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //var
    let CellId = "CellId"
    var comments:[Comment] = [Comment]()
    let CellId1 = "CellId1"
    var episodes:[Movie] = [Movie]()
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    //: uses in ip dynamic part for page indexing
    var commentsPageSize:Int = 10
    var commentsPageIndex:Int = 0
    var pageSize:Int = 10
    var type = "serial"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //add slider container to view + autoLayouting
        scrollView.addSubview(slider1Container)
        
        //x
        var horizontalConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        var verticalConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //w
        var widthConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        var heightConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height/2 - 40)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        //init Slider One (Top)
        let images:[String] = [""]
        
        slider1 = LIHSlider(images: images)
        //slider1.sliderDescriptions = ["Image 1 description","Image 2 description","Image 3 description","Image 4 description","Image 5 description","Image 6 description"]
        self.sliderVc1  = LIHSliderViewController(slider: slider1)
        sliderVc1.delegate = self
        self.addChildViewController(self.sliderVc1)
        self.scrollView.addSubview(self.sliderVc1.view)
        self.sliderVc1.didMove(toParentViewController: self)
        sliderVc1.view.backgroundColor = UIColor.white
        
        scrollView.addSubview(container1)
        //x
        horizontalConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: slider1Container, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: container1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 170)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
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
        title_.text = self.serial.Title
        
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
        ptitle_.text = "ژانر : " + self.serial.Genre
        
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
        country.text = "کشور سازنده : " + self.serial.Country
        
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
        producer.text = "کارگردان : " + self.serial.Director
        
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
        duration.text = "تعداد قسمت ها : " + "\(self.serial.Episodes!)"
        
        container1.addSubview(rate)
        //x
        horizontalConstraint = NSLayoutConstraint(item: rate, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: rate, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: duration, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: rate, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.width, multiplier: 1, constant: -20)
        //h
        heightConstraint = NSLayoutConstraint(item: rate, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        rate.text = "امتیاز کاربران : " + self.serial.Rate + "/5"
        
        scrollView.addSubview(newsContent)
        //x
        horizontalConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container1, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: newsContent, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint])//heightConstraint])
        newsContent.text = self.serial.Description
        
        scrollView.addSubview(episodestableView)
        //x
        horizontalConstraint = NSLayoutConstraint(item: episodestableView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        verticalConstraint = NSLayoutConstraint(item: episodestableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: newsContent, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        //w
        widthConstraint = NSLayoutConstraint(item: episodestableView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        heightConstraint = NSLayoutConstraint(item: episodestableView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 201)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint , heightConstraint])
        
        scrollView.addSubview(leaveComment)
        //x
        horizontalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -36)
        //y
        verticalConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: episodestableView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
        //w
        widthConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        //h
        heightConstraint = NSLayoutConstraint(item: leaveComment, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 36)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint , widthConstraint , heightConstraint])
        
        
        scrollView.addSubview(like)
        //x
        horizontalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: +36)
        //y
        verticalConstraint = NSLayoutConstraint(item: like, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: episodestableView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: +5)
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
        likesCount.text = self.serial.Likes!
    }
    
    override func viewDidLayoutSubviews() {
        
        //add slider to container
        self.sliderVc1!.view.frame = self.slider1Container.frame
        var images:[String] = [String]()
        for url in self.serial.Picture_URLS
        {
            if url.characters.count > 7
            {
                images.append(singleton.url_static_part + url)
            }
        }
        self.sliderVc1.slider.sliderImages = images
        self.sliderVc1.pageControl.numberOfPages = images.count
        self.sliderVc1.pageControl.pageIndicatorTintColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height:
            slider1Container.frame.height + container1.frame.height + newsContent.frame.height +
                like.frame.height + tableView.frame.height + episodestableView.frame.height + 10)
        getComments()
        getChild()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
}

extension serialPopup
{
    //press image slider index
    func itemPressedAtIndex(index: Int) {}
    
    @objc func playVideo()
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
            vc.type = "movie_serial"
            vc.id = self.serial.Id
        }
    }
    func check_like()
    {
        
        let url_dynamic_part = singleton.URLS["check_like"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":"movie_serial",
            "id":self.serial.Id,
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
            "type":"movie_serial",
            "id":self.serial.Id,
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
                            self.serial.Likes = "\(Int(self.serial.Likes)! + 1)"
                            self.user_liked_this = true
                            self.like.setImage(UIImage(named:"shapes"), for: UIControlState.normal)
                        }
                        else
                        {
                            self.serial.Likes = "\(Int(self.serial.Likes)! - 1)"
                            self.user_liked_this = false
                            self.like.setImage(UIImage(named:"heart-outline"), for: UIControlState.normal)
                        }
                        self.likesCount.text = self.serial.Likes
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
        if tableView == episodestableView
        {
            return episodes.count
        }
        return self.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == episodestableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId1, for: indexPath) as! movieSerialCellInPopup
            cell.movie = episodes[indexPath.row]
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
        
        if tableView == episodestableView
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "moviePopup") as! moviePopup
            controller.movie = episodes[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            return
        }
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == episodestableView
        {
            return 100.0
        }
        return UITableViewAutomaticDimension
    }
    
    func getComments()
    {
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["get_comments"]!, self.type , "\(self.serial.Id!)" ,  "\(self.commentsPageIndex+1)" , "\(self.pageSize)")
        requestToServer(url_dynamic_part: url_dynamic_part)
    }
    
    //: handles requests to server
    func requestToServer(url_dynamic_part:String)
    {
        let url_dynamic_part = url_dynamic_part
        let url = Singleton.getInstance().url_static_part + url_dynamic_part
        
        Alamofire.request(url , encoding: JSONEncoding.default).validate().responseJSON { response in
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
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["movie_serial_childs"]!, "\(self.serial.Id!)")
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
                        
                        //self.view.showToast("قسمتی ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                    return
                }
                
                let data = response.result.value as! [String:AnyObject]
                let Musics = data["Movies"] as! [AnyObject]
                
                for item in Musics {
                    
                    let newNews = Movie(movie: item)
                    self.episodes.append(newNews)
                }
                
                if self.episodes.count == 0
                {
                    DispatchQueue.main.async {
                        
                        //self.view.showToast("قسمتی ثبت نشده است!", position: .bottom, popTime: 2, dismissOnTap: false)
                    }
                }
                self.episodestableView.reloadData()
                break
                
            case .failure(let error):
                
                print(error)
                break
            }
        }
    }
}


