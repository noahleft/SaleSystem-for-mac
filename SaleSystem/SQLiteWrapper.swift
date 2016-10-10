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
    
    func loadCompanyList() -> [COMPANY] {
        var retArray: [COMPANY] = []

        do {
            if let rPath = path {
                let db = try Connection(rPath)
            
                let users = Table("company")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                                
                for user in try db.prepare(users) {
                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = COMPANY(aId: Int(user[id]), aName: String(describing: user[name]!))
                    retArray.append(com)
                }
                // SELECT * FROM "users"
            }
        }
        catch {
            print("db load fail")
        }
        return retArray
    }
    
    func loadProductList() -> [PRODUCT] {
        var retArray: [PRODUCT] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("product")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                
                for user in try db.prepare(users) {
                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = PRODUCT(aId: Int(user[id]), aName: String(describing: user[name]!))
                    retArray.append(com)
                }
                // SELECT * FROM "users"
            }
        }
        catch {
            print("db load fail")
        }
        return retArray
    }
    
    func loadUnitPriceList() -> [UNITPRICE] {
        var retArray: [UNITPRICE] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("unitprice")
                let id = Expression<Int64>("ID")
                let comId = Expression<Int64>("COMP_ID")
                let proId = Expression<Int64>("PROD_ID")
                let price = Expression<Double>("UNIT_PRICE")
                
                for user in try db.prepare(users) {
                    print("id: \(user[id]), comp_id: \(user[comId]), prod_id: \(user[proId]), unit_price: \(user[price])")
                    // id: 1, name: Optional("Alice")
                    let com = UNITPRICE(aId: Int(user[id]), aComId: Int(user[comId]), aProId: Int(user[proId]), aUnitPrice: Float(user[price]))
                    retArray.append(com)
                }
                // SELECT * FROM "users"
            }
        }
        catch {
            print("db load fail")
        }
        return retArray
    }
    
    func loadFormList() -> [FORM] {
        var retArray: [FORM] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("form")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                
                for user in try db.prepare(users) {
                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = FORM(aId: Int(user[id]), aName: String(describing: user[name]!))
                    retArray.append(com)
                }
                // SELECT * FROM "users"
            }
        }
        catch {
            print("db load fail")
        }
        return retArray
    }
    
    func loadRecordList() -> [RECORD] {
        var retArray: [RECORD] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("record")
                let id = Expression<Int64>("ID")
                let comp = Expression<Int64>("COMP_ID")
                let prod = Expression<Int64>("PROD_ID")
                let form = Expression<Int64>("FORM_ID")
                let createdDate = Expression<String>("CREATED_DATE")
                let deliverDate = Expression<String>("DELIVER_DATE")
                let unitPrice = Expression<Double>("UNIT_PRICE")
                let quantity = Expression<Int64>("QUANTITY")
                
                let SQL_dateFormatter : DateFormatter = DateFormatter()
                SQL_dateFormatter.dateFormat = "YYYY-MM-dd"
                
                for user in try db.prepare(users) {
                    
                    let Date_createdDate : Date = SQL_dateFormatter.date(from: user[createdDate])!
                    let Date_deliverDate : Date = SQL_dateFormatter.date(from: user[deliverDate])!
                    
                    print("id: \(user[id]), comp: \(user[comp]), prod: \(user[prod]), form: \(user[form]), createdDate: \(Date_createdDate), deliverDate: \(Date_deliverDate), unit_price: \(user[unitPrice]), quantity: \(user[quantity])")
                    let com = RECORD(aId: Int(user[id]), aCompId: Int(user[comp]), aProdId: Int(user[prod]), aFormId: Int(user[form]),
                                     aCreatedDate: Date_createdDate, aDeliverDate: Date_deliverDate, aUnitPrice: Double(user[unitPrice]), aQuantity: Int(user[quantity]))
                    retArray.append(com)
                }
                // SELECT * FROM "users"
            }
        }
        catch {
            print("db load fail")
        }
        return retArray
    }
    
}


