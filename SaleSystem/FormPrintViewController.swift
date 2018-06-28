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
    @IBOutlet weak var taxButton: NSButton!
    @IBOutlet weak var updateTaxButton: NSButton!
    
    var companyList : [SQL_COMPANY] = []
    
    override func viewDidLoad() {
        updateTaxButton.isHidden = true
        super.viewDidLoad()
        
        if let formItem = dataManager.getForm(formId: formId) {
            let printString = NSLocalizedString("FormPrint_Print", comment: "")
            labelName.stringValue = printString + " " + formItem.Name
        }
        else {
            labelName.stringValue = "null"
        }
        
        companyList = dataManager.getCompanyListInForm(formId: formId)
        
        popUpButton.removeAllItems()
        for item in companyList {
            popUpButton.addItem(withTitle: item.Name)
        }
        
        checkTaxButtonState()
        loadWeb()
        
        setupPrintInfo()
    }
    
    func setupPrintInfo() {
        let printInfoCenter = NSPrintInfo.shared()
        printInfoCenter.verticalPagination = NSPrintingPaginationMode.autoPagination
        printInfoCenter.leftMargin = 0
        printInfoCenter.rightMargin = 0
        printInfoCenter.isHorizontallyCentered = true
        printInfoCenter.topMargin = 0
        printInfoCenter.bottomMargin = 0
    }
    
    func loadWeb() {
        
        let selectedIndex = popUpButton.indexOfSelectedItem
        let companyItem = companyList[selectedIndex]
        print("\(selectedIndex) -> \(companyItem.Name)")
        
        let path : String = Bundle.main.resourcePath!
        let pathURL : URL = URL(fileURLWithPath: path)
        
        if let formItem = dataManager.getForm(formId: formId) {
            let htmlString:String = generateHTML(companyName: companyItem.Name, formName: formItem.Name, recordList: dataManager.getRecordList(formId: formItem.Id, compId: companyItem.Id), taxIncluded: taxButton.state==NSOnState
            )
            webView.mainFrame.loadHTMLString(htmlString, baseURL: pathURL)
        }
    }
    
    func checkTaxButtonState() {
        let selectedIndex = popUpButton.indexOfSelectedItem
        let companyItem = companyList[selectedIndex]
        if companyItem.PrintTax == true {
            taxButton.state = NSOnState
        }
        else {
            taxButton.state = NSOffState
        }
    }
    
    @IBAction func clickPopUpButton(_ sender: AnyObject) {
        checkTaxButtonState()
        loadWeb()
        updateTaxButton.isHidden = true
        updateTaxButton.isEnabled = true
    }
    
    @IBAction func clickTaxButton(_ sender: Any) {
        loadWeb()
        updateTaxButton.isHidden = false
        updateTaxButton.isEnabled = true
    }
    
    @IBAction func clickUpdateTaxStateButton(_ sender: Any) {
        updateTaxButton.isEnabled = false
        
        // store tax print out state to db
        let selectedIndex = popUpButton.indexOfSelectedItem
        let companyItem = companyList[selectedIndex]
        let printTax : Bool = taxButton.state == NSOnState
        companyList[selectedIndex].PrintTax = printTax
        let update : SQL_COMPANY = SQL_COMPANY(aId: companyItem.Id, aName: companyItem.Name, aPrintTax: printTax)
        dataManager.addUpdate(update: update)
        dataManager.store()
        checkTaxButtonState()
    }
    
}
