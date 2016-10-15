//
//  CompViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 14/10/2016.
//
//

import Foundation
import Cocoa

class CompViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var labelName: NSTextField!
    @IBOutlet var comArrayController: NSArrayController!
    
    dynamic var companyList: [COMPANY] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        
        labelName.stringValue = "公司列表"
    }
    
}
