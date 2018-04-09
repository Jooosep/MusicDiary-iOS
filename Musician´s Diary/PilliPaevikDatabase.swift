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
    
    
    var database : Connection!;
    var dateFormatter = DateFormatter()

    private func dateToStr(date: Date) -> String{
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    public func selectField(pos: Int) -> [String] {
        var stringy = [String]()
        if database != nil{
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
    public func rowCountForId(targetId : Int,table: Table) -> Int{
        var rowCount : Int!
        do{
            rowCount = try database.scalar(table.count.filter(teoseId == targetId))
        }catch{
            print(error)
        }
        return rowCount
    }
    
    public func newTeosRow(){
        do{
            try database.run(teosTable.insert())
            print("newrow")
        }catch{
            print(error)
        }
    }
    
    public func newHarjutuskordRow(teosId : Int)->Int64{
        var rowID : Int64!
        do{
            rowID = try database.run(harjutuskordTable.insert(lisatudPaevikusse <- Date(),teoseId <- teosId))
            print("new practiceRow")
        }catch{
            print(error)
        }
        return rowID
    }
    
    public func tableOrder(table: Table)-> [Int]{
        var idTable = [Int]()
        do{
            for user in try database.prepare(table.select(id)){
                idTable.append(user[id])
            }
        }catch{
            print(error)
        }
        return idTable
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
    
    
    public func selectHarjutuskordRow(pos: Int) -> [String] {
        var stringy = [String]()
        if database != nil{
            do{
                for user in try database.prepare(harjutuskordTable.select(algusaeg,pikkus,lopuaeg,harjutuseKirjeldus,lisatudPaevikusse).filter(id == pos)){
                    
                    stringy = ["\(String(dateToStr(date: user[algusaeg])))","\(String(user[pikkus]))","\(String(dateToStr(date: user[lopuaeg])))","\(String(user[harjutuseKirjeldus]))","\(String(dateToStr(date: user[lisatudPaevikusse])))"]
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
    public func editTeosRow(targetId : Int, field : Expression<String>,value : String){
        let editRow = teosTable.filter(id == targetId)
        do{
            try database.run(editRow.update(field <- value))
        }catch{
            print(error)
        }
    }
    
    public func editHarjutuskordTime(practiceId : Int64, startTime : Date, duration : Int, endTime : Date ){
        do{
            let editRow = harjutuskordTable.filter(id == Int(practiceId))
            try database.run(editRow.update(self.algusaeg <- startTime, self.pikkus <- duration, self.lopuaeg <- endTime))
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
    public func harjutuskordDeleteWhereDurationZero(teosId:Int){
        do{
            let row = harjutuskordTable.filter(teoseId == teosId && pikkus == 0)
            try database.run(row.delete())
        }catch{
            print(error)
        }
    }
    
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

    public func clear_table(){
        do{
            try database.run(teosTable.delete())
            print("teosTable cleared")
        }catch{
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
        }
        do{
            try self.database.run(createHarjutuskordTable)
            print("Created harjutuskord table")
        }catch{
            print(error);
        }
    }
}

