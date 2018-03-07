//
//  ELHuffmanUnit.m
//  Huffman
//
//  Created by Eric on 03/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELHuffmanUnit.h"

@implementation ELHuffmanUnit

+ (ELHuffmanUnit *)huffmanUnitWithLocation:(CGPoint)location value:(NSString *)element andLevel:(int)times {
    
    double r = pow(RADIX, times);
    CGFloat legW = LegWidth*r, legH = LegHeight*r;
    CGPoint textLocation = CGPointMake(legW, legH);
    
    ELHuffmanUnit *unit = [[ELHuffmanUnit alloc] initWithFrame:NSMakeRect(location.x, location.y, legW*2+TextSizeW, TextSizeH+legH)];
    unit.leg = [ELHuffmanLeg huffmanLegWithLocation:CGPointZero zoomRate:r];
    unit.textView = [NSText huffmanUnitWithLocation:textLocation andElement:element];
    [unit addSubview:unit.leg];
    [unit addSubview:unit.textView];
    return unit;
    
}

- (void)setLegsWithLeft:(bool)hasLeft right:(bool)hasRight {
    if (hasLeft)
        _leg.showLeft = 1;
    if (hasRight)
        _leg.showRight = 1;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
