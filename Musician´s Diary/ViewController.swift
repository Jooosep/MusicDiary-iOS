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
class ViewController: UIViewController {
    
    var database: Connection!;
    let teosTable = Table("teosed");
    let id = Expression<Int>("id");
    let name = Expression<String>("name");
    let author = Expression<String>("author");
    
    override func viewDidLoad() {
        super.viewDidLoad();
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3");
            let database = try Connection(fileUrl.path);
            self.database = database;
        }
        catch{
            print(error)
        }
    }
    @IBAction func OnActionTapped(_ sender: Any) {
        let createTable = self.teosTable.create{(table) in
            table.column(self.id,primaryKey: true)
            table.column(self.name)
            table.column(self.author)
        }
        do{
            try self.database.run(createTable)
            print("Created table")
        }catch{
            print(error);
        }
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

