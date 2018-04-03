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
    
    var dbManager = PilliPaevikDatabase();
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dbManager.rowCount(table:dbManager.teosTable)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
        TableViewCell1
        cell.label.text = dbManager.selectField(pos: dbManager.rowCount(table:dbManager.teosTable) - indexPath.row - 1)[0]
        return cell;
    }


    @IBOutlet weak var tableView1: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SecondViewController{
            destination.dbManager = self.dbManager
        }
        if let destination = segue.destination as? ThirdViewController{
            destination.dbManager = self.dbManager
            destination.chosenTeos = dbManager.rowCount(table:dbManager.teosTable) - (tableView1.indexPathForSelectedRow?.row)! - 1
            destination.chosenId = dbManager.rowCount(table:dbManager.teosTable) - (tableView1.indexPathForSelectedRow?.row)!
        }
    }
    override func viewDidLoad() {
        tableView1.delegate = self
        tableView1.dataSource = self
        
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
        dbManager.listTable()
    }


    @IBAction func OnAlertSheetTapped(_ sender: Any) {
        let sheet = UIAlertController(title:"my title",message:"my message",preferredStyle: .actionSheet);
        let action1 = UIAlertAction(title: "my action",style:.cancel){(action)in
            print("this is action 1")
        };
        let action2 = UIAlertAction(title: "clear table",style:.default){(action)in
            self.dbManager.clear_table()
        }
        sheet.addAction(action1);
        sheet.addAction(action2);
        present(sheet,animated: true,completion: nil);
    }
    
}

