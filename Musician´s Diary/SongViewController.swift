//
//  SongViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 31/03/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class SongViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

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
    var zeroCells = [IndexPath]()
    static var shouldAnimateFirstRow = false
    static var enteringFromLeft = true
    static var destroyPracticeId: Int? = nil
    
    // Define a view
    var popup:UIView!
    var popupConstraints: [NSLayoutConstraint] = []
    var labelConstraints: [NSLayoutConstraint] = []
    func showAlert() {
        // customise your view
        popup = UIView()
        popup.backgroundColor = UIColor(named: "cellBlue")
        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.layer.masksToBounds = true
        popup.layer.cornerRadius = 6
        self.view.addSubview(popup)
        
        let botConstraint = popup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let widthConstraint = popup.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let heightConstraint = popup.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08)
        popupConstraints = [botConstraint, widthConstraint, heightConstraint]
        NSLayoutConstraint.activate(popupConstraints)
        
        let label = UILabel()
        label.text = "Deleted practice sessions with 0 duration"
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        popup.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelWidthConstraint = label.widthAnchor.constraint(equalTo: popup.widthAnchor)
        let labelHeightConstraint = label.heightAnchor.constraint(equalTo: popup.heightAnchor)
        let labelXConstraint = label.centerYAnchor.constraint(equalTo: popup.centerYAnchor)
        let labelYConstraint = label.centerYAnchor.constraint(equalTo: popup.centerYAnchor)
        labelConstraints = [labelWidthConstraint, labelHeightConstraint, labelXConstraint, labelYConstraint]
        NSLayoutConstraint.activate(labelConstraints)

        
        // show on screen

        
        // set the timer
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.popup.alpha = 0
            })
            self.popup.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var startPracticeBtn: UIBarButtonItem!
    @IBOutlet weak var tableView4: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var stackView: UIStackView!
   
    
    @IBAction func pieceTrashed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete song?", message: "Are you sure you want to delete the song and all practice sessions associated with it", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            ViewController.destroySongId = self.chosenId
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func prependPostWithAnimation() {
        let animationDuration = 0.9
        let easeOutCirc = CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.0, 1)
        
        UIView.beginAnimations("addRow", context: nil)
        UIView.setAnimationDuration(animationDuration)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(easeOutCirc)
        
        tableView4.beginUpdates()
        let indexPath = IndexPath(row: db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: SongViewController.newHarjutusId), section: 0)
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
    
    fileprivate func animateOut(cell: UITableViewCell, withDelay delay: TimeInterval) {
        let initialScale: CGFloat = 1.0
        let duration: TimeInterval = 0.7
        

        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 0.0
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
        
        if SongViewController.newHarjutusId != nil{
            if indexPath.row == db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: SongViewController.newHarjutusId) && SongViewController.shouldAnimateFirstRow {
                prependPostWithAnimation()
                animateIn(cell: cell, withDelay: 0.8)
                SongViewController.shouldAnimateFirstRow = false
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
                cell.textField1.addTarget(self, action: #selector(SongViewController.nameFieldChange), for:UIControlEvents.editingChanged)
                nameCell = cell
            }
            else if indexPath.row == 1 {
                cell.textField1.addTarget(self, action: #selector(SongViewController.authorFieldChange), for: UIControlEvents.editingChanged)
                authorCell = cell
            }
            else if indexPath.row == 2 {
                cell.textField1.addTarget(self, action: #selector(SongViewController.commentFieldChange), for: UIControlEvents.editingChanged)
                commentCell = cell
            }
            if indexPath.row == 0 {
                cell.textField1.font = .systemFont(ofSize: 18)
            }
            print(indexPath.row)
            cell.textField1.text = db.selectSongField(pos: chosenId)[indexPath.row]

            return cell;
        }
        else{
            let cell = tableView4.dequeueReusableCell(withIdentifier: "customCell3") as!
            TableViewCell3
            let order = db.tableOrderByDate(table: db.harjutuskordTable, teosId: chosenId)
            var labels = db.selectHarjutuskordRow(pos: order[indexPath.row])

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
    @objc func removeCell() {
        tableView4.beginUpdates()
        let id = SongViewController.destroyPracticeId!
        print("destroyId: \(id)")
        let order = db.tableOrderByDate(table: db.harjutuskordTable, teosId: chosenId)
        print(order)
        for i in 0...order.count - 1 {
            if order[i] == id {
                print("row to delete \(i)")
                db.deletePracticeRow(harjutusId: id)
                tableView4.deleteRows(at: [IndexPath(row: i, section: 0)], with: .right)
            }
        }
        tableView4.endUpdates()
        SongViewController.destroyPracticeId = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        db.listTable()
        let deletion = db.harjutuskordDeleteWhereDurationZero(teosId: chosenId)
        print("deletion: \(deletion)")
        tableView4.reloadData()
        super.viewWillAppear(animated)
        /*
        if SongViewController.newHarjutusId != nil && SongViewController.shouldAnimateFirstRow{
            tableView4.insertRows(at: [IndexPath(row: db.tableNewRowPosition(table: db.harjutuskordTable, teosId: chosenId, newHarjutusId: SongViewController.newHarjutusId), section: 0)],
                                  with: .fade)
        }
 */
        if SongViewController.enteringFromLeft{
            animateTable()
        }
        else {
            if deletion > 0 {
                showAlert()
            }
            if SongViewController.destroyPracticeId != nil {
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SongViewController.removeCell), userInfo: nil, repeats: false)
            }
        }
    }
    override func viewDidLoad() {

        let tapper = UITapGestureRecognizer(target: self, action: #selector(SongViewController.handleSingleTap))
        tapper.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapper)
        tableView3.delegate = self
        tableView3.dataSource = self
        tableView4.delegate = self
        tableView4.dataSource = self
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? AddPracticeViewController{
            destination.chosenId = self.chosenId
        }
        if let destination = segue.destination as? NewPracticeViewController{
            destination.chosenId = self.chosenId
        }
        if let destination = segue.destination as? PracticeViewController{
            if tableView4.indexPathForSelectedRow != nil{
                destination.harjutusId = db.returnHarjutusId(teosId: chosenId, pos: (tableView4.indexPathForSelectedRow?.row)!)
            }
            else {
                print("no cell selected")
            }
        }
        
    }
}
