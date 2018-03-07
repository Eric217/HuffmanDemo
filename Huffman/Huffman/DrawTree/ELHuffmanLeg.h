//
//  ELHuffmanLeg.h
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSButton+HuffmanUnit.h"

#define LegWidth TextSizeH*1.6
#define LegHeight TextSizeH
#define RADIX 0.8

@interface ELHuffmanLeg : NSView

@property (assign) bool showLeft;
@property (assign) bool showRight;
@property (assign) double rate;

///手动设置是否show line
+ (ELHuffmanLeg *)huffmanLegWithLocation:(CGPoint)location zoomRate:(int)aRate;


@end
