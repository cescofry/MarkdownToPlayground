//
//  Formats.swift
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 15/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

import Foundation

let HELPER = "Usage: mkdtoplg <fileName.md> [-o <outputPath>]"

let HTML_RESOURCE_FORMAT = "<documentation relative-path='%@'/>"
let SWIFT_RESOURCE_FORMAT = "<code source-file-name='%@'/>"

let PLAYGROUND_FORMAT = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?>" +
    "<playground version='1.0' sdk='macosx' allows-reset='yes'>" +
    "<sections>" +
    "%@" +
    "</sections>" +
"</playground>\n"

let HTML_FORMAT = ""

