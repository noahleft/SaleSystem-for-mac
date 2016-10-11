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
    
    var companyList : [COMPANY] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyList = dataManager.getCompanyList()
        
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
