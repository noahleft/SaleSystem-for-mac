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
    
    var path: String?
    
    init() {
        if let filePath = UserDefaults.standard.string(forKey: "database") {
            print("\(filePath)")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                path = filePath
            }
        }
        else {
            path = Bundle.main.path(forResource: "sample", ofType: "db")
        }
        print(path)
    }
    
    func loadCompanyList() -> [SQL_COMPANY] {
        var retArray: [SQL_COMPANY] = []

        do {
            if let rPath = path {
                let db = try Connection(rPath)
            
                let users = Table("company")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                                
                for user in try db.prepare(users) {
//                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_COMPANY(aId: Int(user[id]), aName: String(describing: user[name]!))
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
    
    func loadProductList() -> [SQL_PRODUCT] {
        var retArray: [SQL_PRODUCT] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("product")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                
                for user in try db.prepare(users) {
//                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_PRODUCT(aId: Int(user[id]), aName: String(describing: user[name]!))
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
    
    func loadUnitPriceList() -> [SQL_UNITPRICE] {
        var retArray: [SQL_UNITPRICE] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("unitprice")
                let id = Expression<Int64>("ID")
                let comId = Expression<Int64>("COMP_ID")
                let proId = Expression<Int64>("PROD_ID")
                let price = Expression<Double>("UNIT_PRICE")
                
                for user in try db.prepare(users) {
//                    print("id: \(user[id]), comp_id: \(user[comId]), prod_id: \(user[proId]), unit_price: \(user[price])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_UNITPRICE(aId: Int(user[id]), aComId: Int(user[comId]), aProId: Int(user[proId]), aUnitPrice: Float(user[price]))
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
    
    func loadFormList() -> [SQL_FORM] {
        var retArray: [SQL_FORM] = []
        
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("form")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                
                for user in try db.prepare(users) {
//                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_FORM(aId: Int(user[id]), aName: String(describing: user[name]!))
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
    
    func loadRecordList() -> [SQL_RECORD] {
        var retArray: [SQL_RECORD] = []
        
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
                SQL_dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                SQL_dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                for user in try db.prepare(users) {
                    
                    let Date_createdDate : Date = SQL_dateFormatter.date(from: user[createdDate])!
                    let Date_deliverDate : Date = SQL_dateFormatter.date(from: user[deliverDate])!
                    
//                    print("id: \(user[id]), comp: \(user[comp]), prod: \(user[prod]), form: \(user[form]), createdDate: \(Date_createdDate), deliverDate: \(Date_deliverDate), unit_price: \(user[unitPrice]), quantity: \(user[quantity])")
                    let com = SQL_RECORD(aId: Int(user[id]), aCompId: Int(user[comp]), aProdId: Int(user[prod]), aFormId: Int(user[form]),
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
    
    func storeCompanyList(companyList: [SQL_COMPANY]) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                let users = Table("company")
                let id = Expression<Int64>("ID")
                let name = Expression<String>("NAME")

                for item in companyList {
                    print("try to update companyName:  \(item.Id)   \(item.Name)")
                    let currnet = users.filter(id == Int64(item.Id))
                    if try db.run(currnet.update(name <- "\(item.Name)")) > 0 {
                        // UPDATE "users" SET "name" = 'alice' WHERE ("id" = 1)
                        print("\(item.Name)")
                    } else {
                        print("update fail -> try insertion")
                        if try db.run(users.insert(name <- "\(item.Name)")) > 0 {
                            // Insert "users" (name) values ('alice')
                            print("insertion \(item.Name)")
                        } else {
                            print("insertion fail")
                        }
                    }
                }
            }
        }
        catch {
            print("db store fail")
        }
    }
    
    func storeProductList(productList: [SQL_PRODUCT]) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                let users = Table("product")
                let id = Expression<Int64>("ID")
                let name = Expression<String>("NAME")
                
                for item in productList {
                    print("try to update productName:  \(item.Id)   \(item.Name)")
                    let currnet = users.filter(id == Int64(item.Id))
                    
                
                    if try db.run(currnet.update(name <- "\(item.Name)")) > 0 {
                        // UPDATE "users" SET "name" = 'alice' WHERE ("id" = 1)
                        print("\(item.Name)")
                    } else {
                        print("update fail -> try insertion")
                        if try db.run(users.insert(name <- "\(item.Name)")) > 0 {
                            // Insert "users" (name) values ('alice')
                            print("insertion \(item.Name)")
                        } else {
                            print("insertion fail")
                        }
                    }
                }
            }
        }
        catch {
            print("db store fail")
        }
    }
    
    func storeUnitPriceList(priceList: [SQL_UNITPRICE]) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                let users = Table("unitprice")
                let id = Expression<Int64>("ID")
                let comId = Expression<Int64>("COMP_ID")
                let proId = Expression<Int64>("PROD_ID")
                let price = Expression<Double>("UNIT_PRICE")
                
                for item in priceList {
                    print("try to update price:  \(item.Id)  \(item.ComId) \(item.ProId)")
                    let currnet = users.filter(id == Int64(item.Id))
                    let up = Double(item.UnitPrice)
                    
                    if try db.run(currnet.update(price <- up)) > 0 {
                        // UPDATE "users" SET "name" = 'alice' WHERE ("id" = 1)
                        print("\(item.UnitPrice)")
                    } else {
                        print("update fail -> try insertion")
                        if try db.run(users.insert(comId <- Int64(item.ComId), proId <- Int64(item.ProId), price <- up)) > 0 {
                            // Insert "users" (name) values ('alice')
                            print("insertion \(item.UnitPrice)")
                        } else {
                            print("insertion fail")
                        }
                    }
                }
            }
        }
        catch {
            print("db store fail")
        }
    }
    
    func storeFormList(formList : [SQL_FORM]) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                let users = Table("form")
                let id = Expression<Int64>("ID")
                let name = Expression<String>("NAME")
                
                for item in formList {
                    print("try to update formname:  \(item.Id)   \(item.Name)")
                    let currnet = users.filter(id == Int64(item.Id))
                    if try db.run(currnet.update(name <- "\(item.Name)")) > 0 {
                        // UPDATE "users" SET "name" = 'alice' WHERE ("id" = 1)
                        print("\(item.Name)")
                    } else {
                        print("update fail -> try insertion")
                        if try db.run(users.insert(name <- "\(item.Name)")) > 0 {
                            // Insert "users" (name) values ('alice')
                            print("insertion \(item.Name)")
                        } else {
                            print("insertion fail")
                        }
                    }
                }
            }
        }
        catch {
            print("db store fail")
        }
    }
}


