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
        
        triggerInitialEvent()
        labelName.stringValue = "公司列表"
    }
    
    func triggerInitialEvent() {
        companyList = dataManager.getCompanyList()
        productList = dataManager.getProductList()
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
    
    func saveDocument(_ sender: AnyObject) {
        print("catch at ComProVC.swift")
        dataManager.updateManager.dumpUpdate()
        dataManager.store()
        triggerInitialEvent()
    }
    
}


