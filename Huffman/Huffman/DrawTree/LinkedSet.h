//
//  LinkedSet.h
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCNode.h"
#import "Line.h"
#import "Config.h"

@interface LinkedSet : NSObject {
    OCNode *front;
    OCNode *rear;
    
    Line *front2;
    Line *rear2;
    
}
//
//@property (strong) OCNode *front;
//@property (strong) OCNode *rear;

- (id)init;
//- (void)dealloc;

- (bool)isEmpty;

//- (id)first;
//- (id)last;

- (LinkedSet *)pushWithData:(int)data;
- (LinkedSet *)pushWithLine:(Line *)data;

//- (LinkedSet *)popToReceiver:(id *)r;
//- (LinkedSet *)pop;

- (void)enumeratDataWithBlock:(void(^)(int))block;
- (void)enumeratLegsWithBlock:(void (^)(CGPoint start, CGPoint end))block;



@end
