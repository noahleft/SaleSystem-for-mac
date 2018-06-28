//
//  updateManager.swift
//  SaleSystem
//
//  Created by 林世豐 on 17/10/2016.
//
//

import Foundation

class UpdateManager {
    
    var updateQueue : [Any] = []
    var noUnSaveChange: Bool {
        return updateQueue.count == 0
    }
    
    
    func addUpdate(update : Any) {
        updateQueue.append(update)
        switch update {
        case is SQL_COMPANY:
            let com : SQL_COMPANY = update as! SQL_COMPANY
            print("COM_ID:\(com.Id)  NAME:\(com.Name)")
        case is SQL_PRODUCT:
            let com : SQL_PRODUCT = update as! SQL_PRODUCT
            print("PRO_ID:\(com.Id)  NAME:\(com.Name)")
        case is SQL_UNITPRICE:
            let com : SQL_UNITPRICE = update as! SQL_UNITPRICE
            print("COM_ID:\(com.ComId)  PRO_ID:\(com.ProId)  PRICE:\(com.UnitPrice)")
        case is SQL_FORM:
            let com : SQL_FORM = update as! SQL_FORM
            print("FORM_ID:\(com.Id) NAME:\(com.Name)")
        case is SQL_RECORD:
            let com : SQL_RECORD = update as! SQL_RECORD
            print("RECORD_ID:\(com.Id) DeliverDate:\(com.DeliverDate) UnitPrice:\(com.UnitPrice) Quantity:\(com.Quantity) Note:\(com.Note)")
        default:
            print("something else")
        }
    }
    
    func dumpUpdate() {
        for item in updateQueue {
            switch item {
            case is SQL_COMPANY:
                let com : SQL_COMPANY = item as! SQL_COMPANY
                print("COM_ID:\(com.Id)  NAME:\(com.Name)")
            case is SQL_PRODUCT:
                let com : SQL_PRODUCT = item as! SQL_PRODUCT
                print("COM_ID:\(com.Id)  NAME:\(com.Name)")
            case is SQL_UNITPRICE:
                let com : SQL_UNITPRICE = item as! SQL_UNITPRICE
                print("COM_ID:\(com.ComId)  PRO_ID:\(com.ProId)  PRICE:\(com.UnitPrice)")
            case is SQL_FORM:
                let com : SQL_FORM = item as! SQL_FORM
                print("FORM_ID:\(com.Id) NAME:\(com.Name)")
            case is SQL_RECORD:
                let com : SQL_RECORD = item as! SQL_RECORD
                let tmpStr : String = dateFormatterForDisplay(date : com.DeliverDate)
                print("RECORD_ID:\(com.Id) DeliverDate:\(tmpStr) UnitPrice:\(com.UnitPrice) Quantity:\(com.Quantity) Note:\(com.Note)")
            default:
                print("something else")
            }
        }
    }
    
    func cleanup() {
        updateQueue = []
    }
}

