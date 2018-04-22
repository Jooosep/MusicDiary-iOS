//
//  LabelExtension.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 10/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func set(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: -15, y: 0, width: 20, height: 20)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString(string: text, attributes: [.font: self.font])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }
}
