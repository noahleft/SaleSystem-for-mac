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
    
    @IBOutlet var comArrayController: NSArrayController!
    dynamic var companyList: [COMPANY] = []
    @IBOutlet var proArrayController: NSArrayController!
    dynamic var productList: [PRODUCT] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triggerInitialEvent()
        labelName.stringValue = "公司列表"
        
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func appendEmptyCompany() {
        let emptyCompany : COMPANY
        if let lastObj = companyList.last {
            emptyCompany = COMPANY(aId: lastObj.Id+1, aName: "")
        }
        else {
            emptyCompany = COMPANY(aId: 1, aName: "")
        }
        companyList.append(emptyCompany)
        print("# of companyList: \(companyList.count)")
        companyList[companyList.count-1].addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func appendEmptyProduct() {
        let emptyProduct : PRODUCT
        if let lastObj = productList.last {
            emptyProduct = PRODUCT(aId: lastObj.Id+1, aName: "")
        }
        else {
            emptyProduct = PRODUCT(aId: 1, aName: "")
        }
        productList.append(emptyProduct)
        print("# of productList: \(productList.count)")
        productList[productList.count-1].addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        
    }
    
    func triggerInitialEvent() {
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
        
        appendEmptyCompany()
        appendEmptyProduct()
    }
    
    @IBAction func pressSegControl(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            comTableScrollView.isHidden = false
            proTableScrollView.isHidden = true
            labelName.stringValue = "公司列表"
        }
        else {
            comTableScrollView.isHidden = true
            proTableScrollView.isHidden = false
            labelName.stringValue = "產品列表"
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is COMPANY {
            removeObserverForLastComp()
            print("trigger append company")
            appendEmptyCompany()
        }
        else if object is PRODUCT {
            removeObserverForLastProd()
            print("trigger append product")
            appendEmptyProduct()
        }
        else if object is DATAMANAGER {
            print("trigger save action event OuO")
            triggerSaveEvent()
        }
    }
    
    func triggerSaveEvent() {
        print("catch at ComProVC.swift")
        removeObserverForLastComp()
        removeObserverForLastProd()
        triggerInitialEvent()
    }
    
    func removeObserverForLastComp() {
        companyList[companyList.count-1].removeObserver(self, forKeyPath: "DisplayName")
    }
    
    func removeObserverForLastProd() {
        productList[productList.count-1].removeObserver(self, forKeyPath: "DisplayName")
    }
    
    deinit {
        removeObserverForLastComp()
        removeObserverForLastProd()
        dataManager.removeObserver(self, forKeyPath: "saveAction")
    }
}


