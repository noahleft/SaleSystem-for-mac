//
//  CompanyViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class ComProViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var proTableView: NSTableView!
    @IBOutlet weak var ComProSeg: NSSegmentedControl!
    
    @IBOutlet weak var comTableScrollView: NSScrollView!
    @IBOutlet weak var proTableScrollView: NSScrollView!
    @IBOutlet weak var labelName: NSTextField!
    
    @IBOutlet weak var buttonNewCom: NSButton!
    @IBOutlet var comArrayController: NSArrayController!
    dynamic var companyList: [COMPANY] = []
    @IBOutlet weak var buttonNewPro: NSButton!
    @IBOutlet var proArrayController: NSArrayController!
    dynamic var productList: [PRODUCT] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
        self.addObserver(self, forKeyPath: "companyList", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        proTableView.delegate = self
//        proTableView.dataSource = self
        
        labelName.stringValue = "公司列表"
    }
    
    @IBAction func pressSegControl(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            comTableScrollView.isHidden = false
            buttonNewCom.isHidden = false
            proTableScrollView.isHidden = true
            buttonNewPro.isHidden = true
            labelName.stringValue = "公司列表"
        }
        else {
            comTableScrollView.isHidden = true
            buttonNewCom.isHidden = true
            proTableScrollView.isHidden = false
            buttonNewPro.isHidden = false
            labelName.stringValue = "產品列表"
        }
    }
    
    @IBAction func pressButtonNewCom(_ sender: AnyObject) {
        var newObj : COMPANY
        if let lastObj = companyList.last {
            if lastObj.Name == "" {
                return
            }
            newObj = COMPANY(aId: lastObj.Id+1, aName: "")
        }
        else {
            newObj = COMPANY(aId: 1, aName: "")
        }
        companyList.append(newObj)
    }
    
    @IBAction func pressButtonNewPro(_ sender: AnyObject) {
        var newObj : PRODUCT
        if let lastObj = productList.last {
            if lastObj.Name == "" {
                return
            }
            newObj = PRODUCT(aId: lastObj.Id+1, aName: "")
        }
        else {
            newObj = PRODUCT(aId: 1, aName: "")
        }
        productList.append(newObj)
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("companyList value changes")
    }
    
    
    
    
}


//extension ComProViewController: NSTableViewDataSource {
//    
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        if tableView == self.tableView {
//            return companyList.count
//        }
//        else {
//            return productList.count
//        }
//    }
//    
//}
//
//extension ComProViewController: NSTableViewDelegate {
//    
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        
//        var text:String = ""
//        var cellIdentifier: String = ""
//        
//        // 1
//        var textName : String = ""
//        var textId : String = ""
//        
//        if tableView == self.tableView {
//            textName = companyList[row].Name
//            textId = "\(companyList[row].Id)"
//        }
//        else {
//            textName = productList[row].Name
//            textId = "\(productList[row].Id)"
//        }
//        
//        // 2
//        if tableColumn == tableView.tableColumns[0] {
//            text = textId
//            cellIdentifier = "IdCellID"
//        } else if tableColumn == tableView.tableColumns[1] {
//            text = textName
//            cellIdentifier = "NameCellID"
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
//    override func controlTextDidEndEditing(_ obj: Notification) {
//        print("end of change")
//    }
//    
//    override func controlTextDidChange(_ obj: Notification) {
//        print("changing")
//        let userInfo : [String:String] = obj.userInfo as! [String : String]
//        let view = userInfo["NSFieldEditor"]
//        print("\(view)")
//    }
//    
//    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
////        NSLog(@"control: textShouldEndEditing >%@<", [fieldEditor string] );
//        print("\(control) : textShouldEndEditing \(fieldEditor)")
//        return true
//    }
//    
//}


