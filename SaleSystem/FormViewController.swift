//
//  FormViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class FormViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var formArrayController: NSArrayController!
    
    dynamic var formList:    [FORM]    = []
    dynamic var noUnsaveChanges : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triggerInitialEvent()
        
        registerObserver()
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func triggerInitialEvent() {
        noUnsaveChanges = true
        
        formList = dataManager.getFormList()
        appendEmptyForm()
    }
    
    func appendEmptyForm() {
        let emptyForm : FORM
        if let lastObj = formList.last {
            emptyForm = FORM(aId: lastObj.Id+1, aName: "")
        }
        else {
            emptyForm = FORM(aId: 1, aName: "")
        }
        formArrayController.addObject(emptyForm)
        print("# of formList: \(formList.count)")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "showFormInfo" {
            if tableView.selectedRow == -1 {
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFormInfo" {
            let nextViewController = segue.destinationController as! FormInfoViewController
            nextViewController.formId = formList[tableView.selectedRow].Id
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("observe something @ FormVC")
        if let objectItem = object {
            if objectItem is FORM {
                let form : FORM = objectItem as! FORM
                if form.ValueChanged {
                    form.TextColor = NSColor.red
                }
                else {
                    form.TextColor = NSColor.black
                }
                
                if form.DisplayName != "" {
                    dataManager.addUpdate(update: SQL_FORM(aId: form.Id, aName: form.DisplayName))
                    print("add update FORM: name \(form.DisplayName) @ id:\(form.Id)")
                }
                else {
                    form.DisplayName = form.Name
                }
                noUnsaveChanges = false
            }
            else if object is DATAMANAGER {
                triggerSaveEvent()
            }
        }

    }
    
    func triggerSaveEvent() {
        print("catch at FormVC.swift")
        removeObserver()
        triggerInitialEvent()
        registerObserver()
    }
    
    func registerObserver() {
        for item in formList {
            item.addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        }
    }
    
    func removeObserver() {
        for item in formList {
            item.removeObserver(self, forKeyPath: "DisplayName")
        }
    }
    
    deinit {
        removeObserver()
        dataManager.removeObserver(self, forKeyPath: "saveAction")
    }
    
}

extension FormViewController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: Any) -> Bool {
        if dataManager.updateManager.noUnSaveChange {
            return true
        }
        return false
    }
    
}

