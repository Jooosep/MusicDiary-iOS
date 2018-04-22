//
//  FourthViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 03/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    
    //lets
    let dateFormatter = DateFormatter()
    
    let alert = UIAlertController(title:"Alert",message:"Unable to pick future time",preferredStyle: .alert);
    let dismiss = UIAlertAction(title: "OK",style:.cancel, handler:nil);
    
    let configuringStart = 0
    let configuringEnd = 1
    let configuringDuration = 2
    
    
    //vars
    var db = PilliPaevikDatabase.dbManager
    
    var chosenId : Int!
    var harjutusId : Int64!
    
    var currentDate = Date()
    var endDate = Date()
    var startDate = Date()
    
    var pickerDataSize = 0
    var pickerMax = 0
    
    var beingConfigured : Int!
    

    //MARK:IBOutlets
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var startTimePicker: UIButton!
    @IBOutlet weak var endTimePicker: UIButton!
    @IBOutlet weak var durationPicker: UIButton!
    @IBOutlet weak var backGroundButton: UIButton!
    
    @IBOutlet weak var practiceDescription: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var datePickerCenterConstraint: NSLayoutConstraint!
    
    //MARK:IBActions
    @IBAction func descriptionChanged(_ sender: Any) {
        db.editHarjutuskordDescription(practiceId : harjutusId, description: practiceDescription.text!)
    }
    
    @IBAction func startTimePickerTapped(_ sender: Any) {
        beingConfigured = 0
        datePicker.date = startDate
        datePickerCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.backGroundButton.alpha = 0.5
        })
    }
    
    @IBAction func endTimePickerTapped(_ sender: Any) {
        beingConfigured = 1
        datePicker.date = endDate
        datePickerCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.backGroundButton.alpha = 0.5
        })
    }
    
    @IBAction func durationPickerTapped(_ sender: Any) {
        datePicker.alpha = 0
        pickerView.alpha = 1
        beingConfigured = 2
        datePickerCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.backGroundButton.alpha = 0.5})
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        datePickerCenterConstraint.constant = -400
        pickerView.alpha = 0
        datePicker.alpha = 1
        UIView.animate(withDuration: 0.1, animations: {self.view.layoutIfNeeded()
            self.backGroundButton.alpha = 0
        })
    }
    @IBAction func OKTapped(_ sender: Any) {
        if beingConfigured == 0{
            if datePicker.date > currentDate{
                present(alert,animated: true,completion: nil);
                return
            }
            else if datePicker.date > endDate{
                startDate = datePicker.date
                print(startDate)
                print(">")
                print(endDate)
                endDate = datePicker.date
                startTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
                endTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
            }
            else{
                startDate = datePicker.date
                startTimePicker.setTitle(dateFormatter.string(from: startDate), for: startTimePicker.state)
            }
        }
        else if beingConfigured == 1{
            if datePicker.date > currentDate{
                present(alert,animated: true,completion: nil);
                return
            }
            else if datePicker.date < startDate{
                startDate = datePicker.date
                endDate = datePicker.date
                startTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
                endTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
            }
            else{
                endDate = datePicker.date
                endTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
            }

        }
        else if beingConfigured == 2{
            pickerView.alpha = 0
            datePicker.alpha = 1
        }
        
        pickerMax = (Int(round((endDate.timeIntervalSince(startDate)/60.0))))
        print("pickermax")
        print(pickerMax)
 
        if (pickerMax > 25){
            pickerDataSize = 100_000
        }
        print(endDate.timeIntervalSince(startDate))
        print(pickerMax)
        pickerView.reloadComponent(0)
        if beingConfigured != 2 {
            durationPicker.setTitle(String(pickerMax), for: durationPicker.state)
            pickerView.selectRow(pickerMax, inComponent: 0, animated: false)
        }
        
        datePickerCenterConstraint.constant = 400
        UIView.animate(withDuration: 0.1, animations: {self.view.layoutIfNeeded()
            self.backGroundButton.alpha = 0
            
        })
        db.editHarjutuskordTime(practiceId:harjutusId, startTime: startDate, duration: (pickerMax)*60, endTime: endDate)
        print("edited duration")
        print(Int((durationPicker.titleLabel?.text)!)!*60)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK:pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerMax + 1 + pickerDataSize
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerMax > 25{
            print(row%pickerMax)
            return String(row%(pickerMax))
        }
        else{
            return String(row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerMax > 25{
            durationPicker.setTitle(String(row%pickerMax), for: durationPicker.state)
        }
        else{
            durationPicker.setTitle(String(row), for: durationPicker.state)
        }
    }
    
    @objc func handleSingleTap(){
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ThirdViewController.enteringFromLeft = false
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(ThirdViewController.handleSingleTap))
        tapper.cancelsTouchesInView = false
        print("chosenId: ")
        print(chosenId)
        harjutusId = db.newHarjutuskordRow(teosId: chosenId)
        ThirdViewController.newHarjutusId = Int(harjutusId)
        ThirdViewController.shouldAnimateFirstRow = true
        print("created new harjutuskord row")
        
        alert.addAction(dismiss);
        
        pickerView.delegate = self
        pickerView.dataSource = self
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        dateFormatter.dateFormat = "yyyy-MM-dd    HH:mm"
        startTimePicker.setTitle(dateFormatter.string(from: startDate), for: startTimePicker.state)
        endTimePicker.setTitle(dateFormatter.string(from: endDate), for: endTimePicker.state)
        durationPicker.setTitle("0", for: durationPicker.state)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? ThirdViewController{
            destination.chosenId = self.chosenId
        }
    }
}
