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
    @IBOutlet weak var popUpButton: NSPopUpButton!
    
    var companyList: [COMPANY] = []
    var productList: [PRODUCT] = []
    var formList:    [FORM]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        formList    = dataManager.getFormList()
        
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFormInfo" {
            let nextViewController = segue.destinationController as! FormInfoViewController
            nextViewController.FormId = 1
        }
        
    }
    
    
}

extension FormViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return formList.count
    }
    
    
}

extension FormViewController: NSTableViewDelegate {
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        var textName : String = ""
        var textId : String = ""
        
        textName = formList[row].Name
        textId = "\(formList[row].Id)"
        
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = textId
            cellIdentifier = "IdCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = textName
            cellIdentifier = "NameCellID"
        }
        
        // 3
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    
}
