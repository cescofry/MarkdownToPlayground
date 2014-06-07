//
//  main.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPConverter.h"
#import "MTPFileManager.h"
#import "Formats.h"
#import "ZFRProcessInfo.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSDictionary *env = [ZFRProcessInfo processInfo];
        
        if (!env[@"0"]) {
            NSLog(@"Missing makrdown file");
            NSLog(@"%@", HELPER);
            return 1;
        }
        
        if (env[@"help"]) {
            NSLog(@"%@", HELPER);
            return 0;
        }
        
        NSString *markdownFile = env[@"0"];
        NSString *userPath = env[@"PWD"];
        
        MTPFileManager *fileManager = [[MTPFileManager alloc] initWithMarkdownFile:markdownFile userPath:userPath];
        NSDictionary *contents = [MTPConverter htmlFromMarkdown:fileManager.markdown];
        [fileManager outputPlaygroundWith:contents];
        
    }
    return 0;
}

