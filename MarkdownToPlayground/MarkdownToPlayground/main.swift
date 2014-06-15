//
//  main.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation


let env = ZFRProcessInfo.info()

if env["0"] {
    NSLog("Missing markdown file")
    NSLog("", HELPER)
}
