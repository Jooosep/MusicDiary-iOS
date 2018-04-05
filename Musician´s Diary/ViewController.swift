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
    
    static var dbManager = PilliPaevikDatabase();
    static var justOpened : Bool!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(ViewController.dbManager.rowCount(table:ViewController.dbManager.teosTable))
        return ViewController.dbManager.rowCount(table:ViewController.dbManager.teosTable)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
        TableViewCell1
        cell.label.text = ViewController.dbManager.selectField(pos:ViewController.dbManager.tableOrder(table: ViewController.dbManager.teosTable)[ViewController.dbManager.rowCount(table:ViewController.dbManager.teosTable) - indexPath.row - 1])[0]
        return cell;
    }


    @IBOutlet weak var tableView1: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? ThirdViewController{
            destination.chosenId = ViewController.dbManager.tableOrder(table:ViewController.dbManager.teosTable ) [ViewController.dbManager.rowCount(table:ViewController.dbManager.teosTable) - (tableView1.indexPathForSelectedRow?.row)! - 1]
        }
    }
    
    override func viewDidLoad() {
        
        if ViewController.justOpened == true || ViewController.justOpened == nil{
            ViewController.dbManager.create_db()
            ViewController.justOpened = false
        }
        if !UserDefaults.standard.bool(forKey: "firstOpen"){
            ViewController.dbManager.create_tables();
            UserDefaults.standard.register(defaults: ["firstOpen" : true])
            UserDefaults.standard.set(true, forKey: "firstOpen")
            print("opened app for first time")
        }
        tableView1.delegate = self
        tableView1.dataSource = self
        
        super.viewDidLoad();
        
    }
    @IBAction func OnActionTapped(_ sender: Any) {
        let alert = UIAlertController(title:"New Song",message:"fill in the information of you're new song",preferredStyle: .alert);
        let action1 = UIAlertAction(title: "Cancel",style:.cancel, handler:nil);
        let action2 = UIAlertAction(title: "Submit",style:.default, handler:nil);
        alert.addAction(action1);
        alert.addAction(action2);
        present(alert,animated: true,completion: nil);
        ViewController.dbManager.listTable()
    }


    @IBAction func OnAlertSheetTapped(_ sender: Any) {
        let sheet = UIAlertController(title:"my title",message:"my message",preferredStyle: .actionSheet);
        let action1 = UIAlertAction(title: "my action",style:.cancel){(action)in
            print("this is action 1")
        };
        let action2 = UIAlertAction(title: "clear table",style:.default){(action)in
            ViewController.dbManager.clear_table()
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
            
        }
        sheet.addAction(action1);
        sheet.addAction(action2);
        present(sheet,animated: true,completion: nil);
    }
    
}

