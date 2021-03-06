//
//  CompanyViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class CompanyViewController: NSViewController {
    
    @IBOutlet var arrayController: NSArrayController!
    dynamic var companyList: [COMPANY] = []
    
    @IBOutlet weak var companyIdTextLabel: NSTextField!
    @IBOutlet weak var companyNameTextBox: NSTextField!
    
    @IBOutlet weak var latestQuantityTableColumn: NSTableColumn!
    @IBOutlet weak var lastQuantityTableColumn: NSTableColumn!
    @IBOutlet weak var lastLastQuantityTableColumn: NSTableColumn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triggerInitialEvent()
        
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func appendEmptyCompany() {
        let emptyCompany : COMPANY
        if let lastObj = companyList.last {
            emptyCompany = COMPANY(aId: lastObj.Id+1, aName: "")
        }
        else {
            emptyCompany = COMPANY(aId: 1, aName: "")
        }
        arrayController.addObject(emptyCompany)
        print("# of companyList: \(companyList.count)")
        companyList[companyList.count-1].addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func triggerInitialEvent() {
        companyList = dataManager.getCompanyList()
        
        // get last 3 month
        var formList = dataManager.getFormList()
        if let latestForm = formList.popLast() {
            latestQuantityTableColumn.title = latestForm.Name
            if let lastForm = formList.popLast() {
                lastQuantityTableColumn.title = lastForm.Name
                if let lastLastForm = formList.popLast() {
                    lastLastQuantityTableColumn.title = lastLastForm.Name
                }
            }
        }
        
        appendEmptyCompany()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is COMPANY {
            removeObserverForLastComp()
            print("trigger append company")
            appendEmptyCompany()
        }
        else if object is DATAMANAGER {
            print("trigger save action event OuO")
            triggerSaveEvent()
        }
    }
    
    func triggerSaveEvent() {
        print("catch at ComProVC.swift")
        removeObserverForLastComp()
        triggerInitialEvent()
    }
    
    func removeObserverForLastComp() {
        companyList[companyList.count-1].removeObserver(self, forKeyPath: "DisplayName")
    }
    
    deinit {
        removeObserverForLastComp()
        dataManager.removeObserver(self, forKeyPath: "saveAction")
    }
    
    func fetchDisplayData() {
        let id = companyIdTextLabel.integerValue
        let companyName = companyNameTextBox.stringValue
        
        print("\(id) \(companyName)")
        if companyList[id-1].Id == id {
            companyList[id-1].DisplayName = companyName
        }
    }
    
    @IBAction func saveEvent(_ sender: AnyObject) {
        fetchDisplayData()
        dataManager.store()
    }
    
}

extension CompanyViewController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: Any) -> Bool {
        if dataManager.updateManager.noUnSaveChange {
            return true
        }
        return false
    }
    
}
