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
    var companyList : [COMPANY] = []
    var productList : [PRODUCT] = []
    var priceList   : [UNITPRICE] = []
    var formList    : [FORM] = []
    var recordList  : [RECORD] = []
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
        return companyList
    }
    
    func getCompanyName(id : Int) -> String {
        if let retString = companyDict[id] {
            return retString
        }
        return ""
    }
    
    func getProductList() -> [PRODUCT] {
        return productList
    }
    
    func getProductName(id : Int) -> String {
        if let retString = productDict[id] {
            return retString
        }
        return ""
    }
    
    func getUnitPriceList() -> [UNITPRICE] {
        return priceList
    }
    
    func getFormList() -> [FORM] {
        return formList
    }
    
    func getForm(formId : Int) -> FORM? {
        for item in formList {
            if item.Id == formId {
                return item
            }
        }
        return nil
    }
    
    func getRecordList(formId : Int) -> [RECORD] {
        return recordList.filter{ (p) -> Bool in
            p.FormId == formId
        }
    }
    
    func getRecordList(formId : Int, compId : Int) -> [RECORD] {
        return recordList.filter{ (p) -> Bool in
            p.FormId == formId && p.CompId == compId
        }
    }
    
}

var dataManager: DATAMANAGER = DATAMANAGER()
