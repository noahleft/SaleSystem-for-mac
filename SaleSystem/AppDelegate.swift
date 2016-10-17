//
//  AppDelegate.swift
//  SaleSystem
//
//  Created by 林世豐 on 9/4/16.
//
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func openDocument(_ sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .db file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["db"];
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentPath = documentDirectory[0].stringByAppendingPathComponent(path: path.lastPathComponent)
                do {
                    print("source: \(path)")
                    print("destin: \(documentPath)")
                    try FileManager.default.copyItem(atPath: path, toPath: documentPath)
                }
                catch {
                    print("copy item fails")
                }
                UserDefaults.standard.set(documentPath, forKey: "database")
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }   
    
    
}

