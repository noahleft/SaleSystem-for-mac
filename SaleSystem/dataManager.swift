//
//  dataManager.swift
//  SaleSystem
//
//  Created by 林世豐 on 03/10/2016.
//
//

import Foundation

class DATAMANAGER {
    
    let dbManager: SQLiteWrapper = SQLiteWrapper()
    var companyList : [SQL_COMPANY] = []
    var productList : [SQL_PRODUCT] = []
    var priceList   : [SQL_UNITPRICE] = []
    var formList    : [SQL_FORM] = []
    var recordList  : [SQL_RECORD] = []
    var companyDict : [Int:String] = [:]
    var productDict : [Int:String] = [:]
    
    init() {
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
    }
    
    func triggerInitialEvent()  {
        cleanup()
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        priceList   = dbManager.loadUnitPriceList()
        formList    = dbManager.loadFormList()
        recordList  = dbManager.loadRecordList()
        
        for item in companyList {
            companyDict[item.Id] = item.Name
        }
        for item in productList {
            productDict[item.Id] = item.Name
        }
    }
    
    
    func getCompanyList() -> [COMPANY] {
        return companyList.map{ (p) -> COMPANY in
            return COMPANY(sqlCom: p)
        }
    }
    
    func getCompanyName(id : Int) -> String {
        if let retString = companyDict[id] {
            return retString
        }
        return ""
    }
    
    func setCompanyName(id : Int, name : String) -> Bool {
        for item in companyList {
            if item.Id == id {
                item.Name = name
                companyDict[id] = name
                print("update id:\(id) with \(name)")
                return true
            }
        }
        return false
    }
    
    func getProductList() -> [PRODUCT] {
        return productList.map{ (p) -> PRODUCT in
            return PRODUCT(sqlPro: p)
        }
    }
    
    func getProductName(id : Int) -> String {
        if let retString = productDict[id] {
            return retString
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
    
    
    
}

var dataManager: DATAMANAGER = DATAMANAGER()
