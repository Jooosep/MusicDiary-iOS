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
    
    var db = PilliPaevikDatabase.dbManager
    static var justOpened : Bool!
    @IBOutlet weak var tableView1: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(db.rowCount(table:db.teosTable))
        return db.rowCount(table:db.teosTable)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
        TableViewCell1
        cell.cellView.backgroundColor = UIColor(named: "cellBlue")
        cell.label.text = db.selectField(pos:db.tableOrder(table: db.teosTable)[db.rowCount(table:db.teosTable) - indexPath.row - 1])[0]
        return cell;
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? ThirdViewController{
            destination.chosenId = db.tableOrder(table:db.teosTable ) [db.rowCount(table:db.teosTable) - (tableView1.indexPathForSelectedRow?.row)! - 1]
            print("teos id:")
            print(db.tableOrder(table:db.teosTable ) [db.rowCount(table:db.teosTable) - (tableView1.indexPathForSelectedRow?.row)! - 1])
        }
    }
    func animateTable(){
        tableView1.reloadData()
        let cells = tableView1.visibleCells
        let tableHeight: CGFloat = tableView1.bounds.size.height
        
        for i in cells{
            let cell : UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:[], animations: {cell.transform = CGAffineTransform(translationX: 0, y: 0)}, completion: nil)
            index += 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        animateTable()
    }
    override func viewDidLoad() {
        
        if ViewController.justOpened == true || ViewController.justOpened == nil{
            db.create_db()
            ViewController.justOpened = false
        }
        if !UserDefaults.standard.bool(forKey: "firstOpen"){
            db.create_tables();
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
        db.listTable()
    }


    @IBAction func OnAlertSheetTapped(_ sender: Any) {
        let sheet = UIAlertController(title:"my title",message:"my message",preferredStyle: .actionSheet);
        let action1 = UIAlertAction(title: "my action",style:.cancel){(action)in
            print("this is action 1")
        };
        let action2 = UIAlertAction(title: "clear table",style:.default){(action)in
            self.db.clear_table()
            DispatchQueue.main.async {
                self.tableView1.reloadData()
            }
            
        }
        sheet.addAction(action1);
        sheet.addAction(action2);
        present(sheet,animated: true,completion: nil);
    }
    
}

