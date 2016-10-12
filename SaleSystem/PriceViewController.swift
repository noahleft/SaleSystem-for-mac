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
    @IBOutlet weak var labelName: NSTextField!
    
    var companyList: [COMPANY] = []
    var productList: [PRODUCT] = []
    var unitpriceList: [UNITPRICE] = []
    var reducedUnitPriceList: [UNITPRICE] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        popUpButton.removeAllItems()
        popUpButton.addItem(withTitle: "Select")
        let comStrList:[String] = companyList.map { (p) -> String in
            return p.Name
        }
        popUpButton.addItems(withTitles: comStrList)
        
        unitpriceList = dataManager.getUnitPriceList()
        
        labelName.stringValue = "單價列表"
    }
    
    @IBAction func clickPopupButton(_ sender: NSPopUpButton) {
        let selectedIndex : Int = sender.indexOfSelectedItem
        
        if selectedIndex == 0 {
            print("select none")
            let selectedCompId : Int = -1
            print("\(selectedCompId)")
            
            reducedUnitPriceList = []
            
        }
        else {
            print("select company:\(companyList[selectedIndex-1].Name)")
            let selectedCompId : Int = companyList[selectedIndex-1].Id
            print("\(selectedCompId)")
            
            reducedUnitPriceList = companyFilter(selectedComId: selectedCompId, unitPriceList: unitpriceList)
            
            for item in reducedUnitPriceList {
                print("item: \(item.Id),product:\(item.ProId) belongs to company id:\(item.ComId) with unit price: \(item.UnitPrice)")
            }
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
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
        var textPrice : String = ""
        
        textName = productList[row].Name
        textId = "\(productList[row].Id)"
        let selectedUnitPrice : Float = selectUnitPrice(selectedProId: productList[row].Id, unitPriceList: reducedUnitPriceList)
        
        if selectedUnitPrice == -1 {
            textPrice = ""
        }
        else {
            textPrice = "\(selectedUnitPrice)"
        }
        
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = textId
            cellIdentifier = "IdCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = textName
            cellIdentifier = "NameCellID"
        } else if tableColumn == tableView.tableColumns[2] {
            text = textPrice
            cellIdentifier = "PriceCellID"
        }
        
        // 3
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
    
}
