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
    var idOrderTable = [Int]()
    var practiceCountTable = [Int]()
    var durationTable = [Int]()
    var timeFormatter = DateComponentsFormatter()
    var dailyGoal = 100.0
    
    static var justOpened : Bool!
    
    
    @IBOutlet weak var screenDimmer: UIButton!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var sideBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var progressBarImage: UIImageView!
    
    @IBOutlet weak var progressBarImage2: UIImageView!

    @IBOutlet weak var progressBarImage3: UIImageView!
    @IBOutlet weak var barCover1: UIImageView!
    @IBOutlet weak var barCover2: UIImageView!
    @IBOutlet weak var barCover3: UIImageView!
    
    @IBOutlet weak var progressBarWidthConstraint1: NSLayoutConstraint!
    
    @IBOutlet weak var progressBarWidthConstraint2: NSLayoutConstraint!
    
    @IBOutlet weak var progressBarWidthConstraint3: NSLayoutConstraint!
    
    
    @IBAction func panPerformed(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view).x
            if translation > 0 {
                if self.sideBarLeadingConstraint.constant < 0 {
                    self.sideBarLeadingConstraint.constant += translation/10
                    screenDimmer.alpha += 0.01
                }
            }
        }
        else if sender.state == .ended {
            if sideBarLeadingConstraint.constant > -165 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.sideBarLeadingConstraint.constant = 0
                    self.screenDimmer.alpha = 0.8
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.sideBarLeadingConstraint.constant = -325
                    self.screenDimmer.alpha = 0
                })
            }
        }
        print(sideBarLeadingConstraint.constant)
    }
    @IBAction func sideMenuPanned(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view).x
            if translation < 0 {
                self.sideBarLeadingConstraint.constant += translation/10
                screenDimmer.alpha -= 0.01
            }
        }
        else if sender.state == .ended {
            if sideBarLeadingConstraint.constant > -165 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.sideBarLeadingConstraint.constant = 0
                    self.screenDimmer.alpha = 0.8
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.sideBarLeadingConstraint.constant = -325
                    self.screenDimmer.alpha = 0
                })
            }
        }
        print(sideBarLeadingConstraint.constant)
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows in table")
        print(db.rowCount(table:db.teosTable))
        return db.rowCount(table:db.teosTable)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.75

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "customCell") as!
            TableViewCell1
            cell.label.text = db.selectField(pos : idOrderTable[indexPath.row])[0]
            return cell;
        }
        else{
            let cell = tableView2.dequeueReusableCell(withIdentifier: "customCellTwo") as!
            TableViewCell4
            cell.leftLabel.text =  String(practiceCountTable[indexPath.row])
            cell.rightLabel.text = timeString(time: durationTable[indexPath.row])
            return cell
        }
    }
    func timeString(time:Int) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        return String(format:"%02i:%02i",hours,minutes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ThirdViewController{
            if tableView1.indexPathForSelectedRow != nil{
                destination.chosenId = idOrderTable[(tableView1.indexPathForSelectedRow?.row)!]
            }
            else {
                destination.chosenId = db.newTeosRow()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView1 == scrollView {
            tableView2.contentOffset = tableView1.contentOffset
        }
        else if tableView2 == scrollView {
            tableView1.contentOffset = tableView2.contentOffset
        }
    }
    func setProgressBars() {
        let calender = CFCalendarCopyCurrent()
        let days = CFCalendarGetRangeOfUnit(calender, CFCalendarUnit.day, CFCalendarUnit.month, CFAbsoluteTimeGetCurrent())
        print("days in this month")
        print(days.length)
        
        let weeklyGoal = dailyGoal * 7.0
        let monthlyGoal = 10.0 * Double(days.length)
        
        var aggregatedDurations = db.totalDurations()
        let dailyDuration = Double(aggregatedDurations[0])
        let weeklyDuration = Double(aggregatedDurations[1])
        let monthlyDuration = Double(aggregatedDurations[2])
        
        let dayMultiplier = CGFloat(dailyDuration/60.0/dailyGoal * 0.55)
        print("dayMultiplier")
        print(dayMultiplier)
        let weekMultiplier = CGFloat(Double((weeklyDuration/60.0)/weeklyGoal) * 0.55)
        let monthMultiplier = CGFloat(monthlyDuration/60.0/monthlyGoal * 0.55)
        print("dailyDuration")
        print(dailyDuration)
        
        if dayMultiplier >= 0.55 {
            progressBarWidthConstraint1 = progressBarWidthConstraint1.setMultiplier(multiplier: 0.55)
        }
        else{
            progressBarWidthConstraint1 = progressBarWidthConstraint1.setMultiplier(multiplier: dayMultiplier)
        }
        if weekMultiplier >= 0.55 {
            progressBarWidthConstraint2 = progressBarWidthConstraint2.setMultiplier(multiplier: 0.55)
        }
        else{
            progressBarWidthConstraint2 = progressBarWidthConstraint2.setMultiplier(multiplier: weekMultiplier)
        }
        if monthMultiplier >= 0.55 {
            progressBarWidthConstraint3 = progressBarWidthConstraint3.setMultiplier(multiplier: 0.55)
        }
        else{
            progressBarWidthConstraint3 = progressBarWidthConstraint3.setMultiplier(multiplier: monthMultiplier)
        }
    }
    
    func animateTable(){
        tableView1.reloadData()
        tableView2.reloadData()
        let cells = tableView1.visibleCells
        let cells2 = tableView2.visibleCells
        let tableHeight: CGFloat = tableView1.bounds.size.height
        let tableHeight2: CGFloat = tableView2.bounds.size.height
        for i in cells{
            let cell : UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        for i in cells2{
            let cell : UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight2)
        }
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:[], animations: {cell.transform = CGAffineTransform(translationX: 0, y: 0)}, completion: nil)
            index += 1
        }
        for a in cells2 {
            let cell: UITableViewCell = a
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:[], animations: {cell.transform = CGAffineTransform(translationX: 0, y: 0)}, completion: nil)
            index += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ThirdViewController.enteringFromLeft = true
        let tableOrder = db.tableOrder(table: db.teosTable)
        idOrderTable = tableOrder[0]
        practiceCountTable = tableOrder[1]
        durationTable = tableOrder[2]
        
        super.viewWillAppear(animated)
        animateTable()
        setProgressBars()
        
    }
    override func viewDidLoad() {
        
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        /*
        print(dateFormatter.string(from: Date().startOfDay))
        print(dateFormatter.string(from: Date().startOfWeek))
        print(dateFormatter.string(from: Date().startOfMonth))
 */
        
        progressBarImage.layer.masksToBounds = true
        progressBarImage.layer.cornerRadius = 6
        progressBarImage2.layer.masksToBounds = true
        progressBarImage2.layer.cornerRadius = 6
        progressBarImage3.layer.masksToBounds = true
        progressBarImage3.layer.cornerRadius = 6
        barCover1.layer.masksToBounds = true
        barCover1.layer.cornerRadius = 6
        barCover2.layer.masksToBounds = true
        barCover2.layer.cornerRadius = 6
        barCover3.layer.masksToBounds = true
        barCover3.layer.cornerRadius = 6

        
        if ViewController.justOpened == true || ViewController.justOpened == nil{
            db.create_db()
            ViewController.justOpened = false
        }
        
        let tableOrder = db.tableOrder(table: db.teosTable)
        idOrderTable = tableOrder[0]
        practiceCountTable = tableOrder[1]
        durationTable = tableOrder[2]
        
        
        
        if !UserDefaults.standard.bool(forKey: "firstOpen"){
            db.create_tables();
            UserDefaults.standard.set("", forKey: "firstName")
            UserDefaults.standard.set("",forKey: "lastName")
            UserDefaults.standard.set("",forKey: "email")
            UserDefaults.standard.set("",forKey: "school")
            UserDefaults.standard.set("",forKey: "class")
            UserDefaults.standard.set("",forKey: "instrument")
            UserDefaults.standard.set("",forKey: "teacherFirstName")
            UserDefaults.standard.set("",forKey: "teacherLastName")
            UserDefaults.standard.set("",forKey: "teacherEmail")
            UserDefaults.standard.set("",forKey: "dailyGoal")
            UserDefaults.standard.register(defaults: ["firstOpen" : true])
            UserDefaults.standard.set(true, forKey: "firstOpen")
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let documenDirectoryPath = documentDirectoryPath {
                let audioDirectoryPath = documentDirectoryPath?.appending("/recordings")
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: audioDirectoryPath!) {
                    do {
                        try fileManager.createDirectory(atPath: audioDirectoryPath!, withIntermediateDirectories: false, attributes: nil)
                    }catch {
                        print("error creating recordings Directory")
                        print(error)
                    }
                }
            }
            print("opened app for first time")
        }
        
        setProgressBars()
        
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
    @IBAction func sendReportButtonTapped(_ sender: UIButton) {

    }
    @IBAction func settingsButtonTapped(_ sender: UIButton) {

    }
    @IBAction func informationButtonTapped(_ sender: UIButton) {

    }
    @IBAction func practiceCalendarButtonTapped(_ sender: UIButton) {
    }
}

