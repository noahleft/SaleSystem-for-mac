//
//  SQLiteWrapper.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import SQLite

extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}

class SQLiteWrapper {
    
    var path: String?
    var sampleDB : Bool = true
    
    init() {
        if let filePath = UserDefaults.standard.string(forKey: "database") {
            print("\(filePath)")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                path = filePath
                sampleDB = false
            }
            else {
                path = Bundle.main.path(forResource: "sample", ofType: "db")
            }
        }
        else { // no user defaults -> fisrt run
            
            let filePath = "auto.db"
            
            if let bundlePath = Bundle.main.path(forResource: "new", ofType: "db") {
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentPath = documentDirectory[0].stringByAppendingPathComponent(path: filePath)
                do {
                    print("source: \(bundlePath)")
                    print("destin: \(documentPath)")
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: documentPath)
                }
                catch {
                    print("copy item fails")
                }
                UserDefaults.standard.set(documentPath, forKey: "database")
                path = documentPath
            }
            else {
                print("check bundle setting")
            }
        }
        print(path)
        
        databaseMigration()
    }
    
    func databaseMigration() {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                print("db version:\(db.userVersion)")
                
                //migration from 0 to 1  (v1.4)
                //add table company info
                //add table form note
                if db.userVersion == 0 {
                    let users = Table("company")
                    let suffix = Expression<Bool>("PRINTTAX")
                    try db.run(users.addColumn(suffix, defaultValue: false))
                    
                    let users2 = Table("record")
                    let suffix2 = Expression<String>("NOTE")
                    try db.run(users2.addColumn(suffix2, defaultValue: ""))
                    
                    db.userVersion = 1
                }
                //migration from 1 to 2  (v1.5)
                //add quantity and sum for each form
                if db.userVersion == 1 {
                    let users = Table("form")
                    let suffix = Expression<Int64>("QUANTITY")
                    let suffix2 = Expression<Int64>("SUM")
                    try db.run(users.addColumn(suffix, defaultValue: -1))
                    try db.run(users.addColumn(suffix2, defaultValue: 0))
                    
                    db.userVersion = 2
                }
            }
        }
        catch {
            print("db test fail")
        }
    }
    
    func loadCompanyList() -> [SQL_COMPANY] {
        var retArray: [SQL_COMPANY] = []

        do {
            if let rPath = path {
                let db = try Connection(rPath)
            
                let users = Table("company")
                let id = Expression<Int64>("ID")
                let name = Expression<String?>("NAME")
                let printTax = Expression<Bool>("PRINTTAX")
                                
                for user in try db.prepare(users) {
//                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_COMPANY(aId: Int(user[id]), aName: String(describing: user[name]!), aPrintTax: Bool(user[printTax]))
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
                let hide = Expression<Bool>("HIDE")
                let quantity = Expression<Int64>("QUANTITY")
                let sum = Expression<Int64>("SUM")
                
                for user in try db.prepare(users.filter(!hide)) {
//                    print("id: \(user[id]), name: \(user[name])")
                    // id: 1, name: Optional("Alice")
                    let com = SQL_FORM(aId: Int(user[id]),
                                       aName: String(describing: user[name]!),
                                       aQuantity: Int(user[quantity]),
                                       aSum: Int(user[sum]))
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
                let note = Expression<String>("NOTE")
                
                let SQL_dateFormatter : DateFormatter = DateFormatter()
                SQL_dateFormatter.dateFormat = "YYYY-MM-dd"
                SQL_dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                SQL_dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                for user in try db.prepare(users) {
                    
                    let Date_createdDate : Date = SQL_dateFormatter.date(from: user[createdDate])!
                    let Date_deliverDate : Date = SQL_dateFormatter.date(from: user[deliverDate])!
                    
//                    print("id: \(user[id]), comp: \(user[comp]), prod: \(user[prod]), form: \(user[form]), createdDate: \(Date_createdDate), deliverDate: \(Date_deliverDate), unit_price: \(user[unitPrice]), quantity: \(user[quantity])")
                    let com = SQL_RECORD(aId: Int(user[id]),
                                         aCompId: Int(user[comp]),
                                         aProdId: Int(user[prod]),
                                         aFormId: Int(user[form]),
                                         aCreatedDate: Date_createdDate,
                                         aDeliverDate: Date_deliverDate,
                                         aUnitPrice: Double(user[unitPrice]),
                                         aQuantity: Int(user[quantity]),
                                         aNote: String(user[note]))
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
                let printtax = Expression<Bool>("PRINTTAX")

                for item in companyList {
                    print("try to update companyName:  \(item.Id)   \(item.Name)")
                    let currnet = users.filter(id == Int64(item.Id))
                    if try db.run(currnet.update(name <- "\(item.Name)", printtax <- item.PrintTax)) > 0 {
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
    
    func storeUnitPrice(item: SQL_UNITPRICE) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                let users = Table("unitprice")
                let comId = Expression<Int64>("COMP_ID")
                let proId = Expression<Int64>("PROD_ID")
                let price = Expression<Double>("UNIT_PRICE")
                
                print("try to update price: \(item.ComId) \(item.ProId)")
                let currnet = users.filter(comId == Int64(item.ComId) && proId == Int64(item.ProId))
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
    
    func storeRecordList(recordList : [SQL_RECORD]) {
        var dirtyFormID : [Int64] = []
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
                let note = Expression<String>("NOTE")
                
                let SQL_dateFormatter : DateFormatter = DateFormatter()
                SQL_dateFormatter.dateFormat = "YYYY-MM-dd"
                SQL_dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                SQL_dateFormatter.timeZone = NSTimeZone.system
                
                for item in recordList {
                    print("try to update record:  \(item.Id)  \(item.CompId) \(item.ProdId)")
                    let currnet = users.filter(id == Int64(item.Id))
                    let ci = Int64(item.CompId)
                    let pi = Int64(item.ProdId)
                    let fi = Int64(item.FormId)
                    let cd = SQL_dateFormatter.string(from: item.CreatedDate)
                    let dd = SQL_dateFormatter.string(from: item.DeliverDate)
                    let up = Double(item.UnitPrice)
                    let qu = Int64(item.Quantity)
                    let no = item.Note
                    
                    print("\(cd),\(dd)")
                    
                    if try db.run(currnet.update(comp <- ci ,prod <- pi , form <- fi, createdDate <- cd , deliverDate <- dd ,unitPrice <- up , quantity <- qu, note <- no)) > 0 {
                        // UPDATE "users" SET "name" = 'alice' WHERE ("id" = 1)
                        print("\(item.UnitPrice)")
                    } else {
                        print("update fail -> try insertion")
                        if try db.run(users.insert(comp <- ci ,prod <- pi , form <- fi, createdDate <- cd , deliverDate <- dd ,unitPrice <- up , quantity <- qu)) > 0 {
                            // Insert "users" (name) values ('alice')
                            print("insertion \(item.Id)")
                        } else {
                            print("insertion fail")
                        }
                    }
                    
                    if dirtyFormID.contains(Int64(item.FormId)) == false {
                        dirtyFormID.append(Int64(item.FormId))
                    }
                }
            }
        }
        catch {
            print("db store fail")
        }
        
        for id in dirtyFormID {
            self.calculateFormData(formID: id)
        }
    }
    
    func calculateFormData(formID : Int64) {
        do {
            if let rPath = path {
                let db = try Connection(rPath)
                
                let users = Table("record")
                let form = Expression<Int64>("FORM_ID")
                let unitPrice = Expression<Double>("UNIT_PRICE")
                let quantity = Expression<Int64>("QUANTITY")
                
                var totalQuantity : Int64 = 0
                var totalSum : Double = 0.0
                
                for user in try db.prepare(users.filter(form == formID)) {
                    totalQuantity += user[quantity]
                    totalSum += Double(user[quantity])*user[unitPrice]
                }
                // SELECT * FROM "users"
                
                let users2 = Table("form")
                let id2 = Expression<Int64>("ID")
                let quantity2 = Expression<Int64>("QUANTITY")
                let sum2 = Expression<Int64>("SUM")
                
                let tq = Int64(totalQuantity)
                let ts = Int64(totalSum)
                
                print("try to update form data:  \(formID)   \(totalQuantity) \(totalSum)")
                let currnet = users2.filter(id2 == formID)
                try db.run(currnet.update(quantity2 <- tq, sum2 <- ts))
            }
        }
        catch {
            print("db store fail")
        }
    }
    
}


