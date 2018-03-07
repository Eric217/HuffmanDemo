//
//  Config.m
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Config.h"

@implementation Config

+ (void)logRect:(CGRect)rect {
    NSLog(@"x: %f y: %f w: %f h: %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
