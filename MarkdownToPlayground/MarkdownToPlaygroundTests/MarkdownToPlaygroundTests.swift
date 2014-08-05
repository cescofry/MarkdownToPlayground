//
//  MarkdownToPlaygroundTests.swift
//  MarkdownToPlaygroundTests
//
//  Created by Francesco Frison on 6/23/14.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import XCTest

var config: MTPConfig? = nil

class MarkdownToPlaygroundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        config = MTPConfig()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testProcessMarkDownOnSections() {
        let mkdown = "this is test and ``` some code ``` Plus some test as well"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        XCTAssertTrue(info.html.count == 3, "Unexpected number of HTML sections \(info.html.count)")
        XCTAssertTrue(info.swift.count == 1, "Unexpected number of Swift sections \(info.swift.count)")
        XCTAssertTrue(info.others.count == 0, "Unexpected number of other sections \(info.others.count)")
    }
    
    func testProcessMarkDownOnSectionsSwiftContent() {
        let mkdown = "this is test and ``` some code ``` Plus some test as well ``` some code ``` and another"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)

        
        for (key, swift) in info.swift {
            let swiftRange = NSString(string: swift).rangeOfString("some code")
            XCTAssertTrue(swiftRange.location != NSNotFound, "Test not found in Swift portion \(key)")
        }
    }
    
    func testProcessMarkDownOnSectionsHTMLContent() {
        let mkdown = "this is test ``` some code ``` this is test ``` some code ``` this is test"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        
        for (key, html) in info.html {
            let keyRange = NSString(string: html).rangeOfString("5") // Search for the footer
            if keyRange.location == NSNotFound {
                let HTMLRange = NSString(string: html).rangeOfString("this is test")
                XCTAssertTrue(HTMLRange.location != NSNotFound, "Test not found in HTML portion \(key)")
            }
        }
    }
    
    func testProcessMarkDownStripSwiftCodeBlock() {
        let mkdown = "this is test and ```swift some code ```and another"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        
        for (key, swift) in info.swift {
            let swiftRange = NSString(string: swift).rangeOfString("swift")
            XCTAssertTrue(swiftRange.location == NSNotFound, "Swift keyword Shouldn't be present insede code block")
        }
    }
    
    func testProcessImports() {
        let mkdown = "#import MarkdownToPlaygroundTests/TestClass.swift\n Car this is test and ```swift some code ```and another"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        var isCodeInIt = false
        for (key, swift) in info.swift {
            let importRange = NSString(string: swift).rangeOfString("let thisIsATest = true")
             isCodeInIt = isCodeInIt || importRange.location != NSNotFound
        }
        
        XCTAssertTrue(isCodeInIt, "code should have been imported")
    }
    
    func testImportsAreLastCodeKeys() {
        let mkdown = "#import MarkdownToPlaygroundTests/TestClass.swift\n Car this is test and ```swift some code ```and another"
        let content = contentFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        var importKey : String?
        for (key, swift) in info.swift {
            let importRange = NSString(string: swift).rangeOfString("let thisIsATest = true")
            let isImportCode = importRange.location != NSNotFound
            if isImportCode {
                importKey = key
            }
        }
        if importKey != nil {
            let numberRange = NSString(string: importKey).rangeOfString("4")
            XCTAssertTrue(numberRange.location != NSNotFound, "code should have been placed Last [\(importKey)]")
        }
        else {
            XCTFail("code should have been placed Last. Key not found")
        }
    }

    
}


func contentFromMarkdown(markdown : String) -> Dictionary<String, String> {
    let converter = MTPConverter(config: config!, markdown: markdown)
    return converter.htmlFromMarkdown()
}

func infoFromContent(content: Dictionary<String, String>) -> (html: Dictionary<String, String>, swift: Dictionary<String, String>, others: Dictionary<String, String>) {
    
    var html = Dictionary<String, String>()
    var swift = Dictionary<String, String>()
    var others = Dictionary<String, String>()
    
    for (key, value) in content {
        
        let isHTML = key.hasSuffix("html")
        let isSWIFT = key.hasSuffix("swift")
        
        if isHTML {
            html[key] = value
        }
        else if isSWIFT {
            swift[key] = value
        }
        else {
            others[key] = value
        }
    }
    
    return (html: html, swift:swift, others: others)
}
