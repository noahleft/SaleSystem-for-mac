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
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet var formInfoArray: NSArrayController!
    @IBOutlet var companyArray: NSArrayController!
    @IBOutlet var productArray: NSArrayController!
    
    dynamic var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        
        print("print form id : \(self.formId)")
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = formItem.Name
        }
        
        triggerInitialEvent()
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: &contextSaveAction)
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
        formInfoArray.setSelectionIndex(-1)
        formInfoArray.addObject(emptyRecord)
        
        if tableView.numberOfRows > 0 {
            tableView.scrollRowToVisible(tableView.numberOfRows-1)
            formInfoArray.setSelectionIndex(tableView.numberOfRows-1)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let objectItem = object {
            if object is DATAMANAGER {
                if context == &contextSaveAction {
                    triggerSaveEvent()
                }
            }
        }
        
    }
    
    deinit {
        dataManager.removeObserver(self, forKeyPath: "saveAction")

    }
    
    func triggerSaveEvent() {
        triggerInitialEvent()
    }
    
    @IBAction func pressUpdateUnitPriceButton(_ sender: AnyObject) {
        let record = formInfoList[formInfoArray.selectionIndex]
        let comp = companyList[record.DisplayCompIndex].Id
        let prod = productList[record.DisplayProdIndex].Id
        if let updatePrice = Float(validateString(strline: record.DisplayUnitPrice)) {
            let update : SQL_UNITPRICE = SQL_UNITPRICE(aId: -2, aComId: comp, aProId: prod, aUnitPrice: updatePrice)
            dataManager.shortcutUpdate(update: update)
            
            for item in formInfoList {
                item.loadUnitPrice()
            }
        }
    }
    
    @IBAction func pressUpdateRowButton(_ sender: Any) {
        if (formInfoList.last?.isComplete())! {
            appendEmptyRecord()
        }
    }
    
    @IBAction func saveEvent(_ sender: AnyObject) {
        dataManager.store()
    }
}


extension FormInfoViewController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: Any) -> Bool {
        if dataManager.updateManager.noUnSaveChange {
            return true
        }
        return false
    }
    
}

private var contextSaveAction = 0
