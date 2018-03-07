//
//  LinkedSet.m
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "LinkedSet.h"

@implementation LinkedSet




- (LinkedSet *)pushWithData:(id)data {
    OC_Node *temp = _front;
    while (temp) {
        if (data == temp.data)
            return self;
        temp = temp.link;
    }
    OC_Node *n = [[OC_Node alloc] init];
    
    
    return self;
}




- (bool)isEmpty {
    return !_front;
}

//- (void)dealloc
//{
//    while (_front) {
//        OC_Node * tem = _front.link;
//        free((__bridge void *)(_front));
//        _front = tem;
//    }
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _front = 0;
        _rear = 0;
    }
    return self;
}

@end
