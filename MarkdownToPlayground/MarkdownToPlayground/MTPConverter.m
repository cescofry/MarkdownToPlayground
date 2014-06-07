//
//  MTPConverter.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import "MTPConverter.h"
#import "MMMarkdown.h"

static NSString *const MTPCodeScannerToken = @"```";
static NSString *const MTPCodePlaceholder = @"{{{mkdtoplg}}}";

@implementation MTPConverter

+ (NSDictionary *)htmlFromMarkdown:(NSString *)markdown
{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:markdown];
    NSInteger index = 0;
    
    while (!scanner.isAtEnd) {
        NSString *mkdown;
        [scanner scanUpToString:MTPCodeScannerToken intoString:&mkdown];
        if (mkdown) {
            [scanner scanString:MTPCodeScannerToken intoString:NULL];
            NSString *html = [MMMarkdown HTMLStringWithMarkdown:mkdown error:NULL];
#warning skipping wraping
            //html = [self wrapHTML:html];
            if (html) {
                NSString *key = [NSString stringWithFormat:@"%ld-mkdtoplg.html", index];
                result[key] = html;
                index ++;
            }
        }
        
        NSString *code;
        [scanner scanUpToString:MTPCodeScannerToken intoString:&code];
        if (code) {
            [scanner scanString:MTPCodeScannerToken intoString:NULL];
            NSString *key = [NSString stringWithFormat:@"%ld-mkdtoplg.swift", index];
            result[key] = code;
            index++;
        }
        
    }
    
    if (result.allKeys.count == 0) {
        NSLog(@"No Code block found!");
        NSString *key = [NSString stringWithFormat:@"%ld-mkdtoplg.html", index];
        result[key] = [MMMarkdown HTMLStringWithMarkdown:markdown error:NULL];
    }
    
    return [result copy];
}

+ (NSString *)wrapHTML:(NSString *)html
{
    static NSString *_htmlFormat;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *bundlePath = [[NSBundle mainBundle] executablePath];
       // NSString *docPath = [bundlePath stringByAppendingPathComponent:@"src"];
        NSURL *url = [NSURL fileURLWithPath:[bundlePath stringByAppendingPathComponent:@"snippet_format.html"]];
        NSError *error;
        _htmlFormat = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error occurred while trying to open resource: %@", error.debugDescription);
        }
    });
    
    return [_htmlFormat stringByReplacingOccurrencesOfString:MTPCodePlaceholder withString:html];
}

@end






