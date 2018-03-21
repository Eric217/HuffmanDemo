//
//  Line.m
//  Huffman
//
//  Created by Eric on 2018/3/8.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Line.h"

@implementation Line

+ (Line *)lineWithSx:(CGFloat)x1 sy:(CGFloat)y1 ex:(CGFloat)x2 ey:(CGFloat)y2 {
    Line *line = [[Line alloc] init];
    line.start = CGPointMake(x1, y1);
    line.end = CGPointMake(x2, y2);
    line.link = 0;
    return line;
}

+ (Line *)lineWithStart:(CGPoint)s end:(CGPoint)e {
    Line *line = [[Line alloc] init];
    line.start = s;
    line.end = e;
    line.link = 0;
    return line;
}

@end
