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
    var selectedCompId : Int = -1
    dynamic var noUnsaveChanges : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.stringValue = "單價列表"
        
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        triggerInitialEvent()
    }
    
    func triggerInitialEvent() {
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
        popUpButton.removeAllItems()
        popUpButton.addItem(withTitle: "Select")
        let comStrList:[String] = companyList.map { (p) -> String in
            return p.Name
        }
        popUpButton.addItems(withTitles: comStrList)
        
        unitpriceList = dataManager.getUnitPriceList()
        
        tableView.tableColumns[2].isHidden = true
        
        registerObserver()
    }
    
    @IBAction func clickPopupButton(_ sender: NSPopUpButton) {
        let selectedIndex : Int = sender.indexOfSelectedItem
        removeObserver()
        if selectedIndex == 0 {
            print("select none")
            selectedCompId = -1
            print("\(selectedCompId)")
            
            reducedUnitPriceList = []
            tableView.tableColumns[2].isHidden = true
            
        }
        else {
            print("select company:\(companyList[selectedIndex-1].Name)")
            selectedCompId = companyList[selectedIndex-1].Id
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
        registerObserver()
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
    
    func registerObserver() {
        for product in productList {
            product.addObserver(self, forKeyPath: "DisplayUnitPrice", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        }
    }
    
    func removeObserver() {
        for product in productList {
            product.removeObserver(self, forKeyPath: "DisplayUnitPrice")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("PriceVC catch observer notify")
        if let objectValue = object {
            if objectValue is PRODUCT {
                noUnsaveChanges = false
                let product = objectValue as! PRODUCT
                if let updatePrice = Float(product.DisplayUnitPrice){
                    if let price = product.UnitPrice {
                        let update : SQL_UNITPRICE = SQL_UNITPRICE(aId: price.Id, aComId: price.ComId, aProId: price.ProId, aUnitPrice: updatePrice)
                        dataManager.addUpdate(update: update)
                    }
                    else {
                        let update : SQL_UNITPRICE = SQL_UNITPRICE(aId: -1, aComId: selectedCompId, aProId: product.Id, aUnitPrice: updatePrice)
                        dataManager.addUpdate(update: update)
                    }
                }
            } else if objectValue is DATAMANAGER {
                triggerSaveEvent()
            }
        }
    }
    
    func triggerSaveEvent() {
        print("trigger save action at PriceVC")
        removeObserver()
        triggerInitialEvent()
        noUnsaveChanges = true
    }
    
    deinit {
        removeObserver()
        dataManager.removeObserver(self, forKeyPath: "saveAction")
    }
    
    @IBAction func saveEvent(_ sender: AnyObject) {
        dataManager.store()
    }
    
}
