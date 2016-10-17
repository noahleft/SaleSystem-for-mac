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
    }
    
    func dumpUpdate() {
        for item in updateQueue {
            switch item {
            case is SQL_COMPANY:
                let com : SQL_COMPANY = item as! SQL_COMPANY
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

