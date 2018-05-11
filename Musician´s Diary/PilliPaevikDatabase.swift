//
//  PilliPaevikDatabase.swift
//  Musician´s Diary
//
//  Created by Joosep Teemaa on 10/01/2018.
//  Copyright © 2018 Mihkel Märtin. All rights reserved.
//


import SQLite

public class PilliPaevikDatabase {

    
    // Logcat tag
    private static let LOG = "PilliPaevikDatabase";
    // Database Version
    private static let DATABASE_VERSION = 8;
    
    static var dbManager = PilliPaevikDatabase();
    
    //Teos
    let teosTable = Table("teosed");
    let id = Expression<Int>("id");
    let name = Expression<String>("name");
    let author = Expression<String>("author");
    let comment = Expression<String>("comment");
    //Harjutuskord
    let harjutuskordTable = Table("harjutuskorrad");
    let algusaeg = Expression<Date>("algusaeg");
    let pikkus = Expression<Int>("pikkusSekundites");
    let lopuaeg = Expression<Date>("lopuaeg");
    let lisatudPaevikusse = Expression<Date>("lisatudPaevikusse");
    let harjutuseKirjeldus = Expression<String>("harjutuseKirjeldus");
    let teoseId = Expression<Int>("teoseId")
    let helifail = Expression<String>("helifail")
    
    
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
        
        let createTeosTable = self.teosTable.create{(table) in
            table.column(self.id,primaryKey: .autoincrement)
            table.column(self.name, defaultValue: "")
            table.column(self.author,defaultValue: "")
            table.column(self.comment,defaultValue: "")
        }
        do{
            try self.database.run(createTeosTable)
            print("Created teos table")
        }catch{
            print(error);
        }
        
