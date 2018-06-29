//
//  SQLVariableObject.swift
//  SaleSystem
//
//  Created by 林世豐 on 16/10/2016.
//
//

import Foundation
import Cocoa

// variable object
// this file is created for variable definition
// the definition is also used for storage (SQLite)

class SQL_COMPANY {
    var Id : Int
    var Name : String
    var PrintTax : Bool
    
    init(aId: Int,aName: String, aPrintTax: Bool) {
        Id = aId
        Name = aName
        PrintTax = aPrintTax
    }
}

class SQL_PRODUCT {
    var Id : Int
    var Name : String
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
    
}

class SQL_UNITPRICE {
    var Id : Int
    var ComId : Int
    var ProId : Int
    var UnitPrice : Float
    
    init(aId: Int,aComId: Int,aProId: Int,aUnitPrice: Float) {
        Id = aId
        ComId = aComId
        ProId = aProId
        UnitPrice = aUnitPrice
    }
}

class SQL_FORM {
    var Id : Int
    var Name : String
    var Quantity : Int
    var Sum : Int
    
    init(aId: Int,aName: String, aQuantity: Int, aSum: Int) {
        Id = aId
        Name = aName
        Quantity = aQuantity
        Sum = aSum
    }
}

class SQL_RECORD {
    var Id : Int
    var CompId : Int
    var ProdId : Int
    var FormId : Int
    var CreatedDate : Date
    var DeliverDate : Date
    var UnitPrice : Double
    var Quantity : Int
    var Note: String
    
    init(aId: Int,aCompId: Int,aProdId: Int,aFormId: Int,aCreatedDate: Date,aDeliverDate: Date,aUnitPrice: Double,aQuantity: Int, aNote: String) {
        Id = aId
        CompId = aCompId
        ProdId = aProdId
        FormId = aFormId
        CreatedDate = aCreatedDate
        DeliverDate = aDeliverDate
        UnitPrice = aUnitPrice
        Quantity = aQuantity
        Note = aNote
    }
    
    
    
}
