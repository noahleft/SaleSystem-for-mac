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
    
    init() {
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        priceList   = dbManager.loadUnitPriceList()
        formList    = dbManager.loadFormList()
        
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
    
}

var dataManager: DATAMANAGER = DATAMANAGER()
