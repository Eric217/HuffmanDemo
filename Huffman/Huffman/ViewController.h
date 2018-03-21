//
//  ViewController.h
//  Huffman
//
//  Created by Eric on 21/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (strong) IBOutlet NSButton *makeTreeBut;
@property (strong) IBOutlet NSButton *encodeBut;
@property (strong) IBOutlet NSButton *decodeBut;
@property (strong) IBOutlet NSButton *showTreeBut;

@property (strong) IBOutlet NSButton *saveHfmBut;
@property (strong) IBOutlet NSButton *saveCodeBut;

@property (strong) IBOutlet NSButton *compressBut;
@property (strong) IBOutlet NSButton *unZipBut;

@property (strong) IBOutlet NSTextField *titleContent;
@property (strong) IBOutlet NSTextField *realContent;

@end

