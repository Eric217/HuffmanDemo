//
//  ELHuffmanUnit.h
//  Huffman
//
//  Created by Eric on 03/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ELHuffmanLeg.h"

@interface ELHuffmanUnit : NSView

@property (nonatomic, strong) NSButton *textView;
@property (nonatomic, strong) ELHuffmanLeg *leg;
@property (nonatomic, strong) ELHuffmanUnit *leftChild;
@property (nonatomic, strong) ELHuffmanUnit *rightChild;

//@property (nonatomic, assign) int level

+ (ELHuffmanUnit *)huffmanUnitWithLocation:(CGPoint)location value:(NSString *)element andLevel:(int)times;

- (void)setLegsWithLeft:(bool)hasLeft right:(bool)hasRight;

@end
