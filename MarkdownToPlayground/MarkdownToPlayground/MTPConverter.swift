//
//  MTPConverter.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//

import Foundation


struct ScanToken {
    var start: String?
    var end: String
}

let MTPCodeScannerImportToken = ScanToken(start: "import", end: "\n")
let MTPCodeScannerCodeToken = ScanToken(start: nil, end: "```")
let MTPCodeScannerSwiftToken = "swift"

class MTPConverter {

    var scanner : NSScanner
    var result : Dictionary<String, String>
    var scanIndex: NSInteger = 0
    var projectPath: String
    
    init(config: MTPConfig, markdown: String) {
        if (config.projectPath != nil) {
            self.projectPath = config.projectPath!
        }
        else {
            self.projectPath = config.userPath!
        }
        
        self.scanner = NSScanner(string: markdown)
        self.result = Dictionary<String, String>()
    }
    
    func addResource(resource: String?, type: String?) {
        let key = currentKey(type)
        self.result[key] = resource
        self.scanIndex++
    }
    
    func currentKey(type: String?) -> String {
        return "section-\(self.scanIndex).\(type!)"
    }
    

    func matchStringFromToken(token: ScanToken) -> String? {
        var result : NSString? = nil
        
        var startFound = true
        if token.start != nil {
            var startText: NSString? = nil
            self.scanner.scanUpToString(token.start!, intoString: &startText)
            startFound = startText != nil && startText!.length > 0
            
            self.scanner.scanString(token.start!, intoString: nil)
        }
        
        if !startFound {
            return result
        }
        
        self.scanner.scanUpToString(token.end, intoString: &result)
        
        if (result != nil) {
            self.scanner.scanString(token.end, intoString: nil)
        }
        return result
    }

    
    func htmlFromMarkdown() -> Dictionary<String, String> {
        
        // Import clasees
        var imports = Array<String>()
        var lastImportPosition = 0
        while !self.scanner.atEnd {
            
            let importClass = matchStringFromToken(MTPCodeScannerImportToken)
            
            if importClass != nil {
                let classText = swiftCodeFromImport(importClass!)
                if classText != nil {
                    imports.append(classText!)
                }
                else {
                    println("Couldn't find file to import at \(importClass!)")
                }
                lastImportPosition = self.scanner.scanLocation
            }
            else {
                break
            }
        }
        self.scanner.scanLocation = lastImportPosition
        
        while !self.scanner.atEnd {
            var mkdown = matchStringFromToken(MTPCodeScannerCodeToken)
        
            // HTML Section
            if mkdown != nil {
                var html = MMMarkdown.HTMLStringWithMarkdown(mkdown, error: nil)
                
                if html {
                    html = wrapHTML(html)
                    addResource(html, type: "html")
                }
            }
            
            var code : NSString? = matchStringFromToken(MTPCodeScannerCodeToken)
            
            // Swift
            if code != nil {
                if code!.hasPrefix(MTPCodeScannerSwiftToken) {
                    code = code!.substringFromIndex(countElements(MTPCodeScannerSwiftToken))
                }
                
                addResource(code, type: "swift")
            }
        }
        
        if result.count == 0 {
            println("No Code block found!")
            var html = MMMarkdown.HTMLStringWithMarkdown(scanner.string, error: nil)
            html = wrapHTML(html)
            addResource(html, type: "html")
        }
        
        var html = appendFooterToHTML("")
        html = wrapHTML(html)
        addResource(html, type: "html")
        
        for text in imports {
            addResource(text, type: "swift")
        }

        return result
    }
    
    func wrapHTML(html: String) -> String {
        let key = currentKey("html")
        return NSString(format: HTML_FORMAT, key, html)
    }
    
    func appendFooterToHTML(html: String) -> String {
        return html + FOOTER_HTML + "\n"
    }
    
    func swiftCodeFromImport(importPath: String) -> String? {
        
        let classPath = self.projectPath.stringByAppendingPathComponent(importPath)
        var error : NSError? = nil
        
        let code = NSString(contentsOfFile: classPath, encoding: NSUTF8StringEncoding, error: &error)
        if error != nil {
            println("Error: \(error!.debugDescription)")
            return nil
        }
            
        return code
    }
}