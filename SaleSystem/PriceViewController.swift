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
    dynamic var productList: [PRODUCT] = []
    var unitpriceList: [UNITPRICE] = []
    var reducedUnitPriceList: [UNITPRICE] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        popUpButton.removeAllItems()
        popUpButton.addItem(withTitle: "Select")
        let comStrList:[String] = companyList.map { (p) -> String in
            return p.Name
        }
        popUpButton.addItems(withTitles: comStrList)
        
        unitpriceList = dataManager.getUnitPriceList()
        
        labelName.stringValue = "單價列表"
        tableView.tableColumns[2].isHidden = true
        addObserver(self, forKeyPath: "reducedUnitPriceList", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    @IBAction func clickPopupButton(_ sender: NSPopUpButton) {
        let selectedIndex : Int = sender.indexOfSelectedItem
        
        if selectedIndex == 0 {
            print("select none")
            let selectedCompId : Int = -1
            print("\(selectedCompId)")
            
            reducedUnitPriceList = []
            tableView.tableColumns[2].isHidden = true
            
        }
        else {
            print("select company:\(companyList[selectedIndex-1].Name)")
            let selectedCompId : Int = companyList[selectedIndex-1].Id
            print("\(selectedCompId)")
            
            reducedUnitPriceList = companyFilter(selectedComId: selectedCompId, unitPriceList: unitpriceList)
            
            for item in reducedUnitPriceList {
                print("item: \(item.Id),product:\(item.ProId) belongs to company id:\(item.ComId) with unit price: \(item.UnitPrice)")
            }
            
            tableView.tableColumns[2].isHidden = false
        }
        
        print("catch reduced unit price list changes")
        cleanProductUnitPrice()
        for item in reducedUnitPriceList {
            setProductUnitPrice(uprice: item)
        }

    }
    
    func setProductUnitPrice(uprice : UNITPRICE) {
        for item in productList {
            if item.Id == uprice.ProId {
                item.UnitPrice = uprice
                item.DisplayUnitPrice = "\(uprice.UnitPrice)"
                return
            }
        }
    }
    
    func cleanProductUnitPrice() {
        for item in productList {
            item.DisplayUnitPrice = ""
            item.UnitPrice = nil
        }
    }
    
}
