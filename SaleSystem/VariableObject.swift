//
//  VariableObject.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation

// variable object
// this file is created for variable definition
// the definition is also used for storage (SQLite)

class COMPANY : NSObject {
    var Id : Int
    dynamic var Name : String
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
    
}

class PRODUCT : NSObject {
    var Id : Int
    var Name : String
    
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




