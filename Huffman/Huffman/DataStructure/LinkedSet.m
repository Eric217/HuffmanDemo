//
//  LinkedSet.m
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "LinkedSet.h"

@implementation LinkedSet

//
- (LinkedSet *)pushWithData:(int)data {
    OCNode *temp = front;
    while (temp) {
        if (data == temp.data)
            return self;
        temp = temp.link;
    }
    OCNode *node = [OCNode nodeWithData:data];
    if (front)
        rear = rear.link = node;
    else
        front = rear = node;
    return self;
}

- (LinkedSet *)pushWithLine:(Line *)data {
    Line *temp = front2;
    while (temp) {
        if ([Config comparePoint:temp.start and:data.start] && [Config comparePoint:temp.end and:data.end])
            return self;
        temp = temp.link;
    }
    if (front2)
        rear2 = rear2.link = data;
    else
        front2 = rear2 = data;
    return self;
}

- (void)enumeratDataWithBlock:(void (^)(int))block {
    OCNode *temp = front;
    while (temp) {
        block(temp.data);
        temp = temp.link;
    }
}

- (void)enumeratLegsWithBlock:(void (^)(CGPoint, CGPoint))block {
    Line *temp = front2;
    while (temp) {
        block(temp.start, temp.end);
        temp = temp.link;
    }
}

- (bool)isEmpty {
    return !front && !front2;
}
 
- (instancetype)init
{
    self = [super init];
    if (self) {
        front = 0;
        rear = 0;
        front2 = 0;
        rear2 = 0;
    }
    return self;
}

@end
