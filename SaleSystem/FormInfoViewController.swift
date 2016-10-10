//
//  FormInfoViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 04/10/2016.
//
//

import Foundation
import Cocoa

class FormInfoViewController: NSViewController {
    
    var formId : Int = -1
    
    @IBOutlet weak var labelName: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("print form id : \(self.formId)")
        
        if let formItem = dataManager.getForm(formId: formId) {
            labelName.stringValue = formItem.Name
        }
        
        
    }
    
    
}
