//
//  ThirdViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 31/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    let algusaeg = 0
    let pikkus = 1
    let harjutuseKirjeldus = 3
    

    var db = PilliPaevikDatabase.dbManager
    var timeFormatter = DateComponentsFormatter()
    var chosenId:Int!
    static var newHarjutusId:Int!
    var nameCell : TableViewCell2!
    var authorCell : TableViewCell2!
    var commentCell : TableViewCell2!
    var tableRowHeight : Int!
    static var shouldAnimateFirstRow = false
    static var enteringFromLeft = true
    
    @IBOutlet weak var startPracticeBtn: UIBarButtonItem!
    @IBOutlet weak var tableView4: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK : tableview
    
    
    private func prependPostWithAnimation() {
        let animationDuration = 0.9
        let easeOutCirc = CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.0, 1)
        
        UIView.beginAnimations("addRow", context: nil)
        UIView.setAnimationDuration(animationDuration)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(easeOutCirc)
        
        tableView4.beginUpdates()
        let indexPath = IndexPath(row: db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: ThirdViewController.newHarjutusId), section: 0)
        tableView4.insertRows(at: [indexPath], with: .none)
        tableView4.endUpdates()
        
        CATransaction.commit()
        UIView.commitAnimations()
    }
    
    fileprivate func animateIn(cell: UITableViewCell, withDelay delay: TimeInterval) {
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.7
        
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    fileprivate func animateIn2(cell: UITableViewCell, withDelay delay: TimeInterval) {
        let initialScale: CGFloat = 1.05
        let duration: TimeInterval = 0.25
        
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ThirdViewController.newHarjutusId != nil{
            if indexPath.row == db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: ThirdViewController.newHarjutusId) && ThirdViewController.shouldAnimateFirstRow {
                prependPostWithAnimation()
                animateIn(cell: cell, withDelay: 0.8)
                ThirdViewController.shouldAnimateFirstRow = false
            }
            else{
                animateIn2(cell: cell, withDelay: 0.2)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView3{
            return 3
        }
        else{
            print("rowCount")
            print(db.rowCountForId(targetId: chosenId, table: db.harjutuskordTable))
            return db.rowCountForId(targetId: chosenId, table: db.harjutuskordTable)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableView4{
            return 70
        }
        else{
            if UIDevice.current.orientation.isLandscape{
            return 40
            }
            else{
                return 55
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView3{
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
            cell.textField1.text = db.selectField(pos: chosenId)[indexPath.row]

            return cell;
        }
        else{
            let cell = tableView4.dequeueReusableCell(withIdentifier: "customCell3") as!
            TableViewCell3
            var labels = db.selectHarjutuskordRow(pos:db.tableOrderByDate(table: db.harjutuskordTable, teosId: chosenId)[indexPath.row])
            cell.titleLabel.text = labels[harjutuseKirjeldus]
            cell.timeLabel.text = secToClock(sec: Double(labels[pikkus])!)
            cell.dateLabel.text = labels[algusaeg]
            
            return cell;
        }
    }
    
    @objc func nameFieldChange(){

        db.editTeosRow(targetId: chosenId, field: db.name, value: nameCell.textField1.text!)
        print("edited name")
        
    }
    @objc func authorFieldChange(){
        
        db.editTeosRow(targetId: chosenId, field: db.author, value: authorCell.textField1.text!)
        print("edited author")
        
    }
    @objc func commentFieldChange(){
        
        db.editTeosRow(targetId: chosenId, field: db.comment, value: commentCell.textField1.text!)
        print("edited comment")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func secToClock(sec : TimeInterval) -> String{
        timeFormatter.allowedUnits = [.hour,.minute,.second]
        timeFormatter.zeroFormattingBehavior = .pad
        return timeFormatter.string(from: sec)!
    }
    
    @objc func handleSingleTap(){
        self.view.endEditing(true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape{
            
        }
    }
    func animateTable() {
        tableView4.reloadData()
        let cells = tableView4.visibleCells
        let tableHeight: CGFloat = tableView4.bounds.size.width
        
        for i in cells{
            let cell : UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
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
        /*
        if ThirdViewController.newHarjutusId != nil && ThirdViewController.shouldAnimateFirstRow{
            tableView4.insertRows(at: [IndexPath(row: db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: ThirdViewController.newHarjutusId), section: 0)],
                                  with: .fade)
        }
 */
        if ThirdViewController.enteringFromLeft{
            animateTable()
        }
        else{
            tableView4.reloadData()
        }
    }
    override func viewDidLoad() {
        db.harjutuskordDeleteWhereDurationZero(teosId: chosenId)
        let tapper = UITapGestureRecognizer(target: self, action: #selector(ThirdViewController.handleSingleTap))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
        tableView3.delegate = self
        tableView3.dataSource = self
        tableView4.delegate = self
        tableView4.dataSource = self
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? FourthViewController{
            destination.chosenId = self.chosenId
        }
        if let destination = segue.destination as? FifthViewController{
            destination.chosenId = self.chosenId
        }
        if let destination = segue.destination as? HarjutusViewController{
            if tableView4.indexPathForSelectedRow != nil{
                destination.harjutusId = db.returnHarjutusId(teosId: chosenId, pos: (tableView4.indexPathForSelectedRow?.row)!)
            }
            else {
                print("no cell selectd")
            }
        }
        
    }
}
