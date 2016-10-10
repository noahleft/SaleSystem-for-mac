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
        
        var htmlString:String = generateHTML()
        webView.mainFrame.loadHTMLString(htmlString, baseURL: nil)
        
    }
    
    func generateHTML() -> String {
        return "<br /><h2>Hello World!</h2>"
    }
    
}
