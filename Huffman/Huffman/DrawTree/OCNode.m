//
//  OCNode+OCNode.h
//  Huffman
//
//  Created by Eric on 2018/3/8.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "OCNode.h"

@implementation OCNode

+ (OCNode *)nodeWithData:(int)data {
    OCNode *node = [[OCNode alloc] init];
    node.data = data;
    node.link = 0;
    return node;
}


@end