        let createHarjutuskordTable = self.harjutuskordTable.create{(table) in
            table.column(self.id,primaryKey: .autoincrement)
            table.column(self.algusaeg, defaultValue: Date())
            table.column(self.pikkus,defaultValue:0)
            table.column(self.lopuaeg,defaultValue:Date())
            table.column(self.harjutuseKirjeldus,defaultValue: "practice")
            table.column(self.lisatudPaevikusse)
            table.column(self.teoseId, references: teosTable, id)
            table.column(self.helifail,defaultValue:"")
        }
        do{
            try self.database.run(createHarjutuskordTable)
            print("Created harjutuskord table")
        }catch{
            print(error);
        }
    }
    
    public func listTable(){
        do{
            print("Listing current Teos table")
            let teosTable = try self.database.prepare(self.teosTable)
            for user in teosTable {
                print( "id: \(user[self.id]), name: \(user[self.name]), author: \(user[self.author])")
            }
        }catch{
            
        }
        do{
            print("Listing current hk table")
            let harjutuskordTable = try self.database.prepare(self.harjutuskordTable)
            for user in harjutuskordTable {
                print( "id: \(user[self.id]),algusaeg: \(user[self.algusaeg]), pikkus: \(user[self.pikkus]), lopuaeg: \(user[self.lopuaeg]), teosID: \(user[self.teoseId])")
                print("teosID: \(user[self.teoseId])")
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
            for user in try database.prepare(teosTable.select(name,author,comment).filter(id == pos)){
                
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
            rowCount = try database.scalar(table.count.filter(teoseId == targetId))
        }catch{
            print(error)
        }
        return rowCount
    }
    
    public func newTeosRow() -> Int{
        var rowId: Int64!
        do{
            rowId = try database.run(teosTable.insert())
            print("newrow")
        }catch{
            print(error)
        }
        return  Int(rowId)
    }
    
    public func deleteTeosRow(teosId: Int) {
        do {
            let query = teosTable.filter(id == teosId)
            try database.run(query.delete())
            let query2 = harjutuskordTable.filter(teoseId == teosId)
            try database.run(query2.delete())
        } catch {
            print(error)
        }
    }
    
    public func editTeosRow(targetId : Int, field : Expression<String>,value : String){
        let editRow = teosTable.filter(id == targetId)
        do{
            try database.run(editRow.update(field <- value))
        }catch{
            print(error)
        }
    }
    
    public func updateTeosRow(name:String,author:String,comment:String){
        var max : Int!
        do{
            max = try database.scalar(teosTable.select(id.max))
        }catch{
            print(error)
        }
        let newRow = teosTable.filter(id == max)
        do{
            try database.run(newRow.update(self.name <- name, self.author <- author, self.comment <- comment))
            print("newname: " + name)
        }catch{
            print(error)
        }
    }
    
    public func periodicPracticeStatistics(date: Date) -> String{
        var songName: NSString!
        var duration: NSString!
        var string = ""
        do {
            let span = harjutuskordTable.filter(algusaeg >= date.startOfMonth && algusaeg <= date.endOfMonth)
            for user in try database.prepare(span.select(teoseId, pikkus.sum).group(teoseId)) {
                for troll in try database.prepare(teosTable.select(name).filter(id == user[teoseId]))
                {
                    songName = (troll[name] as NSString)
                }
                duration = Tools.timeString(minutes: (user[pikkus.sum]!)/60) as NSString
                string = string + String(format: "%-20s %s \n",songName.utf8String!,duration.utf8String!)
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
        var duration: NSString!
        var index = 0
        let format = "%-30s %s \n"
        var dates = [String]()
        var table = [[String]]()
        var completeString = ""
        let cal = NSCalendar.current
        do {
            for user in try database.prepare(harjutuskordTable.select(algusaeg,pikkus,teoseId).filter(algusaeg >= date.startOfMonth && algusaeg <= date.endOfMonth))
            {
                table.append([])
                for troll in try database.prepare(teosTable.select(name).filter(id == user[teoseId]))
                {
                    songName = (troll[name] as NSString)
                }
                duration = Tools.timeString(minutes: (user[pikkus])/60) as NSString
                if previousDate == nil {
                    table[0].append(String(format: format,songName.utf8String!,duration.utf8String!))
                }
                else {
                    if !cal.isDate(user[algusaeg], inSameDayAs: previousDate!) {
                        index = index + 1
                        dates.append("\(dateFormatter.string(from: user[algusaeg]))\n")
                    }
                    table[index].append(String(format: format,songName.utf8String!,duration.utf8String!))
                }
                previousDate = user[algusaeg]
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
            let query = harjutuskordTable.filter(id == harjutusId)
            try database.run(query.delete())
        } catch {
            print(error)
        }
    }
    
    public func newPracticeRow(teosId : Int)->Int64{
        var rowID : Int64!
        do{
            rowID = try database.run(harjutuskordTable.insert(algusaeg <- Date(), pikkus <- 0, lopuaeg <- Date(),lisatudPaevikusse <- Date(),teoseId <- teosId))
            print("new practiceRow")
        }catch{
            print(error)
        }
        return rowID
    }
    
    public func practiceTableOrder(table: Table)-> [[Int]]{
        var idTable = [Int]()
        var countTable = [Int]()
        var durationTable = [Int]()
        var totalDuration = 0
        do{
            if database == nil{print("nilll")}
            for user in try database.prepare(table.select(id).order(id.desc)){
                idTable.append(user[id])
                countTable.append(try database.scalar(harjutuskordTable.filter(teoseId == user[id]).count))
                for user in try database.prepare(harjutuskordTable.filter(teoseId == user[id])){
                    totalDuration += user[pikkus]
                }
                durationTable.append(totalDuration)
                totalDuration = 0
            }
        }catch{
            print(error)
        }
        return [idTable, countTable, durationTable]
    }
    
    public func tableOrderByDate(table: Table,teosId : Int)-> [Int]{
        var idTable = [Int]()
        do{
            for user in try database.prepare(table.select(id).filter(teoseId == teosId).order(algusaeg.desc)){
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return idTable
    }
    
    public func durationByDay(date : Date) -> [Int]{
        var duration = 0
        var count = 0
        do{
            for user in try database.prepare(harjutuskordTable.select(pikkus).filter(algusaeg >= date.startOfDay && algusaeg <= date.endOfDay)){
                duration += user[pikkus]
                count += 1
            }
        }catch{
            print(error)
        }
        return [duration,count]
    }
    
    
    
    public func totalDurations() -> [Int]{
        var dayDuration = 0
        var weekDuration = 0
        var monthDuration = 0
        do{
            for user in try database.prepare(harjutuskordTable.select(pikkus).filter(algusaeg >= Date().startOfDay))
            {
                dayDuration += user[pikkus]
            }
            for user in try database.prepare(harjutuskordTable.select(pikkus).filter(algusaeg >= Date().startOfWeek))
            {
                weekDuration += user[pikkus]
            }
            for user in try database.prepare(harjutuskordTable.select(pikkus).filter(algusaeg >= Date().startOfMonth))
            {
                monthDuration += user[pikkus]
            }
        }catch{
            print(error)
        }
        return [dayDuration, weekDuration, monthDuration]
    }
    
    public func durationForMonth(date: Date) -> Int {
        var duration = 0
        do {
            for user in try database.prepare(harjutuskordTable.select(pikkus).filter(algusaeg >= date.startOfMonth && algusaeg <= date.endOfMonth))
            {
                duration += user[pikkus]
            }
        } catch {
            print(error)
        }
        return duration
    }
 
    public func tableNewRowPosition(table: Table,teosId : Int, newHarjutusId : Int)-> Int{
        var idTable = [Int]()
        do{
            for user in try database.prepare(table.select(id).filter(teoseId == teosId).order(algusaeg.desc)){
                if user[id] == newHarjutusId
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
    
    
    public func selectHarjutuskordRow(pos: Int) -> [String] {
        var stringy = [String]()
        if database != nil{
            do{
                for user in try database.prepare(harjutuskordTable.select(algusaeg,pikkus,lopuaeg,harjutuseKirjeldus,lisatudPaevikusse).filter(id == pos)){
                    
                    stringy = ["\(String(Tools.dateToStr(date: user[algusaeg])))","\(String(user[pikkus]))","\(String(Tools.dateToStr(date: user[lopuaeg])))","\(String(user[harjutuseKirjeldus]))","\(String(Tools.dateToStr(date: user[lisatudPaevikusse])))"]
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
    
    public func returnHarjutusId(teosId: Int,pos: Int) -> Int {
        var idTable = [Int]()
        do{
            for user in try database.prepare(harjutuskordTable.select(id).filter(teoseId == teosId).order(algusaeg.desc)){
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return idTable[pos]
    }
    
    public func returnHarjutusFilePath(harjutusId: Int) -> String{
        var filepath: String!
        do{
            for user in try database.prepare(harjutuskordTable.select(helifail).filter(id == harjutusId)) {
                filepath = user[helifail]
                print("valitud heifail:")
                print(filepath)
            }
        }catch{
            print(error)
        }
        return filepath
    }
    
    
    public func editHarjutuskordTime(practiceId: Int64, startTime: Date, duration: Int, endTime: Date , filename: String = ""){
        do{
            let editRow = harjutuskordTable.filter(id == Int(practiceId))
            try database.run(editRow.update(self.algusaeg <- startTime, self.pikkus <- duration, self.lopuaeg <- endTime, self.helifail <- filename))
        }catch{
            print(error)
        }
    }
    
    public func editHarjutuskordDescription(practiceId : Int64, description : String){
        
        do{
            let editRow = harjutuskordTable.filter(id == Int(practiceId))
            try database.run(editRow.update(self.harjutuseKirjeldus <- description))
        }catch{
            print(error)
        }
    }
    public func harjutuskordDeleteWhereDurationZero(teosId:Int) -> Int{
        var deletion = 0
        do{
            let row = harjutuskordTable.filter(teoseId == teosId && pikkus == 0)
            print("row to delete)")
            deletion = try database.run(row.delete())
            print(deletion)
        }catch{
            print(error)
        }
        return deletion
    }

}

