//
//  ViewController.m
//  Huffman
//
//  Created by Eric on 21/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ViewController.h"
#import "LinkedSet.h"
#import "Config.h"
#import "NSViewController+tools.h"
#import "HuffmanTree.hpp"
#import "HuffmanTreeController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()
@property (assign) int treeHeight;
@property (strong) NSMutableDictionary * mutDict;
@property (strong) NSString *contentStr;
@property (assign) NSUInteger contentL;
@property (strong) NSString *codefileStr;
@property (strong) NSString *codePrintStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _treeHeight = 0;

}

- (IBAction)makeTree:(NSButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [self selectPathIsDirAllowed:0 multiSelect:0 successHandler:^(NSArray *arr) {
        NSString *path = [arr.firstObject path];
        
        NSString *content = [[NSString alloc] initWithContentsOfFile:path usedEncoding:nil error:nil];
        
        NSUInteger len = content.length;
        if (!len) {
            [weakSelf presentAlertWithMsg:@"字符编码格式不符"];
            return;
        }
        weakSelf.contentStr = content;
        weakSelf.contentL = len;
        [weakSelf dealFinalString];
    }];
   
}

- (IBAction)encodeAndSave:(NSButton *)sender {
    
    if (!_mutDict) {
        [self presentAlertWithMsg:@"No Tree Found"];
        return;
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"codefile"];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:@"/Users/eric/desktop"]];
 
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger savedClick) {
 
        if (savedClick == 1) {
            //MARK: - 把两个文件的path做好
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
            }//
            
            //MARK: - 把两数据分别写入本地
            NSMutableString *mutStr = [[NSMutableString alloc] init];
            for (int i = 0; i < self.contentL; i++) {
                NSString *tempKey = [NSString stringWithFormat:@"%c", [self.contentStr characterAtIndex:i]];
                [mutStr appendString:[self.mutDict objectForKey:tempKey]];
            }
            //肯定是0 1，所以用ASCII
            unsigned long len = mutStr.length, k = 0, j = 0;
            len += len/50 + 2;
            char buffer[51];
            const char * mutstr = [mutStr cStringUsingEncoding:NSASCIIStringEncoding];
            NSMutableString * codeprint = [[NSMutableString alloc] initWithCapacity:len];
            for (; j < len; k++, j++) {
                if (k == 50) {
                    k -= 50;
                    buffer[50] = '\0';
                    NSString * temp = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
                    [codeprint appendString:temp];
                    [codeprint appendString:@"\n"];
                }
                buffer[k] = mutstr[j];
            }
            buffer[k] = '\0';
            [codeprint appendString:[NSString stringWithCString:buffer encoding:NSASCIIStringEncoding]];
            
            self.codePrintStr = codeprint;
            [self.saveHfmBut setEnabled:0];
            [self.saveCodeBut setEnabled:1];
            [self.realContent setString:codeprint];
            [self.titleContent setStringValue:@"codefile"];
            
            self.codefileStr = mutStr;
            NSData *mutData = [mutStr dataUsingEncoding:NSASCIIStringEncoding];
            //NSData *hfmData = [NSJSONSerialization dataWithJSONObject:self.aDict options:NSJSONWritingPrettyPrinted error:nil];
   
            //bool creat2 = [fileMana createFileAtPath:newHfmPath contents:hfmData attributes:nil];
            bool creat1 = [fileMana createFileAtPath:selectedPath contents:mutData attributes:nil];
            //if (!creat1 || !creat2) {
            if (!creat1) {
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
        }
    }];
    
    
}

- (IBAction)decodeAndSave:(NSButton *)sender {
    if (!_codefileStr) {
        [self presentAlertWithMsg:@"Select Encode First"];
        return;
    }
    unsigned long len = _codefileStr.length;
    NSMutableDictionary *reversedDict = [[NSMutableDictionary alloc] initWithCapacity:_mutDict.count];
    [_mutDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [reversedDict setObject:key forKey:obj];
    }];
    NSMutableString *decodeString = [[NSMutableString alloc] init];
    NSMutableString *temp = [[NSMutableString alloc] init];
    NSString *re;
    for (int i = 0; i < len; i++) {
        unichar c = [_codefileStr characterAtIndex:i];
        [temp appendString:[NSString stringWithFormat:@"%c", c]];
        re = [reversedDict objectForKey:temp];
        if (re) {
            temp = [[NSMutableString alloc] init];
            [decodeString appendString:re];
        }
    }
    //MARK: - 保存到本地
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"textfile"];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:@"/Users/eric/desktop"]];
    
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger saveClicked) {
        if (saveClicked == 1) {
            NSString *selectedPath = savePanel.URL.path;
            bool created = [NSFileManager.defaultManager createFileAtPath:selectedPath contents:[decodeString dataUsingEncoding:4] attributes:nil];
            
            if (!created) {
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
        }
    }];

  
}

- (IBAction)showTree:(NSButton *)sender {
    if (_treeHeight <= 1) {
        [self presentAlertWithMsg:@"请先构造树"];
        return;
    }
    HuffmanTreeController *controller = [HuffmanTreeController treeControllerWithDict:_mutDict treeHeight:_treeHeight];
    NSWindow *window = [NSWindow windowWithContentViewController:controller];
    [self.view.window addChildWindow:window ordered:NSWindowAbove];
}

- (IBAction)saveHfmTree:(id)sender {
    if (!_mutDict) {
        [self presentAlertWithMsg:@"No Tree Built"];
        return;
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"hfmtree"];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:@"/Users/eric/desktop"]];
    
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger savedClick) {
        if (savedClick == 1) {
            NSString *selectedPath = savePanel.URL.path;
            NSData *hfmData = [NSJSONSerialization dataWithJSONObject:self.mutDict options:NSJSONWritingPrettyPrinted error:nil];
            bool creat2 = [NSFileManager.defaultManager createFileAtPath:selectedPath contents:hfmData attributes:nil];
            if (!creat2) {
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
        }
    }];
     
    
}

- (IBAction)saveCodePrint:(id)sender {
    if (!_codePrintStr) {
        [self presentAlertWithMsg:@"No Code Printed"];
        return;
    }
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setNameFieldStringValue:@"codeprint"];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:@"/Users/eric/desktop"]];
    
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger savedClick) {
        if (savedClick == 1) {
            NSString *selectedPath = savePanel.URL.path;
            NSData *adata = [self.codePrintStr dataUsingEncoding:NSASCIIStringEncoding];
            bool creat2 = [NSFileManager.defaultManager createFileAtPath:selectedPath contents:adata attributes:nil];
            if (!creat2) {
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
        }
    }];
  
    
}

///已得到文件的内容字符串：str 总字符数：totalNum
- (void)dealFinalString {
    
    //MARK: - 生成字符集，权重和霍夫曼树，写到全局字典dict里
    char * charSet = new char[_contentL];
    int * weights = new int[_contentL];
    int charSetSize = 0;
    
    bool add;
    for (int i = 0; i < _contentL; i++) {
        add = 0;
        char c = [_contentStr characterAtIndex:i];
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
    _treeHeight = tree.height();
    NSString * dictStr = [NSString stringWithFormat:@"%@", tree.dict];
    [_realContent setString:dictStr];
    
    [_titleContent setStringValue:@"hfmtree"];
    [self.saveCodeBut setEnabled:0];
    [self.saveHfmBut setEnabled:1];
    _mutDict = tree.dict.copy;
    
    tree.Delete();
    delete [] charSet;
    delete [] weights;
  
}


- (IBAction)compress:(id)sender {
 
    
}

- (IBAction)unzip:(id)sender {
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end






