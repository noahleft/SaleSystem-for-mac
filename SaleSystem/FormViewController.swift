//
//  FormViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class FormViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var popUpButton: NSPopUpButton!
    
    var companyList: [COMPANY] = []
    var productList: [PRODUCT] = []
    var formList:    [FORM]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dbManager.loadCompanyList()
        productList = dbManager.loadProductList()
        formList    = dbManager.loadFormList()
        
    }
    
    
    
}
