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
    
    var database : Connection!;
    
    public func selectField(pos: Int) -> [String] {
        var stringy = [String]()
        let posy = pos + 1
         do{
            for user in try database.prepare(teosTable.select(name,author,comment).filter(id == posy)){
                
                stringy = ["\(String(user[name]))","\(String(user[author]))","\(String(user[comment]))"]
            }
         }
         catch{
            print(error)
        }
        return stringy
    }
    public func listTable(){
        do{
            let teosTable = try self.database.prepare(self.teosTable)
            for user in teosTable {
                print( "id: \(user[self.id]), name: \(user[self.name]), author: \(user[self.author])")
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
    
    public func newTeosRow(){
        do{
            try database.run(teosTable.insert())
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
        }catch{
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
    
    public func create_db(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3");
            let db = try Connection(fileUrl.path);
            self.database = db;
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
            table.column(self.id,primaryKey: true)
            table.column(self.algusaeg)
            table.column(self.pikkus)
            table.column(self.lopuaeg)
        }
        do{
            try self.database.run(createHarjutuskordTable)
            print("Created harjutuskord table")
        }catch{
            print(error);
        }
    }
}

