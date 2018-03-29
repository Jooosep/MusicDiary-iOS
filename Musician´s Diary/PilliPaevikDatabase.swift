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
    //Harjutuskord
    let harjutuskordTable = Table("harjutuskorrad");
    let algusaeg = Expression<Date>("algusaeg");
    let pikkus = Expression<Int>("pikkusSekundites");
    let lopuaeg = Expression<Date>("lopuaeg");
    
    var database : Connection!;
    
    public func create_db(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3");
            let database = try Connection(fileUrl.path);
            self.database = database;
        }
        catch{
            print(error)
        }
    }
    
    public func create_tables(){
        
        let createTeosTable = self.teosTable.create{(table) in
            table.column(self.id,primaryKey: true)
            table.column(self.name)
            table.column(self.author)
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

