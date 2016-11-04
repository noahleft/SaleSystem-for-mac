//
//  FormInfoViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 04/10/2016.
//
//

import Foundation
import Cocoa

class FormInfoViewController: NSViewController {
    
    var formId : Int = -1
    dynamic var formInfoList : [RECORD] = []
    dynamic var companyList : [COMPANY] = []
    dynamic var productList : [PRODUCT] = []
    @IBOutlet weak var labelName: NSTextField!
    
    @IBOutlet var formInfoArray: NSArrayController!
    @IBOutlet var companyArray: NSArrayController!
    @IBOutlet var productArray: NSArrayController!
    
    dynamic var selectedRow : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("print form id : \(self.formId)")
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = formItem.Name
        }
        
        triggerInitialEvent()
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func triggerInitialEvent() {
        formInfoList = dataManager.getRecordList(formId: formId)
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
        appendEmptyRecord()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFormPrint" {
            let nextViewController = segue.destinationController as! FormPrintViewController
            nextViewController.formId = formId
        }
        
    }
    
    func appendEmptyRecord() {
        var newId : Int = dataManager.getRecordListIdForNewData()
        if let lastId = formInfoList.last?.Id {
            if lastId+1 > newId {
                newId = lastId + 1
            }
        }
        let emptyRecord : RECORD = RECORD(aId: newId, aCompId: 0, aProdId: 0, aFormId: formId, aCreatedDate: Date(), aDeliverDate: Date(), aUnitPrice: 0, aQuantity: 0)
        formInfoArray.addObject(emptyRecord)
        
        formInfoList.last?.addObserver(self, forKeyPath: "TableDisplayCompString", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        formInfoList.last?.addObserver(self, forKeyPath: "TableDisplayProdString", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        formInfoList.last?.addObserver(self, forKeyPath: "TableDisplayDeliverDateString", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        formInfoList.last?.addObserver(self, forKeyPath: "TableDisplayUnitPriceString", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        formInfoList.last?.addObserver(self, forKeyPath: "TableDisplayQuantityString", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let objectItem = object {
            if objectItem is RECORD {
                if (objectItem as! RECORD).isComplete() {
                    removeObserverFromLast()
                    appendEmptyRecord()
                }
            }
            else if object is DATAMANAGER {
                triggerSaveEvent()
            }
        }
        
    }
    
    func removeObserverFromLast() {
        formInfoList.last?.removeObserver(self, forKeyPath: "TableDisplayCompString")
        formInfoList.last?.removeObserver(self, forKeyPath: "TableDisplayProdString")
        formInfoList.last?.removeObserver(self, forKeyPath: "TableDisplayDeliverDateString")
        formInfoList.last?.removeObserver(self, forKeyPath: "TableDisplayUnitPriceString")
        formInfoList.last?.removeObserver(self, forKeyPath: "TableDisplayQuantityString")
    }
    
    deinit {
        removeObserverFromLast()
        dataManager.removeObserver(self, forKeyPath: "saveAction")

    }
    
    func triggerSaveEvent() {
        removeObserverFromLast()
        triggerInitialEvent()
    }
    
    @IBAction func pressUpdateUnitPriceButton(_ sender: AnyObject) {
        let record = formInfoList[formInfoArray.selectionIndex]
        let comp = companyList[record.DisplayCompIndex].Id
        let prod = productList[record.DisplayProdIndex].Id
        if let updatePrice = Float(record.DisplayUnitPrice) {
            let update : SQL_UNITPRICE = SQL_UNITPRICE(aId: -2, aComId: comp, aProId: prod, aUnitPrice: updatePrice)
            dataManager.shortcutUpdate(update: update)
            
            for item in formInfoList {
                item.loadUnitPrice()
            }
        }
    }
    
    @IBAction func saveEvent(_ sender: AnyObject) {
        dataManager.store()
    }
}


