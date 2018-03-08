//
//  TreePanel.m
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "TreePanel.h"

@implementation TreePanel

//每次点击按钮，都TM调用了drawRect!!!
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (!_legs) {
        NSLog(@"Leg not Initialized");
        return;
    }
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGMutablePathRef path = CGPathCreateMutable();
    [_legs enumeratLegsWithBlock:^(CGPoint start, CGPoint end) {
        CGPathMoveToPoint(path, nil, start.x, start.y);
        CGPathAddLineToPoint(path, nil, end.x, end.y);
    }];
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, NSColor.blackColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
}

@end

