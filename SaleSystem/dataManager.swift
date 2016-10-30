//
//  dataManager.swift
//  SaleSystem
//
//  Created by 林世豐 on 03/10/2016.
//
//

import Foundation

class DATAMANAGER : NSObject {
    
    let dbManager: SQLiteWrapper = SQLiteWrapper()
    let updateManager: UpdateManager = UpdateManager()
    var companyList : [SQL_COMPANY] = []
    var productList : [SQL_PRODUCT] = []
    var priceList   : [SQL_UNITPRICE] = []
    var formList    : [SQL_FORM] = []
    var recordList  : [SQL_RECORD] = []
    var companyDict : [Int:Int] = [:]
    var productDict : [Int:Int] = [:]
    var saveAction  : Int = 0
    
    override init() {
        super.init()
        
        triggerInitialEvent()
    }
    
    func cleanup() {
        companyList = []
        productList = []
        priceList = []
        formList = []
        recordList = []
        companyDict = [:]
        productDict = [:]
        updateManager.cleanup()
    }
    
    func triggerInitialEvent()  {
        cleanup()
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        priceList   = dbManager.loadUnitPriceList()
        formList    = dbManager.loadFormList()
        recordList  = dbManager.loadRecordList()
        
        for (index,item) in companyList.enumerated() {
            companyDict[item.Id] = index
        }
        for (index,item) in productList.enumerated() {
            productDict[item.Id] = index
        }
    }
    
    
    func getCompanyList() -> [COMPANY] {
        return companyList.map{ (p) -> COMPANY in
            return COMPANY(sqlCom: p)
        }
    }
    
    func getCompanyIdx(id : Int) -> Int {
        if let idx = companyDict[id] {
            return idx
        }
        return -1
    }
    
    func getCompanyNameFromListOrder(index : Int) -> String {
        return companyList[index].Name
    }
    
    func getProductList() -> [PRODUCT] {
        return productList.map{ (p) -> PRODUCT in
            return PRODUCT(sqlPro: p)
        }
    }
    
    func getProductNameFromListOrder(index : Int) -> String {
        return productList[index].Name
    }
    
    func getProductIdx(id : Int) -> Int {
        if let idx = productDict[id] {
            return idx
        }
        return -1
    }
    
    func getProductName(id : Int) -> String {
        if let idx = productDict[id] {
            return productList[idx].Name
        }
        return ""
    }
    
    func getUnitPriceList() -> [UNITPRICE] {
        return priceList.map{ (p) -> UNITPRICE in
            return UNITPRICE(sqlUnitPrice: p)
        }
    }
    
    func getFormList() -> [FORM] {
        return formList.map{ (p) -> FORM in
            return FORM(sqlForm: p)
        }
    }
    
    func getForm(formId : Int) -> FORM? {
        for item in formList {
            if item.Id == formId {
                return FORM(sqlForm: item)
            }
        }
        return nil
    }
    
    func getRecordList(formId : Int) -> [RECORD] {
        let reducedRecordList = recordList.filter{ (p) -> Bool in
            p.FormId == formId
        }
        return reducedRecordList.map{ (p) -> RECORD in
            return RECORD(sqlRecord: p)
        }
    }
    
    func getRecordList(formId : Int, compId : Int) -> [RECORD] {
        let reducedRecordList = recordList.filter{ (p) -> Bool in
            p.FormId == formId && p.CompId == compId
        }
        return reducedRecordList.map{ (p) -> RECORD in
            return RECORD(sqlRecord: p)
        }
    }
    
    func getRecordListIdForNewData() -> Int {
        if let lastObj = recordList.last {
            return lastObj.Id+1
        }
        return 1
    }
    
    func store() {
        print("store company list")
        let reducedCompanyList = updateManager.updateQueue.filter{ (p) -> Bool in
            p is SQL_COMPANY
            }.map{ (p) -> SQL_COMPANY in
                return p as! SQL_COMPANY
        }
        dbManager.storeCompanyList(companyList: reducedCompanyList)
        
        print("store product list")
        let reducedProductList = updateManager.updateQueue.filter{ (p) -> Bool in
            p is SQL_PRODUCT
            }.map{ (p) -> SQL_PRODUCT in
                return p as! SQL_PRODUCT
        }
        dbManager.storeProductList(productList: reducedProductList)
        
        print("store unit price list")
        let reducedUnitPriceList = updateManager.updateQueue.filter{ (p) -> Bool in
            p is SQL_UNITPRICE
            }.map{ (p) -> SQL_UNITPRICE in
                return p as! SQL_UNITPRICE
        }
        dbManager.storeUnitPriceList(priceList: reducedUnitPriceList)
        let reducedFormList = updateManager.updateQueue.filter{ (p) -> Bool in
            p is SQL_FORM
            }.map{ (p) -> SQL_FORM in
                return p as! SQL_FORM
        }
        dbManager.storeFormList(formList: reducedFormList)
        
        cleanup()
        triggerInitialEvent()
        print("save Action inc. \(saveAction)")
        willChangeValue(forKey: "saveAction")
        saveAction += 1
        didChangeValue(forKey: "saveAction")
    }

    func addUpdate(update : Any) {
        updateManager.addUpdate(update: update)
    }
    
    
}

var dataManager: DATAMANAGER = DATAMANAGER()
