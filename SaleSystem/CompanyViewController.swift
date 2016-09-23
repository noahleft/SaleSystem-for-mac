//
//  CompanyViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class CompanyViewController: NSViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbManager.loadCompanyList()
        
    }
    
    
    
    
    
}
