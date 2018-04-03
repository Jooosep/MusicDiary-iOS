//
//  SecondViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 26/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var dbManager = PilliPaevikDatabase();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songName.delegate = self
        author.delegate = self
        songComment.delegate = self
        
        dbManager.newTeosRow()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController{
            destination.dbManager = self.dbManager
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        songName.resignFirstResponder()
        author.resignFirstResponder()
        songComment.resignFirstResponder()
        dbManager.updateTeosRow(name: songName.text!, author: author.text!, comment: songComment.text!)
    }
    @IBOutlet weak var songName: UITextField!
    
    @IBOutlet weak var author: UITextField!
    
    @IBOutlet weak var songComment: UITextField!
}
extension SecondViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dbManager.updateTeosRow(name: songName.text!, author: author.text!, comment: songComment.text!)
        return true
    }
}
