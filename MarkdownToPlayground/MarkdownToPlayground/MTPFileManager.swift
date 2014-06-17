//
//  MTPFileManager.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

let MTPFileManagerCSSFileName = "style.css"

class MTPFileManager {
    
    var filePath: String
    var userPath: String
    var customCSSPath: String? {
    willSet {
        if newValue {
            self.customCSSPath = self.userPath.stringByAppendingString(newValue!);
        }
    }
    }
    
    class var regEx : NSRegularExpression {
        get {
            var error : NSError? = nil
            let regExString : NSString! = "-(\\d+)\\."
            return NSRegularExpression.regularExpressionWithPattern(regExString, options: nil, error: &error)
    }
    }
    
    var filename: String? {
    get {
        return self.filePath.lastPathComponent.stringByDeletingPathExtension
    }
    }
    
    var markdown: String {
    get {
        let url = NSURL.fileURLWithPath(self.filePath)
        var error : NSError? = nil
        var result = NSString.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: &error)
        if error {
            NSLog("An error occured while retrieveing markdown at url %@\n %@", url.absoluteString, error!.localizedDescription);
        }
        return result
    }
    }
    
    var playgroundPath: String {
    get {
        // filePath/../fileName.playground
        return self.userPath.stringByAppendingPathComponent(self.filename!).stringByAppendingPathExtension("playground")
    }
    }
    
    var documentationPath: String {
    get {
        return self.playgroundPath.stringByAppendingPathComponent("Documentation")
    }
    }
    
    init(markdownFile: String?, userPath: String?) {
        self.userPath = userPath!
        
        if markdownFile!.hasPrefix("/") || markdownFile!.hasPrefix("~") {
            self.filePath = markdownFile!
        }
        else {
            self.filePath = self.userPath.stringByAppendingPathComponent(markdownFile!)
        }
    }
    
    func createCSS() -> NSError? {
        let cssPath = self.documentationPath.stringByAppendingPathComponent(MTPFileManagerCSSFileName)
        var cssFormat : String?
        if self.customCSSPath {
            cssFormat = NSString(contentsOfFile: self.customCSSPath, encoding: NSUTF8StringEncoding, error: nil)
            cssFormat = cssFormat!.stringByAppendingString("\n%@\n")
        }
        if (!cssFormat) {
            cssFormat = CSS_FORMAT
        }
        let css = NSString(format: cssFormat!, CSS_SECTION_FORMAT)
        
        var error : NSError? = nil
        css.writeToFile(cssPath, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        if (error) {
            NSLog("Error while creating CSS file: %@", error!.localizedDescription);
        }
        
        return error
    }
    
    func createPlaygroundProject() -> Bool {
        var error : NSError? = nil
        let created = NSFileManager.defaultManager().createDirectoryAtPath(self.documentationPath, withIntermediateDirectories: true, attributes: nil, error: &error)
        if !created || error {
             NSLog("Error while creating playgorund file: %@", error!.localizedDescription);
            return false
        }
        else {
            error = createCSS()
            return !error
        }
    }
    
    func outputPlaygroundWithContent(content : Dictionary<String, String>?) {
        if !content {
            return
        }
        
        createPlaygroundProject()
        
        var lines = Array<String>()
        var error: NSError? = nil
        
        for (key, value) in content! {
            let isSwift = key.hasSuffix("swift")
            
            var format :String
            var fileRoot :String
            var fileType :String
            if isSwift {
                format = SWIFT_RESOURCE_FORMAT
                fileRoot = self.playgroundPath
                fileType = "Swift"
            }
            else {
                format = HTML_RESOURCE_FORMAT
                fileRoot = self.documentationPath
                fileType = "Documentation"
            }
            
            let line = NSString(format: format, key)
            lines.append(line)
            
            let filePath = fileRoot.stringByAppendingPathComponent(key)
            value.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
            
            if (error) {
                NSLog("Error while writing to file: %@", error!.localizedDescription);
            }
            else {
                NSLog("%@ file has been written [%@]", fileType, key);
            }
            
        }
        
        let orderedLines = sortLines(lines)
        
        let playgroundContent = NSString(format: PLAYGROUND_FORMAT, orderedLines.componentsJoinedByString("\n"))
        let contentFilePath = self.playgroundPath.stringByAppendingPathComponent("contents.xcplayground")
        playgroundContent.writeToFile(contentFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        if (error) {
            NSLog("Error while writing to file: %@", error!.localizedDescription);
        }
        else {
            NSLog("Playgorund Documentation created at %@", self.playgroundPath);
        }
        
    }
    
    func intFromName(name: NSString) -> Int? {
        
        let match = MTPFileManager.regEx.firstMatchInString(name, options: nil, range: NSMakeRange(0, name.length))
        let range = match.rangeAtIndex(1)
        let num = name.substringWithRange(range)
        
        return num.toInt()
    }
    
    func sortLines(lines: Array<String>) -> NSArray {
        
        let comparator = { (line1 :AnyObject!, line2: AnyObject!) -> NSComparisonResult in
            let num1 = self.intFromName(line1 as String)!;
            let num2 = self.intFromName(line2 as String)!;
            
            if num1 == num2 {
                return NSComparisonResult.OrderedSame
            }
            else if num1 > num2 {
                return NSComparisonResult.OrderedDescending
            }
            else {
                return NSComparisonResult.OrderedAscending
            }
        }
        let toBeSortedArray : NSArray = lines
        
        return toBeSortedArray.sortedArrayUsingComparator(comparator)
    }
    
}