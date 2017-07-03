//
//  Search.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/3/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit

class Search: UIViewController {

    @IBOutlet var seachBar: UISearchBar!
    @IBOutlet var inputTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    @IBAction func doSearch(_ sender: Any) {
        
        
    }
}
