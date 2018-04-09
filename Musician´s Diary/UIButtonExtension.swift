//
//  UIButtonExtension.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 09/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//
import Foundation
import UIKit

extension UIButton {

    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.6
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    func buttonFadeTransition(duration : CFTimeInterval){
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
        
    }


}
