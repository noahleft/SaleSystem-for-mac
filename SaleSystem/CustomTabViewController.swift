//
//  CustomTabViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 17/10/2016.
//
//

import Foundation
import Cocoa

class CustomTabViewController: NSTabViewController {
    
    override func tabView(_ tabView: NSTabView, shouldSelect tabViewItem: NSTabViewItem?) -> Bool {
        return dataManager.updateManager.noUnSaveChange
    }
    
}

