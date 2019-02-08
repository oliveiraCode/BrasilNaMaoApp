//
//  MyNavController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-02-06.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class MyNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()

        var bounds = navigationBar.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        let leftColor = UIColor.init(displayP3Red: 0/255, green: 255/255, blue: 25/255, alpha: 0.5)
        let rightColor = UIColor.init(displayP3Red: 248/255, green: 234/255, blue: 12/255, alpha: 0.5)

        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)

        if let image = getImageFrom(gradientLayer: gradient) {
            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
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
