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
    
    @IBOutlet weak var webView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path : String = Bundle.main.resourcePath!
        let pathURL : URL = URL(fileURLWithPath: path)
        
        let htmlString:String = generateHTML(companyName: "APPLE", formName: "FORM", recordList: dataManager.getRecordList(formId: 1, compId: 1))
        webView.mainFrame.loadHTMLString(htmlString, baseURL: pathURL)
        
    }
    
}
