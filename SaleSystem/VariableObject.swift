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

class COMPANY {
    var Id : Int
    var Name : String
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
    
}

class PRODUCT {
    var Id : Int
    var Name : String
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
    
}

class UNITPRICE {
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

class FORM {
    var Id : Int
    var Name : String
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
    }
}
