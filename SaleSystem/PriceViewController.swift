//
//  ProductViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class PriceViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var popUpButton: NSPopUpButton!
    
    var companyList: [COMPANY] = []
    var productList: [PRODUCT] = []
    var unitpriceList: [UNITPRICE] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        popUpButton.removeAllItems()
        popUpButton.addItem(withTitle: "Select")
        let comStrList:[String] = companyList.map { (p) -> String in
            return p.Name
        }
        popUpButton.addItems(withTitles: comStrList)
        
        unitpriceList = dbManager.loadUnitPriceList()
        
    }
    
    
}


extension PriceViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return productList.count
    }
    
    
}

extension PriceViewController: NSTableViewDelegate {
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        var textName : String = ""
        var textId : String = ""
        
        textName = productList[row].Name
        textId = "\(productList[row].Id)"
        
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
