//
//  videoPopup.swift
//  SanaMedia
//
//  Created by Mehrshad JM on 7/1/17.
//  Copyright © 2017 Crux Tech Ltd. All rights reserved.
//

import UIKit
import LIHImageSlider

class moviePopup: UIViewController , LIHSliderDelegate{
    
    //vars
    var movie:Movie!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSlider()
    }
    
    func initSlider()
    {
        print(movie.Id)
        //add slider container to view + autoLayouting
        scrollView.addSubview(slider1Container)
        
        //x
        let horizontalConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        //y
        let verticalConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        //w
        let widthConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        //h
        let heightConstraint = NSLayoutConstraint(item: slider1Container, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height/3)
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
    }
    
    override func viewDidLayoutSubviews() {
        
        //add slider to container
        self.sliderVc1!.view.frame = self.slider1Container.frame
        var images:[String] = [""]
        for url in self.movie.Picture_URLS
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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
}

extension moviePopup
{
    //press image slider index
    func itemPressedAtIndex(index: Int) {
        
    }
}


