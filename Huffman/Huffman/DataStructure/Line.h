//
//  Line.h
//  Huffman
//
//  Created by Eric on 2018/3/8.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject
@property (assign) CGPoint start;
@property (assign) CGPoint end;
@property Line *link;

+ (Line *)lineWithSx:(CGFloat)x1 sy:(CGFloat)y1 ex:(CGFloat)x2 ey:(CGFloat)y2;

+ (Line *)lineWithStart:(CGPoint)s end:(CGPoint)e;

@end
