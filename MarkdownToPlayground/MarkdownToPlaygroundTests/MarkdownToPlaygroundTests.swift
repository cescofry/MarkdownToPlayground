//
//  MarkdownToPlaygroundTests.swift
//  MarkdownToPlaygroundTests
//
//  Created by Francesco Frison on 6/23/14.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import XCTest

class MarkdownToPlaygroundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProcessMarkDownOnSections() {
        let mkdown = "this is test and ``` some code ``` Plus some test as well"
        let content = MTPConverter.htmlFromMarkdown(mkdown)
        
        let info = infoFromContent(content)
        
        XCTAssertTrue(info.html.count == 3, "Unexpected number of HTML sections \(info.html.count)")
        XCTAssertTrue(info.swift.count == 1, "Unexpected number of Swift sections \(info.swift.count)")
        XCTAssertTrue(info.others.count == 0, "Unexpected number of other sections \(info.others.count)")
    }
    
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
