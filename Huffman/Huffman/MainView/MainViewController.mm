//
//  MainViewController.m
//  Huffman
//
//  Created by Eric on 27/02/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "MainViewController.h"
#import "HuffmanTree.hpp"
#import "NSViewController+tools.h"
#import "HuffmanTreeController.h"

@interface MainViewController ()
@property (assign) int treeHeight;
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    CGFloat wid = self.view.bounds.size.width;
    CGFloat hei = self.view.bounds.size.height;

    _encoder = [[NSButton alloc] initWithFrame:NSMakeRect(wid/5, hei*0.6, 100, 35)];
    _decoder = [[NSButton alloc] initWithFrame:NSMakeRect(wid*0.4+100, hei*0.6, 100, 35)];
    _drawTree = [[NSButton alloc] initWithFrame:NSMakeRect(wid/5, hei*0.6-75, 100, 35)];

    _encoder.bezelStyle = NSRoundedBezelStyle;
    _decoder.bezelStyle = NSRoundedBezelStyle;
    _drawTree.bezelStyle = NSRoundedBezelStyle;

    [self.view addSubview:_decoder];
    [self.view addSubview:_encoder];
    [self.view addSubview:_drawTree];

    [_encoder setTitle:@"开始编码"];
    [_decoder setTitle:@"解码"];
    [_drawTree setTitle:@"显示树"];
    
    [_drawTree setButtonType:NSMomentaryPushInButton];
    [_decoder setButtonType:NSMomentaryPushInButton];
    [_encoder setButtonType:NSMomentaryPushInButton];
 
    [_decoder setAction:@selector(selectFileToDecode)];
    [_decoder setTarget:self];
    [_encoder setAction:@selector(selectFileToEncode)];
    [_encoder setTarget:self];
    [_drawTree setAction:@selector(drawTreeFromDict)];
    [_drawTree setTarget:self];
}

- (void)drawTreeFromDict {
    HuffmanTreeController *controller = [HuffmanTreeController treeControllerWithDict:dict treeHeight:_treeHeight];
    NSWindow *window = [NSWindow windowWithContentViewController:controller];
    [self.view.window addChildWindow:window ordered:NSWindowAbove];
}

- (void)selectFileToDecode {
    
    __weak typeof(self)weakSelf = self;
    
    [self selectPathIsDirAllowed:0 multiSelect:0 successHandler:^(NSArray * urls) {
        //MARK: - 获取原字符串
        NSString *path = [urls.firstObject path];
        NSString *codedString = [[NSString alloc] initWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
        unsigned long len = codedString.length;
        NSMutableDictionary *reversedDict = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [reversedDict setObject:key forKey:obj];
        }];
        NSMutableString *decodeString = [[NSMutableString alloc] init];
        NSMutableString *temp = [[NSMutableString alloc] init];
        NSString *re;
        for (int i = 0; i < len; i++) {
            unichar c = [codedString characterAtIndex:i];
            [temp appendString:[NSString stringWithFormat:@"%c", c]];
            re = [reversedDict objectForKey:temp];
            if (re) {
                temp = [[NSMutableString alloc] init];
                [decodeString appendString:re];
            }
        }
        //MARK: - 保存到本地
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel beginSheetModalForWindow:weakSelf.view.window completionHandler:^(NSInteger saveClicked) {
            if (saveClicked == 1) {
                NSString *selectedPath = savePanel.URL.path;
                bool created = [NSFileManager.defaultManager createFileAtPath:selectedPath contents:[decodeString dataUsingEncoding:4] attributes:nil];
               
                if (!created) {
                    [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                    return;
                }
            }
        }];
    }];

}

///已得到文件的内容字符串：str 总字符数：totalNum
- (void)dealFinalString:(NSString *)str totalNum:(NSUInteger)total {
 
    //MARK: - 生成字符集，权重和霍夫曼树，写到全局字典dict里
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
    _treeHeight = tree.height();
    NSLog(@"%@", dict);

    NSSavePanel *savePanel = [NSSavePanel savePanel];
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
            for (int i = 0; i < total; i++) {
                NSString *tempKey = [NSString stringWithFormat:@"%c", [str characterAtIndex:i]];
                [mutStr appendString:[dict objectForKey:tempKey]];
            }
            //肯定是0 1，所以用ASCII
            NSData *mutData = [mutStr dataUsingEncoding:NSASCIIStringEncoding];
            NSData *hfmData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            //沙盒下总是创建失败
            bool creat2 = [fileMana createFileAtPath:newHfmPath contents:hfmData attributes:nil];
            bool creat1 = [fileMana createFileAtPath:selectedPath contents:mutData attributes:nil];
            if (!creat1 || !creat2) {
                [self presentAlertWithMsg:@"创建文件时失败，请重试"];
                return;
            }
        }
    }];
 
    tree.Delete();
    delete [] charSet;
    delete [] weights;
}

///取文件 里面调用 dealFinalString
- (void)selectFileToEncode {
    
    __weak typeof(self) weakSelf = self;
    [self selectPathIsDirAllowed:0 multiSelect:0 successHandler:^(NSArray *arr) {
        NSString *path = [arr.firstObject path];
        NSString *content = [[NSString alloc] initWithContentsOfFile:path usedEncoding:nil error:nil];
        NSLog(@"%zd", Encoding);
        NSUInteger len = content.length;
        if (!len) {
            [weakSelf presentAlertWithMsg:@"字符编码格式不符"];
            return;
        }
        [weakSelf dealFinalString:content totalNum:len];
    }];
    
    
}

@end


