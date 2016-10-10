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
    var formInfoList : [RECORD] = []
    @IBOutlet weak var labelName: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("print form id : \(self.formId)")
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = formItem.Name
        }
        
        formInfoList = dataManager.getRecordList(formId: formId)
        
        tableView.dataSource = self
        tableView.delegate   = self
        
    }
    
    
}


extension FormInfoViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return formInfoList.count
    }
    
}

extension FormInfoViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        var textId : String = ""
        var textCom: String = ""
        var textPro: String = ""
        var textDeliver: String = ""
        var textUnitPrice : String = ""
        var textQuantity: String = ""
        
        textId = "\(formInfoList[row].Id)"
        textCom = "\(formInfoList[row].CompId)"
        textPro = "\(formInfoList[row].ProdId)"
        textDeliver = dateFormatterForDisplay(date: formInfoList[row].DeliverDate)
        textUnitPrice = "\(formInfoList[row].UnitPrice)"
        textQuantity = "\(formInfoList[row].Quantity)"
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = textId
            cellIdentifier = "IdCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = textCom
            cellIdentifier = "CompCellID"
        } else if tableColumn == tableView.tableColumns[2] {
            text = textPro
            cellIdentifier = "ProdCellID"
        } else if tableColumn == tableView.tableColumns[3] {
            text = textDeliver
            cellIdentifier = "DeliCellID"
        } else if tableColumn == tableView.tableColumns[4] {
            text = textUnitPrice
            cellIdentifier = "UnitCellID"
        } else if tableColumn == tableView.tableColumns[5] {
            text = textQuantity
            cellIdentifier = "QuanCellID"
        }
        
        // 3
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    
    
}
