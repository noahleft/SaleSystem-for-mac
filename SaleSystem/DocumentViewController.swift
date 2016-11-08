//
//  documentViewController.swift
//  SaleSystem
//
//  Created by 林世豐 on 08/11/2016.
//
//

import Foundation
import Cocoa


class DocumentViewController: NSViewController {
    
    dynamic var fileName : String = ""
    dynamic var isValidName : Bool {
        return fileName != ""
    }
    
    @IBAction func pressSaveButton(_ sender: AnyObject) {
        print("\(fileName)")
        let filePath = fileName + ".db"
        
        if let path = Bundle.main.path(forResource: "new", ofType: "db") {
        
            let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentPath = documentDirectory[0].stringByAppendingPathComponent(path: filePath)
            do {
                print("source: \(path)")
                print("destin: \(documentPath)")
                try FileManager.default.copyItem(atPath: path, toPath: documentPath)
            }
            catch {
                print("copy item fails")
            }
            UserDefaults.standard.set(documentPath, forKey: "database")
            
            
            NSApplication.shared().mainWindow?.close()
        }
        else {
            print("check bundle setting")
        }
    }
    
}


