//
//  NewsViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var mostLikes: DesignableButton!
    @IBOutlet weak var recentDate: DesignableButton!
    
    //table view
    let CellId = "news"
    @IBOutlet var tableView: UITableView!
    
    //: Main tab vars
    var newestNewses:[Int:News] = [Int:News]()
    var newestNewsesIDs:[Int] = [Int]()
    
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    
    //: uses in ip dynamic part for page indexing
    var queryType:String = "date"
    var newsPageSize:Int = 10
    var newsPageIndex:Int = 0
    var pageSize:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        getInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //: adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: NSNotification.Name(rawValue: "NewsViewController"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //: removing observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NewsViewController"), object: nil)
    }
    
    func getInitData()
    {
        //: getting init data
        self.getNewest(urlKey: "newest_news" , function: "getNewestNews" , pageSize: pageSize , pageIndex:  newsPageIndex)
    }
    
    //: handles requests for getting newest to server
    func getNewest(urlKey:String , function:String , pageSize:Int , pageIndex:Int)
    {
        requestType = .get
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS[urlKey]!, "\(pageSize)" , "\(pageIndex+1)" , queryType)
        singleton.requestToServer(requestType: requestType, requesterData: ["url_dynamic_part":url_dynamic_part , "func":function , "class":"NewsViewController"], body: [:])
    }
    
    //: handles data when recieved from server
    func notificationReceived(_ notification: Notification)
    {
        let error = notification.userInfo?["error"] as! String
        let data = notification.userInfo?["data"] as! [String:AnyObject]
        let function = notification.userInfo?["func"] as!String
        
        switch function {
            
        case "getNewestNews":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getNewestNews(data: data)
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
    
    func getNewestNews(data:[String:AnyObject])
    {
        let itemsCount:Int = data["itemsCount"] as! Int
        let news:[AnyObject] = data["News"] as! [AnyObject]
        
        self.newsPageIndex += 1
        self.newsPageSize = itemsCount/10 + 1
        
        for item in news {
            
            let newNews = News(news: item)
            self.newestNewses[newNews.Id] = newNews
            self.newestNewsesIDs.append(newNews.Id)
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
        
        if queryType == "likes"
        {
            return
        }
        initArrays()
        queryType = "likes"
        mostLikes.backgroundColor = UIColor(red: 226/255, green: 64/255, blue: 129/255, alpha: 1)
        recentDate.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        getInitData()
    }
    
    func initArrays()
    {
        newsPageSize = 10
        newsPageIndex = 0
        
        newestNewses = [Int:News]()
        newestNewsesIDs = [Int]()
    }
}

extension NewsViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.newestNewses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath) as! NewsCell
        
        let index = newestNewsesIDs[indexPath.row]
        let news = newestNewses[index]
        
        cell.news = news
        
        if indexPath.row + 1 == self.newestNewses.count {
            
            if newsPageSize < newsPageIndex
            {
                
            }
            else
            {
                getInitData()
            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.selectionStyle = .none
        performSegue(withIdentifier: "showFullNews", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showFullNews" , let nextScene =  segue.destination as? FullNews , let indexPath = self.tableView.indexPathForSelectedRow {
            
            let index = newestNewsesIDs[indexPath.row]
            let news = newestNewses[index]
            nextScene.news = news
        }
    }
}
