//
//  File.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 12/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
        
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    var startOfWeek: Date {
        var date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        date = date.addingTimeInterval(24 * 3600)
        let dslTImeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTImeOffset)
        
    }
    var startOfMonth: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
}
