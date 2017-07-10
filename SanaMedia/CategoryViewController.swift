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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabs()
    }
    
    func setTabs()
    {
        let items = ["فیلم", "تصویر", "کتاب" , "موزیک" , "آلبوم" , "سریال"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
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
            return MovieFilter()
            
        case 1:
            return ImageFilter()
            
        case 3:
            return MusicFilter()
            
        case 2:
            return EbookFilter()
            
        case 5:
            return EbookFilter()
            
        case 4:
            return AlbumFilter()
            
        default:
            break
        }
        return UIViewController()
    }
    
    @IBAction func goSearch(_ sender: Any) {
        
        performSegue(withIdentifier: "goSearch", sender: self)
    }
}
