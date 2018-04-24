//
//  Tools.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 24/04/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//

import Foundation

public class Tools {
    static func timeString(minutes: Int) -> String{
        if minutes < 60 {
            return minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
        }
        else {
            let hours = minutes / 60
            let minutes = minutes - hours * 60
            return "\(hours) \(hours > 1 ? "hours" : "hour") \(minutes) \(minutes == 1 ? "minute" : "minutes")"
        }
    }
}
