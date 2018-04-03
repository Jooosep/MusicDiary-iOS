//
//  ThirdViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 31/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableView3: UITableView!

    var dbManager = PilliPaevikDatabase();
    var chosenTeos:Int!
    var chosenId:Int!
    var nameCell : TableViewCell2!
    var authorCell : TableViewCell2!
    var commentCell : TableViewCell2!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView3.dequeueReusableCell(withIdentifier: "customCell2") as!
        TableViewCell2
        cell.tag = indexPath.row
        cell.textField1.delegate = self
        cell.textField1.tag = indexPath.row
        if indexPath.row == 0 {
            cell.textField1.addTarget(self, action: #selector(ThirdViewController.nameFieldChange), for:UIControlEvents.editingChanged)
            nameCell = cell
        }
        else if indexPath.row == 1 {
            cell.textField1.addTarget(self, action: #selector(ThirdViewController.authorFieldChange), for: UIControlEvents.editingChanged)
            authorCell = cell
        }
        else if indexPath.row == 2 {
            cell.textField1.addTarget(self, action: #selector(ThirdViewController.commentFieldChange), for: UIControlEvents.editingChanged)
            commentCell = cell
        }
        if indexPath.row == 0 {
            cell.textField1.font = .systemFont(ofSize: 18)
        }
        cell.textField1.text = dbManager.selectField(pos: chosenTeos)[indexPath.row]

        return cell;
    }
    
    
    @objc func nameFieldChange(){

        dbManager.editTeosRow(targetId: chosenId, field: dbManager.name, value: nameCell.textField1.text!)
        print("edited name")
        
    }
    @objc func authorFieldChange(){
        
        dbManager.editTeosRow(targetId: chosenId, field: dbManager.author, value: authorCell.textField1.text!)
        print("edited author")
        
    }
    @objc func commentFieldChange(){
        
        dbManager.editTeosRow(targetId: chosenId, field: dbManager.comment, value: commentCell.textField1.text!)
        print("edited comment")
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let cell = tableView3.dequeueReusableCell(withIdentifier: "customCell2") as!
        TableViewCell2
        cell.textField1.resignFirstResponder()
        print("resigned")
    }

            
    override func viewDidLoad() {
        tableView3.delegate = self
        tableView3.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
