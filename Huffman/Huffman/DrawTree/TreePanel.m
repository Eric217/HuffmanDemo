//
//  TreePanel.m
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "TreePanel.h"

@implementation TreePanel

+ (TreePanel *)panelWithFrame:(NSRect)f Legs:(NSArray *)arr {
    TreePanel *p = [[TreePanel alloc] initWithFrame:f];
    p.legs = arr;
    return p;
}

//每次点击按钮，都TM调用了drawRect!!!
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (!_legs) {
        NSLog(@"Leg not Initialized");
        return;
    }


}

@end
