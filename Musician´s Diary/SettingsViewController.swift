//
//  SettingsViewController.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 15/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var myFirstNameTextField: UITextField!
    @IBOutlet weak var myLastNameTextField: UITextField!
    @IBOutlet weak var myEmailTextField: UITextField!
    @IBOutlet weak var musicSchoolTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var instrumentTextField: UITextField!
    @IBOutlet weak var teacherFirstNameTextField: UITextField!
    @IBOutlet weak var teacherLastNameTextField: UITextField!
    @IBOutlet weak var teacherEmailTextField: UITextField!
    @IBOutlet weak var practiceGoalTextField: UITextField!
    @IBOutlet weak var autostartStopwatchSwitch: UISwitch!
    @IBOutlet weak var shortcutSwitch: UISwitch!
    @IBOutlet weak var dayStatisticsSwitch: UISwitch!
    @IBOutlet weak var recordingSwitch: UISwitch!
    @IBOutlet weak var googleDriveSwitch: UISwitch!
    

    @IBAction func autostartStopwatchTapped(_ sender: UIButton) {
        if autostartStopwatchSwitch.isOn {
            print("stopwatch off")
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()
                self.autostartStopwatchSwitch.isOn = false
            })
            UserDefaults.standard.set(false, forKey: "autostartStopwatch")
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()
            self.autostartStopwatchSwitch.isOn = true
            })
            print("stopwatch on")
            UserDefaults.standard.set(true, forKey: "autostartStopwatch")
        }
    }
    @IBAction func shortcutButtonTapped(_ sender: UIButton) {
        if shortcutSwitch.isOn {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.shortcutSwitch.isOn = false
            })
            UserDefaults.standard.set(false, forKey: "shortcut")
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.shortcutSwitch.isOn = true
            })
            UserDefaults.standard.set(true, forKey: "shortcut")
        }
    }
    @IBAction func dayStatisticsButtonTapped(_ sender: UIButton) {
        if dayStatisticsSwitch.isOn {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.dayStatisticsSwitch.isOn = false
            })
            UserDefaults.standard.set(false, forKey: "dayStatistics")
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.dayStatisticsSwitch.isOn = true
            })
            UserDefaults.standard.set(true, forKey: "dayStatistics")
        }
    }
    @IBAction func recordingButtonTapped(_ sender: UIButton) {
        if recordingSwitch.isOn {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.recordingSwitch.isOn = false
            })
            UserDefaults.standard.set(false, forKey: "recording")
            if googleDriveSwitch.isOn {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.googleDriveSwitch.isOn = false
                })
                UserDefaults.standard.set(false, forKey: "googleDrive")
            }
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()
                self.recordingSwitch.isOn = true
            })
            UserDefaults.standard.set(true, forKey: "recording")
        }
    }
    @IBAction func googleDriveButtonTapped(_ sender: UIButton) {
        if googleDriveSwitch.isOn {
            UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()
                self.googleDriveSwitch.isOn = false
            })
            UserDefaults.standard.set(false, forKey: "googleDrive")
        }
        else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.googleDriveSwitch.isOn = true
            })
            UserDefaults.standard.set(true, forKey: "googleDrive")
            if !recordingSwitch.isOn {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.recordingSwitch.isOn = true
                })
                UserDefaults.standard.set(true, forKey: "recording")
            }
        }
    }
    @IBAction func firstNameChanged(_ sender: Any) {
        UserDefaults.standard.setValue(myFirstNameTextField.text, forKey: "firstName")
    }
    @IBAction func lastNameChanged(_ sender: Any) {
        UserDefaults.standard.setValue(myLastNameTextField.text, forKey: "lastName")
    }
    @IBAction func emailChanged(_ sender: Any) {
        UserDefaults.standard.setValue(myEmailTextField.text, forKey: "email")
    }
    @IBAction func schoolChanged(_ sender: Any) {
        UserDefaults.standard.setValue(musicSchoolTextField.text, forKey: "school")
    }
    @IBAction func classChanged(_ sender: Any) {
        UserDefaults.standard.setValue(classTextField.text, forKey: "class")
    }
    @IBAction func instrumentChanged(_ sender: Any) {
        UserDefaults.standard.setValue(instrumentTextField.text, forKey: "instrument")
    }
    @IBAction func teacherFirstNameChanged(_ sender: Any) {
        UserDefaults.standard.setValue(teacherFirstNameTextField.text, forKey: "teacherFirstName")
    }
    @IBAction func teacherLastNameChanged(_ sender: Any) {
        UserDefaults.standard.setValue(teacherLastNameTextField.text, forKey: "teacherLastName")
    }
    
    @IBAction func teacherEmailChanged(_ sender: Any) {
        UserDefaults.standard.setValue(teacherEmailTextField.text, forKey: "teacherEmail")
    }
    @IBAction func dailyGoalChanged(_ sender: Any) {
        UserDefaults.standard.setValue(practiceGoalTextField.text, forKey: "dailyGoal")
    }
    
    override func viewDidLoad() {
        
        myFirstNameTextField.underlined()
        myLastNameTextField.underlined()
        myEmailTextField.underlined()
        musicSchoolTextField.underlined()
        classTextField.underlined()
        instrumentTextField.underlined()
        teacherFirstNameTextField.underlined()
        teacherLastNameTextField.underlined()
        teacherEmailTextField.underlined()
        practiceGoalTextField.underlined()
        autostartStopwatchSwitch.isOn = UserDefaults.standard.bool(forKey: "autostartStopwatch")
        shortcutSwitch.isOn = UserDefaults.standard.bool(forKey: "shortcut")
        dayStatisticsSwitch.isOn = UserDefaults.standard.bool(forKey: "dayStatistics")
        recordingSwitch.isOn = UserDefaults.standard.bool(forKey: "recording")
        googleDriveSwitch.isOn = UserDefaults.standard.bool(forKey: "googleDrive")
        
        if UserDefaults.standard.object(forKey: "firstName") as? String != "" {
        myFirstNameTextField.text = UserDefaults.standard.object(forKey: "firstName") as? String
        }
        if UserDefaults.standard.object(forKey: "lastName") as? String != "" {
            myLastNameTextField.text = UserDefaults.standard.object(forKey: "lastName") as? String
        }
        if UserDefaults.standard.object(forKey: "email") as? String != "" {
            myEmailTextField.text = UserDefaults.standard.object(forKey: "email") as? String
        }
        if UserDefaults.standard.object(forKey: "school") as? String != "" {
            musicSchoolTextField.text = UserDefaults.standard.object(forKey: "school") as? String
        }
        if UserDefaults.standard.object(forKey: "class") as? String != "" {
            classTextField.text = UserDefaults.standard.object(forKey: "class") as? String
        }
        if UserDefaults.standard.object(forKey: "instrument") as? String != "" {
            instrumentTextField.text = UserDefaults.standard.object(forKey: "instrument") as? String
        }
        if UserDefaults.standard.object(forKey: "teacherFirstName") as? String != "" {
            teacherFirstNameTextField.text = UserDefaults.standard.object(forKey: "teacherFirstName") as? String
        }
        if UserDefaults.standard.object(forKey: "teacherLastName") as? String != "" {
            teacherLastNameTextField.text = UserDefaults.standard.object(forKey: "teacherLastName") as? String
        }
        if UserDefaults.standard.object(forKey: "teacherEmail") as? String != "" {
            teacherEmailTextField.text = UserDefaults.standard.object(forKey: "teacherEmail") as? String
        }
        if UserDefaults.standard.object(forKey: "dailyGoal") as? String != "" {
            practiceGoalTextField.text = UserDefaults.standard.object(forKey: "dailyGoal") as? String
        }
        super.viewDidLoad()
    }

    

}
