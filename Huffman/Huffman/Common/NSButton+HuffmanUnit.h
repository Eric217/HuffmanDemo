//
//  NSButton+HuffmanUnit.h
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Config.h"

@interface NSButton (HuffmanUnit)

+ (NSButton *)huffmanButtonWithLoca:(CGPoint)l andElement:(NSString *)anElement;

@end
