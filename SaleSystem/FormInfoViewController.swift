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
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet var formInfoArray: NSArrayController!
    @IBOutlet var companyArray: NSArrayController!
    @IBOutlet var productArray: NSArrayController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("print form id : \(self.formId)")
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = formItem.Name
        }
        
        formInfoList = dataManager.getRecordList(formId: formId)
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
//        tableView.dataSource = self
//        tableView.delegate   = self
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFormPrint" {
            let nextViewController = segue.destinationController as! FormPrintViewController
            nextViewController.formId = formId
        }
        
    }
    
}


//extension FormInfoViewController: NSTableViewDataSource {
//    
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return formInfoList.count
//    }
//    
//}
//
//extension FormInfoViewController: NSTableViewDelegate {
//    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        var text:String = ""
//        var cellIdentifier: String = ""
//        
//        // 1
//        var textId : String = ""
//        var textCom: String = ""
//        var textPro: String = ""
//        var textDeliver: String = ""
//        var textUnitPrice : String = ""
//        var textQuantity: String = ""
//        var textSum: String = ""
//        
//        textId = "\(formInfoList[row].Id)"
//        textCom = "\(dataManager.getCompanyName(id: formInfoList[row].CompId))"
//        textPro = "\(dataManager.getProductName(id: formInfoList[row].ProdId))"
//        textDeliver = dateFormatterForDisplay(date: formInfoList[row].DeliverDate)
//        textUnitPrice = "\(formInfoList[row].UnitPrice)"
//        textQuantity = "\(formInfoList[row].Quantity)"
//        let up = formInfoList[row].UnitPrice
//        let qu : Double = Double(formInfoList[row].Quantity)
//        let sum = up * qu
//        
//        textSum = "\(sum)"
//        
//        // 2
//        if tableColumn == tableView.tableColumns[0] {
//            text = textId
//            cellIdentifier = "IdCellID"
//        } else if tableColumn == tableView.tableColumns[1] {
//            text = textCom
//            cellIdentifier = "CompCellID"
//        } else if tableColumn == tableView.tableColumns[2] {
//            text = textPro
//            cellIdentifier = "ProdCellID"
//        } else if tableColumn == tableView.tableColumns[3] {
//            text = textDeliver
//            cellIdentifier = "DeliCellID"
//        } else if tableColumn == tableView.tableColumns[4] {
//            text = textUnitPrice
//            cellIdentifier = "UnitCellID"
//        } else if tableColumn == tableView.tableColumns[5] {
//            text = textQuantity
//            cellIdentifier = "QuanCellID"
//        } else if tableColumn == tableView.tableColumns[6] {
//            text = textSum
//            cellIdentifier = "SumCellID"
//        }
//        
//        // 3
//        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
//            cell.textField?.stringValue = text
//            return cell
//        }
//        return nil
//    }
//    
//    
//    
//}


