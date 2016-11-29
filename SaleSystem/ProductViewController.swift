//
//  CompanyViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Foundation
import Cocoa

class ProductViewController: NSViewController {
    
    @IBOutlet var arrayController: NSArrayController!
    dynamic var productList: [PRODUCT] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triggerInitialEvent()
        
        dataManager.addObserver(self, forKeyPath: "saveAction", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
    }
    
    func appendEmptyProduct() {
        let emptyProduct : PRODUCT
        if let lastObj = productList.last {
            emptyProduct = PRODUCT(aId: lastObj.Id+1, aName: "")
        }
        else {
            emptyProduct = PRODUCT(aId: 1, aName: "")
        }
        arrayController.addObject(emptyProduct)
        print("# of productList: \(productList.count)")
        productList[productList.count-1].addObserver(self, forKeyPath: "DisplayName", options: NSKeyValueObservingOptions(rawValue: UInt(0)), context: nil)
        
    }
    
    func triggerInitialEvent() {
        productList = dataManager.getProductList()
        appendEmptyProduct()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is PRODUCT {
            removeObserverForLastProd()
            print("trigger append product")
            appendEmptyProduct()
        }
        else if object is DATAMANAGER {
            print("trigger save action event OuO")
            triggerSaveEvent()
        }
    }
    
    func triggerSaveEvent() {
        print("catch at ComProVC.swift")
        removeObserverForLastProd()
        triggerInitialEvent()
    }
    
    func removeObserverForLastProd() {
        productList[productList.count-1].removeObserver(self, forKeyPath: "DisplayName")
    }
    
    deinit {
        removeObserverForLastProd()
        dataManager.removeObserver(self, forKeyPath: "saveAction")
    }
    
    @IBAction func saveEvent(_ sender: AnyObject) {
        dataManager.store()
    }
    
}

extension ProductViewController : NSWindowDelegate {
    
    func windowShouldClose(_ sender: Any) -> Bool {
        if dataManager.updateManager.noUnSaveChange {
            return true
        }
        return false
    }
    
}

