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
            default:
                print("something else")
            }
        }
    }
    
    func cleanup() {
        updateQueue = []
    }
}

