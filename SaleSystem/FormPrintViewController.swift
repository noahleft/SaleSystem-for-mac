//
//  FormPrintViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 10/10/2016.
//
//

import Foundation
import Cocoa
import WebKit

class FormPrintViewController: NSViewController {
    
    var formId : Int = -1
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var popUpButton: NSPopUpButton!
    @IBOutlet weak var labelName: NSTextField!
    
    var companyList : [SQL_COMPANY] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = "列印 " + formItem.Name
        }
        else {
            labelName.stringValue = "null"
        }
        
        companyList = dataManager.getCompanyListInForm(formId: formId)
        
        popUpButton.removeAllItems()
        for item in companyList {
            popUpButton.addItem(withTitle: item.Name)
        }
        
        
        loadWeb()
    }
    
    func loadWeb() {
        
        let selectedIndex = popUpButton.indexOfSelectedItem
        let companyItem = companyList[selectedIndex]
        print("\(selectedIndex) -> \(companyItem.Name)")
        
        
        
        let path : String = Bundle.main.resourcePath!
        let pathURL : URL = URL(fileURLWithPath: path)
        
        if let formItem = dataManager.getForm(formId: formId) {
            let htmlString:String = generateHTML(companyName: companyItem.Name, formName: formItem.Name, recordList: dataManager.getRecordList(formId: formItem.Id, compId: companyItem.Id))
            webView.mainFrame.loadHTMLString(htmlString, baseURL: pathURL)
        }
    }
    
    @IBAction func clickPopUpButton(_ sender: AnyObject) {
        loadWeb()
    }
    
    
}
