//
//  MyTabController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-02-06.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class MyTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        
        gradient.frame = tabBar.bounds
//        let leftColor = UIColor.init(displayP3Red: 0/255, green: 255/255, blue: 25/255, alpha: 0.1)
//        let rightColor = UIColor.init(displayP3Red: 248/255, green: 234/255, blue: 12/255, alpha: 0.1)
//
        
        let leftColor = UIColor.init(displayP3Red: 0/255, green: 255/255, blue: 25/255, alpha: 0.8)
        let rightColor = UIColor.init(displayP3Red: 248/255, green: 234/255, blue: 12/255, alpha: 0.8)
        
        
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        if let image = getImageFrom(gradientLayer: gradient) {
         //   tabBar.backgroundImage = image
        }
    }
    
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
