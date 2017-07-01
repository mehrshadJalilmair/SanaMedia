//
//  CategoryViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 5/16/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
