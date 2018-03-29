//
//  ViewController.swift
//  POP UPS
//
//  Created by Joosep Teemaa on 17/03/2018.
//  Copyright © 2018 Joosep Teemaa. All rights reserved.
//

import UIKit
import SQLite

//MARK Properties
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var teosed = ["Yesterday", "testlugu","jne"];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teosed.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
        TableViewCell1
        cell.label.text = teosed[indexPath.row]
        return cell;
    }
    
    
    let teosTable = Table("teosed");
    let id = Expression<Int>("id");
    let name = Expression<String>("name");
    let author = Expression<String>("author");
    
    @IBOutlet weak var tableView1: UITableView!
    
    override func viewDidLoad() {
        tableView1.delegate = self
        tableView1.dataSource = self
        
        let dbManager = PilliPaevikDatabase();
        dbManager.create_db();
        dbManager.create_tables();
        
        super.viewDidLoad();
        
    }
    @IBAction func OnActionTapped(_ sender: Any) {
        let alert = UIAlertController(title:"New Song",message:"fill in the information of you're new song",preferredStyle: .alert);
        let action1 = UIAlertAction(title: "Cancel",style:.cancel, handler:nil);
        let action2 = UIAlertAction(title: "Submit",style:.default, handler:nil);
        alert.addAction(action1);
        alert.addAction(action2);
        present(alert,animated: true,completion: nil);
    }


    @IBAction func OnAlertSheetTapped(_ sender: Any) {
        let sheet = UIAlertController(title:"my title",message:"my message",preferredStyle: .actionSheet);
        let action1 = UIAlertAction(title: "my action",style:.cancel){(action)in
            print("this is action 1")
        };
        let action2 = UIAlertAction(title: "my action",style:.default, handler:nil);
        sheet.addAction(action1);
        sheet.addAction(action2);
        present(sheet,animated: true,completion: nil);
    }
    
}

