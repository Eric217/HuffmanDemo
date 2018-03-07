//
//  NSButton+HuffmanUnit.m
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "NSButton+HuffmanUnit.h"

@implementation NSButton (HuffmanUnit)
+ (NSButton *)huffmanButtonWithLoca:(CGPoint)l andElement:(NSString *)anElement {

    NSButton *but = [[NSButton alloc] initWithFrame:CGRectMake(l.x, l.y, UnitSize, UnitSize)];
    but.bezelStyle = NSRoundedBezelStyle;
    [but setButtonType:NSMomentaryPushInButton];
    if ([anElement isEqual: @Zero_Sign]) {
        [but setTitle:@" "];
        but.enabled = 0;
    } else
        [but setTitle:anElement];
    //NSLog(@"%f  %f", l.x, l.y);
    return but;
}

@end
