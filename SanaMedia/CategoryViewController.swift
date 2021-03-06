//
//  CategoryViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import CarbonKit

class CategoryViewController: UIViewController , CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var searchBtn: DesignableButton!
    var carbonTabSwipeNavigation:CarbonTabSwipeNavigation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
    }
    
    func setTabs()
    {
        let items = ["فیلم", "تصویر", "کتاب" , "موزیک" , "آلبوم" , "سریال"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.setIndicatorHeight(1.0)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0))
        carbonTabSwipeNavigation.setTabBarHeight(40)
        carbonTabSwipeNavigation.setNormalColor(UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0) , font: UIFont(name: "Times New Roman", size: 13.0)!)
        carbonTabSwipeNavigation.setTabExtraWidth(40)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.black)
        
        self.view.bringSubview(toFront: searchBtn)
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
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            searchType_ = .movie
            return MovieFilter()
            
        case 1:
            searchType_ = .image
            return ImageFilter()
            
        case 3:
            searchType_ = .music
            return MusicFilter()
            
        case 2:
            searchType_ = .ebook
            return EbookFilter()
            
        case 5:
            searchType_ = .serial
            return SerialFilter()
            
        case 4:
            searchType_ = .album
            return AlbumFilter()
            
        default:
            break
        }
        return UIViewController()
    }
    
    @IBAction func goSearch(_ sender: Any) {
        
        let index:Int = (self.carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex)!
        
        switch index {
        case 0:
            searchType_ = .movie
            break
            
        case 1:
            searchType_ = .image
            break
            
        case 3:
            searchType_ = .music
            break
            
        case 2:
            searchType_ = .ebook
            break
            
        case 5:
            searchType_ = .serial
            break
            
        case 4:
            searchType_ = .album
            break
            
        default:
            break
        }
        performSegue(withIdentifier: "goSearch", sender: self)
    }
}
