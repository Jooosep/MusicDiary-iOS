//
//  CalendarViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 17/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db = DiaryDatabase.dbManager
    var date = Date()
    var dateFormatter = DateFormatter()

    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows in table")
        return 60
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.75
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
            TableViewCell1
            date = Date().addingTimeInterval(-60.0 * 60.0 * 24.0 * Double(indexPath.row))
            cell.label.text = dateFormatter.string(from: date)
            return cell;
        }
        else{
            let cell = tableView2.dequeueReusableCell(withIdentifier: "customCellTwo") as! TableViewCell4
            date = Date().addingTimeInterval(-60.0 * 60.0 * 24.0 * Double(indexPath.row))
            cell.leftLabel.text =  String(db.durationByDay(date: date)[1])
            cell.rightLabel.text = timeString(time: db.durationByDay(date: date)[0])
            return cell
        }
    }
    func timeString(time:Int) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        return String(format:"%02i:%02i",hours,minutes)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView1 == scrollView {
            tableView2.contentOffset = tableView1.contentOffset
        }
        else if tableView2 == scrollView {
            tableView1.contentOffset = tableView2.contentOffset
        }
    }
    
    override func viewDidLoad() {
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        dateFormatter.dateFormat = "EEE, MMM dd"
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



}
