//
//  MTPFileManager.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import "MTPFileManager.h"

@implementation MTPFileManager

- (instancetype)initWithFileAtPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _filePath = path;
        _fileName = [_filePath.lastPathComponent stringByReplacingOccurrencesOfString:[_filePath pathExtension] withString:@""];
    }
    return self;
}

- (NSString *)markdown
{
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    NSError *error;
    NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"An error occured while retrieveing markdown: %@", error.debugDescription);
    }
    return result;
}

- (void)outputPlaygroundWith:(NSDictionary *)content
{
    
}


#pragma mark - Resources URL

+ (NSURL *)fileURLForResourceName:(NSString *)name
{
    
    NSString *path = [[NSBundle mainBundle] executablePath];
    path = [path stringByDeletingLastPathComponent];
    path = [path stringByAppendingPathComponent:@"src"];
    
    path = [path stringByAppendingPathComponent:name];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    [url checkResourceIsReachableAndReturnError:&error];
    if (error) {
        NSLog(@"Error occurred while trying to open resource: %@", error.debugDescription);
    }
    
    return url;
}

@end
