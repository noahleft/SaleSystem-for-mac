//
//  VariableObject.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

// variable object
// this file is created for variable definition
// the definition is used for dataManager
// the variable can init by SQL_VariableObject

class COMPANY : NSObject {
    var Id : Int
    var Name : String
    dynamic var DisplayName : String
    var valueChanged : Bool {
        return Name != DisplayName
    }
    dynamic var TextColor : NSColor = NSColor.black
    
    init(sqlCom: SQL_COMPANY) {
        Id = sqlCom.Id
        Name = sqlCom.Name
        DisplayName = sqlCom.Name
        super.init()
        
        registerObserver()
    }
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
        DisplayName = aName
        super.init()
        
        registerObserver()
    }
    
    func registerObserver() {
        addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if valueChanged {
            TextColor = NSColor.red
        }
        else {
            TextColor = NSColor.black
        }
        dataManager.addUpdate(update: SQL_COMPANY(aId: Id, aName: DisplayName))
        print("add update  Name:\(Name)   DisplayName:\(DisplayName)")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "DisplayName")
    }
}

class PRODUCT : NSObject {
    var Id : Int
    var Name : String
    
    init(sqlPro: SQL_PRODUCT) {
        Id = sqlPro.Id
        Name = sqlPro.Name
    }
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
    
}

class UNITPRICE : NSObject {
    var Id : Int
    var ComId : Int
    var ProId : Int
    var UnitPrice : Float
    
    init(sqlUnitPrice: SQL_UNITPRICE) {
        Id = sqlUnitPrice.Id
        ComId = sqlUnitPrice.ComId
        ProId = sqlUnitPrice.ProId
        UnitPrice = sqlUnitPrice.UnitPrice
    }
    
    init(aId: Int,aComId: Int,aProId: Int,aUnitPrice: Float) {
        Id = aId
        ComId = aComId
        ProId = aProId
        UnitPrice = aUnitPrice
    }
}

class FORM : NSObject {
    var Id : Int
    var Name : String
    
    init(sqlForm: SQL_FORM) {
        Id = sqlForm.Id
        Name = sqlForm.Name
    }
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
}

class RECORD : NSObject {
    var Id : Int
    var CompId : Int
    var ProdId : Int
    var FormId : Int
    var CreatedDate : Date
    var DeliverDate : Date
    var UnitPrice : Double
    var Quantity : Int
    
    init(sqlRecord: SQL_RECORD) {
        Id = sqlRecord.Id
        CompId = sqlRecord.CompId
        ProdId = sqlRecord.ProdId
        FormId = sqlRecord.FormId
        CreatedDate = sqlRecord.CreatedDate
        DeliverDate = sqlRecord.DeliverDate
        UnitPrice = sqlRecord.UnitPrice
        Quantity = sqlRecord.Quantity
    }
    
    init(aId: Int,aCompId: Int,aProdId: Int,aFormId: Int,aCreatedDate: Date,aDeliverDate: Date,aUnitPrice: Double,aQuantity: Int) {
        Id = aId
        CompId = aCompId
        ProdId = aProdId
        FormId = aFormId
        CreatedDate = aCreatedDate
        DeliverDate = aDeliverDate
        UnitPrice = aUnitPrice
        Quantity = aQuantity
    }
    
    
    
}




