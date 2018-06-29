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
    
    var ValueChanged : Bool {
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
        if ValueChanged {
            TextColor = NSColor.red
        }
        else {
            TextColor = NSColor.black
        }
        
        if DisplayName != "" {
            dataManager.addUpdate(update: SQL_COMPANY(aId: Id, aName: DisplayName, aPrintTax: false))
            print("add update  Name:\(Name)   DisplayName:\(DisplayName)")
        }
        else {
            DisplayName = Name
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "DisplayName")
    }
    
}

class PRODUCT : NSObject {
    var Id : Int
    var Name : String
    dynamic var DisplayName : String
    var UnitPrice   : UNITPRICE?
    dynamic var DisplayUnitPrice : String = ""
    var DisplayIndex : Int = 0
    
    var ValueChanged : Bool {
        return Name != DisplayName
    }
    dynamic var TextColor : NSColor = NSColor.black
    var PriceChanged : Bool {
        if (UnitPrice != nil) {
            return DisplayUnitPrice != "\(UnitPrice!.UnitPrice)"
        }
        else {
            return DisplayUnitPrice != ""
        }
    }
    
    init(sqlPro: SQL_PRODUCT) {
        Id = sqlPro.Id
        Name = sqlPro.Name
        DisplayName = sqlPro.Name
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
        addObserver(self, forKeyPath: "DisplayUnitPrice", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "DisplayName" {
            if ValueChanged {
                TextColor = NSColor.red
            }
            else {
                TextColor = NSColor.black
            }
            
            if DisplayName != "" {
                dataManager.addUpdate(update: SQL_PRODUCT(aId: Id, aName: DisplayName))
                print("add update  Name:\(Name)   DisplayName:\(DisplayName)")
            }
            else {
                DisplayName = Name
            }
        }
        else if keyPath == "DisplayUnitPrice" {
            if PriceChanged && (Float(DisplayUnitPrice) != nil) {  // (1)value changes , (2) the value is float, (3) has default value
                TextColor = NSColor.red
            }
            else if !PriceChanged { // value not change and no default value
                TextColor = NSColor.black
                return
            }
            else if (Float(DisplayUnitPrice) == nil) {  // (1)value changes , (2) the value is not float
                TextColor = NSColor.brown
                return
            }
            else {
                TextColor = NSColor.black
            }
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "DisplayName")
        removeObserver(self, forKeyPath: "DisplayUnitPrice")
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
    dynamic var DisplayName : String
    var ValueChanged : Bool {
        return Name != DisplayName
    }
    dynamic var TextColor : NSColor = NSColor.black
    var Quantity : Int
    var Sum : Int
    
    var DisplayIndex : Int = 0
    
    init(sqlForm: SQL_FORM) {
        Id = sqlForm.Id
        Name = sqlForm.Name
        DisplayName = sqlForm.Name
        Quantity = sqlForm.Quantity
        Sum = sqlForm.Sum
    }
    
    init(aId: Int,aName: String) {
        Id = aId
        Name = aName
        DisplayName = aName
        Quantity = 0
        Sum = 0
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
    var Note: String
    dynamic var DisplayCompIndex : Int
    dynamic var DisplayProdIndex : Int
    dynamic var DisplayDeliverDate : Date
    dynamic var DisplayUnitPrice : String
    dynamic var DisplayQuantity : String
    dynamic var DisplayNote : String
    
    dynamic var DisplayUnitPriceAtDB : String = ""
    dynamic var TableDisplayCompString : String = ""
    dynamic var TableDisplayProdString : String = ""
    dynamic var TableDisplayDeliverDateString : String = ""
    dynamic var TableDisplayUnitPriceString : String = ""
    dynamic var TableDisplayQuantityString : String = ""
    dynamic var TableDisplayNoteString : String = ""
    
    dynamic var TextColorComp  : NSColor = NSColor.black
    dynamic var TextColorProd  : NSColor = NSColor.black
    dynamic var TextColorDate  : NSColor = NSColor.black
    dynamic var TextColorPrice : NSColor = NSColor.black
    dynamic var TextColorQuan  : NSColor = NSColor.black
    dynamic var TextColorNote  : NSColor = NSColor.black
    
    var isUnsyncData : Bool {
        return CompId <= 0 || ProdId <= 0
    }
    
    dynamic var enableUnitPriceUpdate : Bool = false
    
    func updateEnableUnitPrice() {
        enableUnitPriceUpdate = DisplayUnitPrice != DisplayUnitPriceAtDB && TableDisplayCompString != "" && TableDisplayProdString != ""
    }
    
    func isComplete() -> Bool {
        let notEmpty : Bool = TableDisplayCompString != "" && TableDisplayProdString != "" && TableDisplayDeliverDateString != "" && TableDisplayUnitPriceString != "" && TableDisplayQuantityString != ""
        if notEmpty {
            if Float(TableDisplayUnitPriceString) != nil {
                if Int(TableDisplayQuantityString) != nil {
                    return true
                }
            }
        }
        return false
    }
    
    init(sqlRecord: SQL_RECORD) {
        Id = sqlRecord.Id
        CompId = sqlRecord.CompId
        ProdId = sqlRecord.ProdId
        FormId = sqlRecord.FormId
        CreatedDate = sqlRecord.CreatedDate
        DeliverDate = sqlRecord.DeliverDate
        UnitPrice = sqlRecord.UnitPrice
        Quantity = sqlRecord.Quantity
        Note = sqlRecord.Note
        
        DisplayCompIndex = dataManager.getCompanyIdx(id: sqlRecord.CompId)
        DisplayProdIndex = dataManager.getProductIdx(id: sqlRecord.ProdId)
        DisplayDeliverDate = sqlRecord.DeliverDate
        DisplayUnitPrice = String(sqlRecord.UnitPrice)
        DisplayQuantity = String(sqlRecord.Quantity)
        DisplayNote = String(sqlRecord.Note)
        
        super.init()
        registerObservers()
        
        setupTableDisplay()
    }
    
    init(aId: Int,aCompId: Int,aProdId: Int,aFormId: Int,aCreatedDate: Date,aDeliverDate: Date,aUnitPrice: Double,aQuantity: Int,aNote: String) {
        Id = aId
        CompId = aCompId
        ProdId = aProdId
        FormId = aFormId
        CreatedDate = aCreatedDate
        DeliverDate = aDeliverDate
        UnitPrice = aUnitPrice
        Quantity = aQuantity
        Note = aNote
        
        DisplayCompIndex = dataManager.getCompanyIdx(id: aCompId)
        DisplayProdIndex = dataManager.getProductIdx(id: aProdId)
        DisplayDeliverDate = aDeliverDate
        DisplayUnitPrice = String(aUnitPrice)
        DisplayQuantity = String(aQuantity)
        DisplayNote = String(aNote)
        
        super.init()
        registerObservers()
        
    }
    
    func setupTableDisplay() {
        TableDisplayCompString = dataManager.getCompanyNameFromListOrder(index: DisplayCompIndex)
        TableDisplayProdString = dataManager.getProductNameFromListOrder(index: DisplayProdIndex)
        TableDisplayDeliverDateString = dateFormatterForDisplay(date: DisplayDeliverDate)
        TableDisplayUnitPriceString = String(DisplayUnitPrice)
        TableDisplayQuantityString = String(DisplayQuantity)
        TableDisplayNoteString = String(DisplayNote)
        
        loadUnitPrice()
    }
    
    func registerObservers() {
        addObserver(self, forKeyPath: "DisplayCompIndex", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextCompIndex)
        addObserver(self, forKeyPath: "DisplayProdIndex", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextProdIndex)
        addObserver(self, forKeyPath: "DisplayDeliverDate", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextDeliverDate)
        addObserver(self, forKeyPath: "DisplayUnitPrice", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextUnitPrice)
        addObserver(self, forKeyPath: "DisplayQuantity", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextQuantity)
        addObserver(self, forKeyPath: "DisplayNote", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextNote)
    }
    
    func removeObservers() {
        removeObserver(self, forKeyPath: "DisplayCompIndex")
        removeObserver(self, forKeyPath: "DisplayProdIndex")
        removeObserver(self, forKeyPath: "DisplayDeliverDate")
        removeObserver(self, forKeyPath: "DisplayUnitPrice")
        removeObserver(self, forKeyPath: "DisplayQuantity")
        removeObserver(self, forKeyPath: "DisplayNote")
    }
    
    func loadUnitPrice() {
        if DisplayCompIndex < 0 || DisplayProdIndex < 0 {
            DisplayUnitPriceAtDB = "Null"
            return
        }
        let compId = dataManager.getCompany(index: DisplayCompIndex).Id
        let prodId = dataManager.getProduct(index: DisplayProdIndex).Id
        if let unitPrice = dataManager.getUnitPrice(compId: compId, prodId: prodId) {
            DisplayUnitPriceAtDB = String(unitPrice)
            if isUnsyncData {
                DisplayUnitPrice = DisplayUnitPriceAtDB
            }
        }
        else {
            DisplayUnitPriceAtDB = "Null"
        }
    }
    
    func checkComplete() -> Bool {
        if isComplete() {
            // sent record to data manager only if record is complete.
            let aId = Id
            let aCompId = dataManager.getCompany(index: DisplayCompIndex).Id
            let aProdId = dataManager.getProduct(index: DisplayProdIndex).Id
            let aFormId = FormId
            let aCreatedDate = Date()
            let aDeliverDate = DisplayDeliverDate
            let aUnitPrice = Double(validateString(strline: DisplayUnitPrice))!
            let aQuantity = Int(validateString(strline: DisplayQuantity))!
            let aNote = validateString(strline: DisplayNote)
            
            dataManager.addUpdate(update: SQL_RECORD(aId: aId, aCompId: aCompId, aProdId: aProdId, aFormId: aFormId, aCreatedDate: aCreatedDate, aDeliverDate: aDeliverDate, aUnitPrice: aUnitPrice, aQuantity: aQuantity, aNote: aNote))
            return true
        }
        return false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &contextCompIndex {
            loadUnitPrice()
            if DisplayCompIndex == dataManager.getCompanyIdx(id: self.CompId) {
                TextColorComp = NSColor.black
            }
            else {
                TextColorComp = NSColor.red
            }
            TableDisplayCompString = dataManager.getCompanyNameFromListOrder(index: DisplayCompIndex)
        }
        else if context == &contextProdIndex {
            loadUnitPrice()
            TextColorProd = NSColor.red
            TableDisplayProdString = dataManager.getProductNameFromListOrder(index: DisplayProdIndex)
        }
        else if context == &contextDeliverDate {
            TextColorDate = NSColor.red
            TableDisplayDeliverDateString = dateFormatterForDisplay(date: DisplayDeliverDate)
        }
        else if context == &contextUnitPrice {
            TextColorPrice = NSColor.red
            TableDisplayUnitPriceString = validateString(strline: DisplayUnitPrice)
            updateEnableUnitPrice()
        }
        else if context == &contextQuantity {
            TextColorQuan = NSColor.red
            TableDisplayQuantityString = validateString(strline: DisplayQuantity)
        }
        else if context == &contextNote {
            TextColorNote = NSColor.red
            TableDisplayNoteString = validateString(strline: DisplayNote)
        }
        
        checkComplete()
    }
    
    deinit {
        removeObservers()
    }
    
}

private var contextCompIndex = 0
private var contextProdIndex = 0
private var contextDeliverDate = 0
private var contextUnitPrice = 0
private var contextQuantity = 0
private var contextNote = 0


