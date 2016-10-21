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
    @IBOutlet weak var labelName: NSTextField!
    
    dynamic var formList:    [FORM]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formList    = dataManager.getFormList()
        
        labelName.stringValue = "表單列表"
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
    
    
}


