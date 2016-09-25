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
    
    var companyList: [COMPANY] = []
    var productList: [PRODUCT] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        proTableView.delegate = self
        proTableView.dataSource = self
    }
    
    @IBAction func pressSegControl(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            comTableScrollView.isHidden = false
            proTableScrollView.isHidden = true
        }
        else {
            comTableScrollView.isHidden = true
            proTableScrollView.isHidden = false
        }
    }
    
    
}


extension ComProViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.tableView {
            return companyList.count
        }
        else {
            return productList.count
        }
    }
    
}

extension ComProViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        var textName : String = ""
        var textId : String = ""
        
        if tableView == self.tableView {
            textName = companyList[row].Name
            textId = "\(companyList[row].Id)"
        }
        else {
            textName = productList[row].Name
            textId = "\(productList[row].Id)"
        }
        
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


