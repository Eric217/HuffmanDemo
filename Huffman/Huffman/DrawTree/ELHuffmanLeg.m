//
//  ELHuffmanLeg.m
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELHuffmanLeg.h"
#import <math.h>

@implementation ELHuffmanLeg

+ (ELHuffmanLeg *)huffmanLegWithLocation:(CGPoint)location zoomRate:(int)aRate {
    
    ELHuffmanLeg *leg = [[ELHuffmanLeg alloc] initWithFrame:NSMakeRect(location.x, location.y, LegWidth*2*aRate+TextSizeW, LegHeight*aRate)];
    leg.rate = aRate;
    leg.showRight = 0;
    leg.showLeft = 0;
    return leg;
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
   
    if (!_showLeft && !_showRight)
        return;
    
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat frameX = _frame.origin.x, frameY = _frame.origin.y, frameW = _frame.size.width;
    if (_showLeft) {
        CGPathMoveToPoint(path, nil, frameX, frameY);
        CGPathAddLineToPoint(path, nil, frameX+LegWidth*_rate, frameY+LegHeight*_rate);
    }
    if (_showRight) {
        CGPathMoveToPoint(path, nil, frameX+frameW, frameY);
        CGPathAddLineToPoint(path, nil, frameX+LegWidth*_rate+TextSizeW, frameY+LegHeight*_rate);
    }
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, NSColor.blackColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    
    
//    NSGraphicsContext context
    
    
    
    
    
}

@end
