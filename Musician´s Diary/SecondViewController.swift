//
//  SecondViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 26/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var songName: UITextField!
    
    @IBOutlet weak var author: UITextField!
    
    @IBOutlet weak var songComment: UITextField!
}
