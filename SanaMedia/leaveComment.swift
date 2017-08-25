//
//  leaveComment.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/26/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import EasyToast

class leaveComment: UIViewController {
    
    var id:Int!
    var type:String!
    
    @IBOutlet var rateBar: CosmosView!
    @IBOutlet var text: FloatLabelTextField!
    @IBOutlet var sendBtn: UIButton!
    
    var container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
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
    
    @IBAction func sendComment(_ sender: Any) {
        
        if (text.text?.characters.count)! < 1 {
            
            self.view.showToast("ورودی ها را کنترل کنید!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        self.showActivityIndicatory(uiView: self.view)
        
        let url_dynamic_part = singleton.URLS["comment"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "token":User.getInstance().token,
            "type":self.type,
            "id":"\(self.id!)",
            "comment":text.text!,
            "rate":"\(Int(rateBar.rating))"
            ] as! [String : String]
        
        print(body)
        Alamofire.request(url , method: .post ,  parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["data"]
                {
                    if status == "OK"
                    {
                        DispatchQueue.main.async {
                            
                            self.view.showToast("نظر شما ثبت خواهد شد.", position: .bottom, popTime: 3, dismissOnTap: false)
                        }
                        self.dismiss(animated: true
                            , completion: {
                                
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
}
