//
//  HuffmanTreeController.h
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "ELHuffmanUnit.h"


@interface HuffmanTreeController : NSViewController

@property (nonatomic, copy) NSDictionary *tree;
//@property (nonatomic, strong) ELHuffmanUnit *root;
@property (assign) int height;

+ (HuffmanTreeController *)treeControllerWithDict:(NSDictionary *)dict treeHeight:(int)height;

@end
