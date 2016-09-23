//
//  SQLiteWrapper.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import SQLite

class SQLiteWrapper {
    
    let path: String?
    
    init() {
        path = Bundle.main.path(forResource: "sample", ofType: "db")
        print(path)
        
    }
    
    func loadCompanyList() {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
            
                let users = Table("company")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                
                for user in try db.prepare(users) {
                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                }
                // SELECT * FROM "users"
            }
            
            
        }
        catch {
            print("db load fail")
        }
    }
    
    
    
    
}

let dbManager: SQLiteWrapper = SQLiteWrapper()
