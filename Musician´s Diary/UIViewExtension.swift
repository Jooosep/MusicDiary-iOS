//
//  UIViewExtension.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 09/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//
import UIKit
import Foundation

extension UIView{
    func fadeTransition(duration : CFTimeInterval){
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
