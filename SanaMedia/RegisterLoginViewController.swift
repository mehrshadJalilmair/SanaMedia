//
//  RegisterLoginViewController.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 6/28/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import Alamofire

class RegisterLoginViewController: UIViewController {

    @IBOutlet var loginView: UIView!
    @IBOutlet var loginPhone: FloatLabelTextField!
    @IBOutlet var loginPass: FloatLabelTextField!
    
    @IBOutlet var registerView: UIView!
    @IBOutlet var registerPass: FloatLabelTextField!
    @IBOutlet var email: FloatLabelTextField!
    @IBOutlet var registerPhone: FloatLabelTextField!
    @IBOutlet var registerRePass: FloatLabelTextField!
    
    var container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        dismiss(animated: true) { 
            
            
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        if (loginPhone.text?.characters.count)! < 11 || loginPass.text! == ""{
            
            self.view.showToast("ورودی ها را کنترل کنید!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        self.showActivityIndicatory(uiView: self.view)
        let url_dynamic_part = singleton.URLS["authenticate"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "username":loginPhone.text!,
            "password":loginPass.text!
        ]
        print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["authenticate"]
                {
                    if status == "true"
                    {
                        User.getInstance().token = value["token"]
                        User.getInstance().isLoggined = true
                        User.getInstance().phone = self.loginPhone.text!
                        User.getInstance().pass = self.loginPass.text!
                        User.getInstance().setLogin()
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
    
    @IBAction func goToRegister(_ sender: Any) {
        
        loginView.isHidden = true
        registerView.isHidden = false
    }
    
    @IBAction func register(_ sender: Any) {
        
        if (registerPhone.text?.characters.count)! < 11 || email.text! == "" || registerPass.text! == "" || registerPass.text! != registerRePass.text!{
            
            self.view.showToast("ورودی ها را کنترل کنید!", position: .bottom, popTime: 2, dismissOnTap: false)
            return
        }
        

        showActivityIndicatory(uiView: self.view)
        let url_dynamic_part = singleton.URLS["Registration"]
        let url = singleton.url_static_part + url_dynamic_part!
        
        let body = [
            
            "mobile_no":registerPhone.text!,
            "email":email.text!,
            "password":registerPass.text!
        ]
        print(body)
        Alamofire.request(url, method: .post, parameters: body, encoding:  JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let value = response.result.value as! [String:String]
                
                if let status = value["registration_success"]
                {
                    if status == "true"
                    {
                        User.getInstance().email = self.email.text!
                        User.getInstance().pass = self.registerPass.text!
                        User.getInstance().phone = self.registerPhone.text!
                        User.getInstance().token = value["token"]
                        User.getInstance().isLoggined = true
                        User.getInstance().isRegistered = true
                        User.getInstance().setRegister()
                        
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
    
    @IBAction func goToLogin(_ sender: Any) {
        
        registerView.isHidden = true
        loginView.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
