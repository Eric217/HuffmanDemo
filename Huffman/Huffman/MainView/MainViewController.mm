//
//  MainViewController.m
//  Huffman
//
//  Created by Eric on 27/02/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "MainViewController.h"
#import "HuffmanTree.hpp"

#define Encoding NSUTF8StringEncoding

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CGFloat wid = self.view.bounds.size.width;
    CGFloat hei = self.view.bounds.size.height;

    _button = [[NSButton alloc] initWithFrame:NSMakeRect(wid/4, hei/4, wid/2, hei/7)];
    _button.bezelStyle = NSRoundedBezelStyle;
//    _button.bordered = 1;
    [self.view addSubview:_button];
    [_button setTitle:@"click Me"];
    [_button setButtonType:NSMomentaryPushInButton];
//    [_button setAutoresizesSubviews:1];
//    [_button setImageScaling:NSImageScaleAxesIndependently];
    [_button setAction:@selector(selectFilePanel)];
    [_button setTarget:self];
}


/// str: 文件内容字符串 totalNum: 字数
- (void)dealFinalString:(NSString *)str totalNum:(NSUInteger)total {
 
    char * charSet = new char[total];
    int * weights = new int[total];
    int charSetSize = 0;
    bool add;
    
    for (int i = 0; i < total; i++) {
        add = 0;
        char c = [str characterAtIndex:i];
        for (int j = 0; j < charSetSize; j++) {
            if (charSet[j] == c) {
                weights[j]++;
                add = 1;
                break;
            }
        }
        if (!add) {
            charSet[charSetSize] = c;
            weights[charSetSize++] = 1;
        }
    }
    
    BinaryTree<char> tree = HuffmanTree(charSet, weights, charSetSize);
    tree.allPath();
    NSLog(@"%@", dict);

    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger savedClick) {
        if (savedClick) {
            NSString *selectedPath = savePanel.URL.path;
            NSString *fatherDir = [[selectedPath stringByDeletingLastPathComponent] stringByAppendingString:@"/"];
            NSString *typedName = [selectedPath componentsSeparatedByString:@"/"].lastObject;
            typedName = [typedName stringByAppendingString:@"_hfmtree"];
            NSString *hfmPath = [fatherDir stringByAppendingString:typedName];
            NSString *newHfmPath = [hfmPath copy];
            
            NSFileManager *fileMana = NSFileManager.defaultManager;
            int i = 0;
            while (1) {
                bool existed = [fileMana fileExistsAtPath:newHfmPath isDirectory:0];
                if (!existed)
                    break;
                i++;
                NSString *appended = [NSString stringWithFormat:@"(%d)", i];
                newHfmPath = [hfmPath stringByAppendingString:appended];
            }
          
            NSData *hfmData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

            bool creat2 = [fileMana createFileAtPath:newHfmPath contents:hfmData attributes:nil];
            
            bool creat1 = [fileMana createFileAtPath:selectedPath contents:nil attributes:nil];
            if (!creat1 || !creat2) {
                //TODO: - 为什么老是创建失败？？？除了几个特殊的文件夹
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
//            NSFileHandle *writer = [NSFileHandle fileHandleForWritingAtPath:newHfmPath];
//            [writer writeData:hfmData];
 
            NSFileHandle *updater = [NSFileHandle fileHandleForUpdatingAtPath:selectedPath];
//            updater writeData:<#(nonnull NSData *)#>//
            NSMutableData *data = [[NSMutableData alloc] init];
 
            for (int i = 0; i < total; i++) {
                NSString *tempKey = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
                [data appendData:[[dict objectForKey:tempKey] dataUsingEncoding:Encoding]];
                if (!((i+1)%20)) {
                    [updater seekToEndOfFile];
                    [updater writeData:data];
                    data = [[NSMutableData alloc] init];
                }
            }
            if (data.length) {
                [updater seekToEndOfFile];
                [updater writeData:data];
            }
 
        }
    }];
 
    tree.Delete();
    delete [] charSet;
    delete [] weights;
    
}


- (void)dealDataAtPath:(NSString *)path {
    NSFileManager *fileMana = NSFileManager.defaultManager;
    if ([fileMana fileExistsAtPath:path]) {
        if ([fileMana isReadableFileAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSString *content = [[NSString alloc] initWithData:data encoding:Encoding];
            NSUInteger len = content.length;
            if (!data || !len) {
                [self presentAlertWithMsg:@"未读取到内容或文件格式有误"];
                return;
            }
            [self dealFinalString:content totalNum:len];
        } else {
            [self presentAlertWithMsg:@"没有权限访问该文件"];
        }
    } else
        [self presentAlertWithMsg:@"选取的文件已不存在"];
}
    
- (void)selectFilePanel {
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    __weak typeof(self)weakSelf = self;
    panel.canCreateDirectories = 0;
    panel.canChooseDirectories = 0;
    panel.canChooseFiles = 1;
    [panel setAllowsMultipleSelection:0];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result)
            [weakSelf dealDataAtPath:[panel.URLs.firstObject path]];
    }];
    
}
    
- (void)presentAlertWithMsg:(NSString *)msg {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = @"选取失败";
    alert.informativeText = msg;
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
    
}
   
    

@end









