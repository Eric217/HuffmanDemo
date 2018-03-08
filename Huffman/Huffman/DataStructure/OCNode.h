//
//  OCNode.h
//  Huffman
//
//  Created by Eric on 2018/3/8.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCNode : NSObject

@property (assign) int data;
@property (strong) OCNode *link;

+ (OCNode *)nodeWithData:(int)data;

@end
