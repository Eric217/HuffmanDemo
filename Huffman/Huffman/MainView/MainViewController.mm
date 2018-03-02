//
//  MainViewController.m
//  Huffman
//
//  Created by Eric on 27/02/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "MainViewController.h"
#import "HuffmanTree.hpp"

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
    //MARK: - tree generated
    tree.allPath(1);
    tree.allPath(0);
    tree.Delete();
    delete [] charSet;
    delete [] weights;
    
}


- (void)dealDataAtPath:(NSString *)path {

    NSFileManager *mana = [NSFileManager defaultManager];
    if ([mana fileExistsAtPath:path]) {
        
        if ([mana isReadableFileAtPath:path]) {
     
            NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
            
            NSData *data = [handle readDataToEndOfFile];
         
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           
            NSUInteger len = content.length;
            if (!data || !len) {
                [self presentAlertWithMsg:@"未读取到内容或文件格式有误"];
                return;
            }
//            NSLog(@"%lu characters, content:\n %@", len, content);
            [self dealFinalString:content totalNum:len];
            
        } else {
            [self presentAlertWithMsg:@"没有权限访问该文件"];
        }
    } else {
        [self presentAlertWithMsg:@"选取的文件已不存在"];
    }
    
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









