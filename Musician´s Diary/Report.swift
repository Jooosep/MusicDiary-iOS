//
//  Report.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 22/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import Foundation

public class Report {
    var reportTitle: String!
    var periodTitle: String!
    var startDate: Date!
    var endDate: Date!
    var lengthOfPeriod: Int!
    var firstName: String!
    var lastName: String!
    var instrument: String!
    var teacherFirstName: String!
    var teacherLastName: String!
    var teacherEmail: String!
    var dailyGoal: String!
    var dailyGoalInt: Int!
    var minutesPracticed: Int!
    var dateFormatter = DateFormatter()
    var db = PilliPaevikDatabase.dbManager
    
    init(date: Date) {
        dateFormatter.dateFormat = "MMM yyyy"
        periodTitle = dateFormatter.string(from: date)
        startDate = date.startOfMonth
        endDate = date.endOfMonth
        minutesPracticed = db.durationForMonth(date: date)/60
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        lengthOfPeriod = range?.count
        firstName = UserDefaults.standard.object(forKey: "firstName") as! String
        lastName = UserDefaults.standard.object(forKey: "lastName") as! String
        instrument = UserDefaults.standard.object(forKey: "instrument") as! String
        teacherFirstName = UserDefaults.standard.object(forKey: "teacherFirstName") as! String
        teacherLastName = UserDefaults.standard.object(forKey: "teacherLastName") as! String
        teacherEmail = UserDefaults.standard.object(forKey: "teacherEmail") as! String
        dailyGoal = UserDefaults.standard.object(forKey: "dailyGoal") as! String
        dailyGoalInt = Int(dailyGoal)
        print("start of report month")
        print(startDate)
        print(lengthOfPeriod)
    }
    private func timeString(minutes: Int) -> String{
        if minutes < 60 {
            return minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
        }
        else {
            let hours = minutes / 60
            let minutes = minutes - hours * 60
            return "\(hours) \(hours > 1 ? "hours" : "hour") \(minutes) \(minutes == 1 ? "minute" : "minutes")"
        }
    }
    
    public func theme() -> String {
        return "Musician's Diary monthly report - \(firstName) \(lastName), \(instrument), \(periodTitle)"
    }
    
    private func summary() -> String {
        var summary = "Summary\n\n"
        if dailyGoalInt > 0 {
            summary = "\(summary)Recommended daily practice time: \(Tools.timeString(minutes: dailyGoalInt))\n"
            summary = "\(summary)Recommended total practice time: \(Tools.timeString(minutes: dailyGoalInt * lengthOfPeriod))\n"
            summary = "\(summary)Actual total practice time: \(Tools.timeString(minutes: minutesPracticed))\n\n"
        }
        summary = "\(summary)\(db.periodicPracticeStatistics(date: startDate))\n"
        return summary
    }
    
    private func detailedContent() -> String{
        var detail = ""
        return ""
    }
    
}
/*
UserDefaults.standard.object(forKey: "firstName") as? String
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
 */
