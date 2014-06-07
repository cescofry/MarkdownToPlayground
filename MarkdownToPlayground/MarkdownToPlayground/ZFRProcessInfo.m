//
//  ZFRProcessInfo.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import "ZFRProcessInfo.h"

@implementation ZFRProcessInfo


+ (NSDictionary *)processInfoWithFull:(BOOL)isFull
{
    NSArray *keys = @[@"HOME", @"USER", @"PWD"];

    NSDictionary *all = [[NSProcessInfo processInfo] environment];
    if (!isFull) {
        all = [all dictionaryWithValuesForKeys:keys];
    }
    NSMutableDictionary *environment = [[all dictionaryWithValuesForKeys:keys] mutableCopy];
    
    __block NSString *pendingKey = nil;
    __block NSInteger unkeyedIndex = 0;
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    [arguments enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj hasPrefix:@"-"]) {
            pendingKey = [obj stringByReplacingOccurrencesOfString:@"-" withString:@""];
            return;
        }
        
        if (idx == 0) {
            pendingKey = @"build_path";
        }
        
        NSString *key;
        if (pendingKey) {
            key = pendingKey;
            pendingKey = nil;
        }
        else {
            key = [NSString stringWithFormat:@"%ld", unkeyedIndex];
            unkeyedIndex++;
        }
        environment[key] = obj;
    }];
    
    return [environment copy];
}

+ (NSDictionary *)fullProcessInfo
{
    return [self processInfoWithFull:YES];
}

+ (NSDictionary *)processInfo
{
    return [self processInfoWithFull:NO];
}

@end
