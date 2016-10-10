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
    let companyList : [COMPANY]
    let productList : [PRODUCT]
    let priceList   : [UNITPRICE]
    let formList    : [FORM]
    let recordList  : [RECORD]
    
    init() {
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        priceList   = dbManager.loadUnitPriceList()
        formList    = dbManager.loadFormList()
        recordList  = dbManager.loadRecordList()
    }
    
    func getCompanyList() -> [COMPANY] {
        return companyList
    }
    
    func getProductList() -> [PRODUCT] {
        return productList
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
    
}

var dataManager: DATAMANAGER = DATAMANAGER()
