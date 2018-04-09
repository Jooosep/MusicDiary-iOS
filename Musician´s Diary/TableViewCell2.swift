//
//  TableViewCell2.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 31/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

//
//  TableViewCell1.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 29/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textField1: UITextField!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField1.resignFirstResponder()
        print("resigned")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

