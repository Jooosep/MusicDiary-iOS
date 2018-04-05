//
//  PopUpViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 03/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func OkButtonTapped(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
