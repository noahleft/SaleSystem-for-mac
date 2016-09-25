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
    
    @IBOutlet weak var tableView: NSTableView!
    
    var companyList: [COMPANY] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dbManager.loadCompanyList()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension CompanyViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return companyList.count
    }
    
}

extension CompanyViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        let item = companyList[row]
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = "\(item.Id)"
            cellIdentifier = "IdCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.Name
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


