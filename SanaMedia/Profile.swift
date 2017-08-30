//
//  Profile.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/28/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire
import Cosmos

class Profile: UIViewController , UITabBarDelegate , UITableViewDataSource{
    
    @IBOutlet var feedBackView: UIView!
    @IBOutlet var opinion: FloatLabelTextField!
    @IBOutlet var rate5: CosmosView!
    @IBOutlet var rate4: CosmosView!
    @IBOutlet var rate3: CosmosView!
    @IBOutlet var rate2: CosmosView!
    @IBOutlet var rate1: CosmosView!
    
    @IBOutlet var mobile: UILabel!
    
    @IBOutlet var messagesTableView: UITableView!
    var pageIndex:Int = 0
    var pageSize:Int = 10
    var totalPage:Int = 0
    var Messages:[UserMessage] = [UserMessage]()
    
    
    @IBOutlet var logout: UILabel!
    @IBOutlet var feedBack: UILabel!
    @IBOutlet var mymessages: UILabel!
    @IBOutlet var phone: FloatLabelTextField!
    var container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.estimatedRowHeight = 50.0
        self.messagesTableView.rowHeight = UITableViewAutomaticDimension
        self.messagesTableView.separatorStyle = .none
        
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
            #selector(Logout)))
        feedBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedBack)))
        mymessages.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyMessages)))
        
        self.mobile.text = User.getInstance().phone
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        //feedBackView.removeFromSuperview()
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
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true) { 
            
        }
    }
    
    @objc func Logout()
    {
        showActivityIndicatory(uiView: self.view)
        let url_dynamic_part = singleton.URLS["logout"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token
        ]
        
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["logout"]
                {
                    if status == "true"
                    {
                        User.getInstance().logout()
                        User.getInstance().isLoggined = false
                        self.dismiss(animated: true, completion: {
                            
                        })
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
    
    @IBAction func updateProfile(_ sender: Any) {
        
        if (phone.text?.characters.count)! < 11 {
            
            self.view.showToast("قرمت موبایل نادرست!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        
        showActivityIndicatory(uiView: self.view)
        let url_dynamic_part = singleton.URLS["update_profile"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "username":phone.text!
        ]
        
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["profile_update"]
                {
                    if status == "true"
                    {
                        User.getInstance().phone = self.phone.text!
                        User.getInstance().setRegister()
                        DispatchQueue.main.async {
                            
                            self.phone.text = ""
                            self.view.showToast("بروزرسانی انجام شد!", position: .bottom, popTime: 2, dismissOnTap: false)
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
    
    @objc func FeedBack()
    {
        self.view.addSubview(feedBackView)
        feedBackView.center = self.view.center
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        
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
    
    @objc func MyMessages()
    {
        pageIndex = 0
        pageSize = 10
        totalPage = 0
        Messages.removeAll()
        messagesTableView.reloadData()
        getMessages()
    }
    func getMessages()
    {
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS["newest_messages"]!, "\(pageSize)" , "\(pageIndex+1)" , User.getInstance().token)
        let url = singleton.url_static_part + url_dynamic_part
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                let value = response.result.value as! [String:AnyObject]
                let Messages_ = value["Messages"] as! [AnyObject]
                let itemsCount:Int = value["itemsCount"] as! Int
                
                self.pageIndex += 1
                self.totalPage = itemsCount/10 + 1
                
                for message_ in Messages_
                {
                    let newMessage = UserMessage(message: message_)
                    self.Messages.append(newMessage)
                }
                DispatchQueue.main.async {
                    
                    self.messagesTableView.reloadData()
                }
                break
                
            case .failure( _):
                DispatchQueue.main.async {
                    
                    self.view.showToast("خطا!", position: .bottom, popTime: 2, dismissOnTap: false)
                }
                break
            }
        }
    }
    
    @IBAction func closeRating(_ sender: Any) {
        
        feedBackView.removeFromSuperview()
    }
}

extension Profile
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        as! MessageCell
        
        cell.Content.text = self.Messages[indexPath.row].Content
        let s:NSString = NSString(string: self.Messages[indexPath.row].Creation_Date)
        let date = s.substring(with: NSRange(location: 0 , length: 16))
        cell.Date.text = date
        
        if indexPath.row + 1 == self.Messages.count {
            
            if totalPage < pageIndex
            {
                
            }
            else
            {
                getMessages()
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.selectionStyle = .none
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
