//
//  MTPFileManager.m
//  MarkdownToPlayground
//
//  Created by Francesco Frison on 07/06/2014.
//  Copyright (c) 2014 Ziofritz. All rights reserved.
//

#import "MTPFileManager.h"
#import "Formats.h"
#import "CSSFormats.h"

static NSString *const cssFileName = @"style.css";

@interface MTPFileManager ()

@property (nonatomic, strong, readonly) NSString *playgroundPath;
@property (nonatomic, strong, readonly) NSString *documentationPath;

@end

@implementation MTPFileManager

- (instancetype)initWithMarkdownFile:(NSString *)markdown userPath:(NSString *)path;
{
    self = [super init];
    if (self) {
        _userPath = path;
        
        if ([markdown hasPrefix:@"/"] || [markdown hasPrefix:@"~"]) {
            _filePath = markdown;
        }
        else {
            _filePath = [self.userPath stringByAppendingPathComponent:markdown];
        }
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

- (NSString *)fileName
{
    if (!_fileName) {
        _fileName = [self.filePath.lastPathComponent stringByDeletingPathExtension];
    }
    
    return _fileName;
}

- (NSString *)playgroundPath
{
    // filePath/../fileName.playground
    return [[self.userPath stringByAppendingPathComponent:self.fileName] stringByAppendingPathExtension:@"playground"];
}

- (NSString *)documentationPath
{
    return [self.playgroundPath stringByAppendingPathComponent:@"Documentation"];
}

#pragma mark crete playgound

- (BOOL)createPlaygroundProject
{
    // This will crate both the playgorund directory and the Documentation one at the same time
    NSError *error;
    BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:[self documentationPath] withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"Error while creating playgorund file: %@", error.description);
    }
    else {
        NSString *cssPath = [[self documentationPath] stringByAppendingPathComponent:cssFileName];
        
        NSString *css = CSS_FORMAT;
        [css writeToFile:cssPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error while creating CSS file: %@", error.description);
        }
    }
    
    return (created && !error);
}

- (void)outputPlaygroundWith:(NSDictionary *)content
{
    if (content.allKeys.count == 0) return;
    
    [self createPlaygroundProject];
    
    NSMutableArray *lines = [NSMutableArray array];
    __block NSError *error;
    
    [content enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        BOOL isSwiftFile = [key hasSuffix:@"swift"];
        NSString *format = (isSwiftFile)? SWIFT_RESOURCE_FORMAT : HTML_RESOURCE_FORMAT;
        NSString *line = [NSString stringWithFormat:format, key];
        [lines addObject:line];
        
        NSString *fileRoot = (isSwiftFile)? [self playgroundPath] : [self documentationPath];
        NSString *filePath = [fileRoot stringByAppendingPathComponent:key];
        [value writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Error while writing to file: %@", error.description);
        }
        else {
            NSLog(@"%@ file has been written [%@]", (isSwiftFile)? @"Swift" : @"Doc", key);
        }
    }];
    
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"-(\\d+)\\." options:0 error:&error];

    NSArray *sortedLines = [lines sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSTextCheckingResult *match1 = [regEx firstMatchInString:obj1 options:0 range:NSMakeRange(0, obj1.length)];
        NSInteger num1 = [[obj1 substringWithRange:[match1 rangeAtIndex:1]] integerValue];

        NSTextCheckingResult *match2 = [regEx firstMatchInString:obj2 options:0 range:NSMakeRange(0, obj2.length)];
        NSInteger num2 = [[obj2 substringWithRange:[match2 rangeAtIndex:1]] integerValue];
        
        return (num1 > num2);
    }];
    
    NSString *playgroundContent = [NSString stringWithFormat:PLAYGROUND_FORMAT, [sortedLines componentsJoinedByString:@"\n"]];
    NSString *contentFilePath = [[self playgroundPath] stringByAppendingPathComponent:@"contents.xcplayground"];
    [playgroundContent writeToFile:contentFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error while writing to file: %@", error.description);
    }
    else {
        NSLog(@"Playgorund Documentation created at %@", self.playgroundPath);
    }
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
