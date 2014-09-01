//
//  Config.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 7/2/14.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

class MTPConfig {
    var markDownFile : String?
    var userPath : String?
    var projectPath : String?
    let output : String?
    let customCSS : String?
    let help : AnyObject!
    let predicate: NSPredicate
    
    init() {
        
        let env = ZFRProcessInfo.info()
        
        markDownFile = env["0"]
        userPath = env["PWD"]
        output = env["o"]
        customCSS = env["css"]
        help = env["help"]
        
        predicate = NSPredicate(format: "self CONTAINS %@", argumentArray: [".xcodeproj"])
        
        
        projectPath = findProjectInPath(userPath!)
        
        if output != nil {
            userPath = output
        }
        
        
        if !markDownFile!.hasPrefix("/") && !markDownFile!.hasPrefix("~") {
            markDownFile = userPath!.stringByAppendingPathComponent(markDownFile!)
        }
    }
    
    
    private func findProjectInPath(path : String) -> String? {
        let fileManager = NSFileManager.defaultManager()
        
        
        let files : NSArray? = fileManager.contentsOfDirectoryAtPath(path, error: nil)
        if (files == nil) {
            return nil;
        }
        else {
            let projs = files!.filteredArrayUsingPredicate(predicate)
            if projs.count > 0 {
                let fullprojectPath = projs[0] as NSString
                return path
            }
            else {
                for file in files! {
                    var isDir : ObjCBool = ObjCBool(0)
                    if (fileManager.fileExistsAtPath(file as String, isDirectory:&isDir) && isDir.boolValue) {
                        let dirPath = path.stringByAppendingPathComponent(file as String)
                        let fullprojectPath = findProjectInPath(dirPath)
                        if (fullprojectPath != nil) {
                            return fullprojectPath
                        }
                    }
                }
                return nil
            }
        }
        
    }
    
}


extension String {
    var lenght : Int {
    get {
        return countElements(self)
    }
    }
}
