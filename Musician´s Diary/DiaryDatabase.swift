//
//  DiaryDatabase.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 10/01/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//


import SQLite

public class DiaryDatabase {

    
    // Logcat tag
    private static let LOG = "DiaryDatabase";
    // Database Version
    private static let DATABASE_VERSION = 8;
    
    static var dbManager = DiaryDatabase();
    
    //Song
    let songTable = Table("songs");
    let id = Expression<Int>("id");
    let name = Expression<String>("name");
    let author = Expression<String>("author");
    let comment = Expression<String>("comment");
    //Practice
    let practiceTable = Table("harjutuskorrad");
    let startTime = Expression<Date>("startTime");
    let duration = Expression<Int>("durationSekundites");
    let endTime = Expression<Date>("endTime");
    let addedToDiary = Expression<Date>("addedToDiary");
    let practiceDescription = Expression<String>("practiceDescription");
    let songId = Expression<Int>("songId")
    let audioFile = Expression<String>("audioFile")
    
    
    var database : Connection!;

    //MARK: General
    
    public func create_db(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3");
            let db = try Connection(fileUrl.path);
            self.database = db;
            print("connected to tb")
        }
        catch{
            print(error)
        }
    }
    
    public func create_tables(){
        
        let createsongTable = self.songTable.create{(table) in
            table.column(self.id,primaryKey: .autoincrement)
            table.column(self.name, defaultValue: "")
            table.column(self.author,defaultValue: "")
            table.column(self.comment,defaultValue: "")
        }
        do{
            try self.database.run(createsongTable)
            print("Created teos table")
        }catch{
            print(error);
        }
        
        let createpracticeTable = self.practiceTable.create{(table) in
            table.column(self.id,primaryKey: .autoincrement)
            table.column(self.startTime, defaultValue: Date())
            table.column(self.duration,defaultValue:0)
            table.column(self.endTime,defaultValue:Date())
            table.column(self.practiceDescription,defaultValue: "practice")
            table.column(self.addedToDiary)
            table.column(self.songId, references: songTable, id)
            table.column(self.audioFile,defaultValue:"")
        }
        do{
            try self.database.run(createpracticeTable)
            print("Created harjutuskord table")
        }catch{
            print(error);
        }
    }
    
    public func listTable(){
        do{
            print("Listing current Teos table")
            let songTable = try self.database.prepare(self.songTable)
            for user in songTable {
                print( "id: \(user[self.id]), name: \(user[self.name]), author: \(user[self.author])")
            }
        }catch{
            
        }
        do{
            print("Listing current hk table")
            let practiceTable = try self.database.prepare(self.practiceTable)
            for user in practiceTable {
                print( "id: \(user[self.id]),startTime: \(user[self.startTime]), duration: \(user[self.duration]), endTime: \(user[self.endTime]), songID: \(user[self.songId])")
                print("songID: \(user[self.songId])")
            }
        }catch{
            
        }
    }
    
    public func rowCount(table: Table) -> Int{
        var rowCount : Int!
        do{
            rowCount = try database.scalar(table.count)
        }catch{
            print(error)
        }
        return rowCount
    }

    //MARK Song
    
    public func selectSongField(pos: Int) -> [String] {
        var stringy = [String]()
        if database != nil{
            listTable()
            print("id: \(pos)")
         do{
            for user in try database.prepare(songTable.select(name,author,comment).filter(id == pos)){
                
                stringy = ["\(String(user[name]))","\(String(user[author]))","\(String(user[comment]))"]
                print("\(String(user[name]))")
                print("\(String(user[author]))")
                print("\(String(user[comment]))")
            }
         }
        
         catch{
            print(error)
        }
        }
        else{
            print("db is nil error")
        }
        return stringy
    }
    
    
    public func rowCountForId(targetId : Int,table: Table) -> Int{
        var rowCount : Int!
        do{
            rowCount = try database.scalar(table.count.filter(songId == targetId))
        }catch{
            print(error)
        }
        return rowCount
    }
    
    public func newSongRow() -> Int{
        var rowId: Int64!
        do{
            rowId = try database.run(songTable.insert())
            print("newrow")
        }catch{
            print(error)
        }
        return  Int(rowId)
    }
    
    public func deleteSongRow(targetSongId: Int) {
        do {
            let query = songTable.filter(self.id == targetSongId)
            try database.run(query.delete())
            let query2 = practiceTable.filter(self.songId == targetSongId)
            try database.run(query2.delete())
        } catch {
            print(error)
        }
    }
    
    public func editSongRow(targetId : Int, field : Expression<String>,value : String){
        let editRow = songTable.filter(id == targetId)
        do{
            try database.run(editRow.update(field <- value))
        }catch{
            print(error)
        }
    }
    
    public func updateSongRow(name:String,author:String,comment:String){
        var max : Int!
        do{
            max = try database.scalar(songTable.select(id.max))
        }catch{
            print(error)
        }
        let newRow = songTable.filter(id == max)
        do{
            try database.run(newRow.update(self.name <- name, self.author <- author, self.comment <- comment))
            print("newname: " + name)
        }catch{
            print(error)
        }
    }
    
    public func songTableOrder()-> [[Int]]{
        var idTable = [Int]()
        var countTable = [Int]()
        var durationTable = [Int]()
        var totalDuration = 0
        do{
            if database == nil{print("nilll")}
            for user in try database.prepare(songTable.select(id).order(id.desc)){
                idTable.append(user[id])
                countTable.append(try database.scalar(practiceTable.filter(songId == user[id]).count))
                for user in try database.prepare(practiceTable.filter(songId == user[id])){
                    totalDuration += user[duration]
                }
                durationTable.append(totalDuration)
                totalDuration = 0
            }
        }catch{
            print(error)
        }
        return [idTable, countTable, durationTable]
    }
    
    public func periodicPracticeStatistics(date: Date) -> String{
        var songName: NSString!
        var durationString: NSString!
        var string = ""
        do {
            let span = practiceTable.filter(startTime >= date.startOfMonth && startTime <= date.endOfMonth)
            for user in try database.prepare(span.select(songId, duration.sum).group(songId)) {
                for troll in try database.prepare(songTable.select(name).filter(id == user[songId]))
                {
                    songName = (troll[name] as NSString)
                }
                durationString = Tools.timeString(minutes: (user[duration.sum]!)/60) as NSString
                string = string + String(format: "%-20s %s \n",songName.utf8String!,durationString.utf8String!)
            }
        } catch {
            print(error)
        }
        print(string)
        return string
    }
    
    public func practiceinPeriod(date: Date) -> String {
        var previousDate: Date?
        previousDate = nil
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        var songName: NSString!
        var durationString: NSString!
        var index = 0
        let format = "%-30s %s \n"
        var dates = [String]()
        var table = [[String]]()
        var completeString = ""
        let cal = NSCalendar.current
        do {
            for user in try database.prepare(practiceTable.select(startTime,duration,songId).filter(startTime >= date.startOfMonth && startTime <= date.endOfMonth))
            {
                table.append([])
                for troll in try database.prepare(songTable.select(name).filter(id == user[songId]))
                {
                    songName = (troll[name] as NSString)
                }
                durationString = Tools.timeString(minutes: (user[duration])/60) as NSString
                if previousDate == nil {
                    table[0].append(String(format: format,songName.utf8String!,durationString.utf8String!))
                }
                else {
                    if !cal.isDate(user[startTime], inSameDayAs: previousDate!) {
                        index = index + 1
                        dates.append("\(dateFormatter.string(from: user[startTime]))\n")
                    }
                    table[index].append(String(format: format,songName.utf8String!,durationString.utf8String!))
                }
                previousDate = user[startTime]
            }
        } catch {
            print(error)
        }
        if dates.count > 0 {
            for index in 0...dates.count-1 {
                completeString = "\(completeString)\(dates[index])"
                for item in table[index] {
                    completeString = "\(completeString)\(item)"
                }
            }
        }
        print(completeString)
        return completeString
    }
    
    //MARK Practice
    
    public func deletePracticeRow(harjutusId: Int) {
        do {
            let query = practiceTable.filter(id == harjutusId)
            try database.run(query.delete())
        } catch {
            print(error)
        }
    }
    
    public func newPracticeRow(newId : Int)->Int64{
        var rowID : Int64!
        do{
            rowID = try database.run(practiceTable.insert(startTime <- Date(), duration <- 0, endTime <- Date(),addedToDiary <- Date(),songId <- newId))
            print("new practiceRow")
        }catch{
            print(error)
        }
        return rowID
    }
    
    
    public func tableOrderByDate(table: Table,targetSongId : Int)-> [Int]{
        var idTable = [Int]()
        do{
            for user in try database.prepare(table.select(id).filter(songId == targetSongId).order(startTime.desc)){
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return idTable
    }
    
    public func durationByDay(date : Date) -> [Int]{
        var dailyDuration = 0
        var count = 0
        do{
            for user in try database.prepare(practiceTable.select(duration).filter(startTime >= date.startOfDay && startTime <= date.endOfDay)){
                dailyDuration += user[duration]
                count += 1
            }
        }catch{
            print(error)
        }
        return [dailyDuration,count]
    }
    
    
    
    public func totalDurations() -> [Int]{
        var dayDuration = 0
        var weekDuration = 0
        var monthDuration = 0
        do{
            for user in try database.prepare(practiceTable.select(duration).filter(startTime >= Date().startOfDay))
            {
                dayDuration += user[duration]
            }
            for user in try database.prepare(practiceTable.select(duration).filter(startTime >= Date().startOfWeek))
            {
                weekDuration += user[duration]
            }
            for user in try database.prepare(practiceTable.select(duration).filter(startTime >= Date().startOfMonth))
            {
                monthDuration += user[duration]
            }
        }catch{
            print(error)
        }
        return [dayDuration, weekDuration, monthDuration]
    }
    
    public func durationForMonth(date: Date) -> Int {
        var monthlyDuration = 0
        do {
            for user in try database.prepare(practiceTable.select(duration).filter(startTime >= date.startOfMonth && startTime <= date.endOfMonth))
            {
                monthlyDuration += user[duration]
            }
        } catch {
            print(error)
        }
        return monthlyDuration
    }
 
    public func tableNewRowPosition(table: Table, targetSongId : Int, newPracticeId : Int)-> Int{
        var idTable = [Int]()
        do{
            for user in try database.prepare(table.select(id).filter(songId == targetSongId).order(startTime.desc)){
                if user[id] == newPracticeId
                {
                    return idTable.count
                }
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return 0
    }
    
    
    public func selectPracticeRow(pos: Int) -> [String] {
        var stringy = [String]()
        if database != nil{
            do{
                for user in try database.prepare(practiceTable.select(startTime,duration,endTime,practiceDescription,addedToDiary).filter(id == pos)){
                    
                    stringy = ["\(String(Tools.dateToStr(date: user[startTime])))","\(String(user[duration]))","\(String(Tools.dateToStr(date: user[endTime])))","\(String(user[practiceDescription]))","\(String(Tools.dateToStr(date: user[addedToDiary])))"]
                }
            }
                
            catch{
                print(error)
            }
        }
        else{
            print("db is nil error")
        }
        return stringy
    }
    
    public func returnPracticeId(targetSongId: Int,pos: Int) -> Int {
        var idTable = [Int]()
        do{
            for user in try database.prepare(practiceTable.select(id).filter(songId == targetSongId).order(startTime.desc)){
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return idTable[pos]
    }
    
    public func returnPracticeFilePath(practiceId: Int) -> String{
        var filepath: String!
        do{
            for user in try database.prepare(practiceTable.select(audioFile).filter(id == practiceId)) {
                filepath = user[audioFile]
                print("chosen audiofile:")
                print(filepath)
            }
        }catch{
            print(error)
        }
        return filepath
    }
    
    
    public func editPracticeTime(practiceId: Int64, startTime: Date, duration: Int, endTime: Date , filename: String = ""){
        do{
            let editRow = practiceTable.filter(id == Int(practiceId))
            try database.run(editRow.update(self.startTime <- startTime, self.duration <- duration, self.endTime <- endTime, self.audioFile <- filename))
        }catch{
            print(error)
        }
    }
    
    public func editPracticeDescription(practiceId : Int64, description : String){
        
        do{
            let editRow = practiceTable.filter(id == Int(practiceId))
            try database.run(editRow.update(self.practiceDescription <- description))
        }catch{
            print(error)
        }
    }
    public func practiceDeleteWhereDurationZero(targetSongId:Int) -> Int{
        var deletion = 0
        do{
            let row = practiceTable.filter(songId == targetSongId && duration == 0)
            print("row to delete)")
            deletion = try database.run(row.delete())
            print(deletion)
        }catch{
            print(error)
        }
        return deletion
    }

}

