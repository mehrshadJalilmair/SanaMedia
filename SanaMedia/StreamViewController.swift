//
//  StreamViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StreamViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var tvsBtn: UIButton!
    @IBOutlet weak var radiosBtn: UIButton!
    
    //table view
    let CellId0 = "tv"
    let CellId1 = "radio"
    @IBOutlet var tableView: UITableView!
    
    //: Main tab vars
    var TVs:[Int:TV] = [Int:TV]()
    var TVsIDs:[Int] = [Int]()
    
    //: requestType : get|post
    var requestType:Singleton.RequestType!
    
    //: uses in ip dynamic part for page indexing
    var queryType:String = "tv"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        getInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //: adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: NSNotification.Name(rawValue: "StreamViewController"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //: removing observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StreamViewController"), object: nil)
    }
    
    func getInitData()
    {
        //: getting init data
        self.getShows(urlKey: "live_shows" , function: "getLiveShows")
    }
    
    //: handles requests for getting newest to server
    func getShows(urlKey:String , function:String)
    {
        requestType = .get
        let url_dynamic_part:String = String.localizedStringWithFormat(singleton.URLS[urlKey]!,queryType)
        singleton.requestToServer(requestType: requestType, requesterData: ["url_dynamic_part":url_dynamic_part , "func":function , "class":"StreamViewController"], body: [:])
    }
    
    //: handles data when recieved from server
    @objc func notificationReceived(_ notification: Notification)
    {
        let error = notification.userInfo?["error"] as! String
        let data = notification.userInfo?["data"] as! [String:AnyObject]
        let function = notification.userInfo?["func"] as!String
        
        switch function {
            
        case "getLiveShows":
            if error == "nil" {
                
                DispatchQueue.global(qos: .userInteractive).async { //background thread
                    
                    self.getLiveShows(data: data)
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
    
    func getLiveShows(data:[String:AnyObject])
    {
        let _:Int = data["itemsCount"] as! Int
        let Channels:[AnyObject] = data["Channels"] as! [AnyObject]
    
        for Channel in Channels {
            
            let newChannel = TV(tv: Channel)
            if newChannel.Stream != nil || newChannel.Stream != ""
            {
                if newChannel.Stream.contains("m3u8")
                {
                    self.TVs[newChannel.Id] = newChannel
                    self.TVsIDs.append(newChannel.Id)
                }
            }
            
        }
    }
    
    @IBAction func getTVs(_ sender: Any) {
        
        if queryType == "tv"
        {
            return
        }
        queryType = "tv"
        tvsBtn.backgroundColor = UIColor(red: 226/255, green: 64/255, blue: 129/255, alpha: 1)
        radiosBtn.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        getInitData()
        TVs = [Int:TV]()
        TVsIDs = [Int]()
    }
    
    @IBAction func getRadios(_ sender: Any) {
        
        if queryType == "radio"
        {
            return
        }
        queryType = "radio"
        radiosBtn.backgroundColor = UIColor(red: 226/255, green: 64/255, blue: 129/255, alpha: 1)
        tvsBtn.backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1)
        //getInitData()
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

extension StreamViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.TVs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId0, for: indexPath) as! TVCell
        
        let index = TVsIDs[indexPath.row]
        let tv = TVs[index]
        
        cell.tv = tv
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tv = TVs[TVsIDs[indexPath.row]]
        
        DispatchQueue.main.async {
            
            print((tv?.Stream)!)
            
            if let url = URL(string: (tv?.Stream)!){
                
                let player = AVPlayer(url: url)
                let controller=AVPlayerViewController()
                controller.player=player
                //controller.view.frame = self.view.frame
                //self.view.addSubview(controller.view)
                //self.addChildViewController(controller)
                //player.play()
                self.present(controller, animated: true) {
                    player.play()
                }
            }
        }
    }
}
