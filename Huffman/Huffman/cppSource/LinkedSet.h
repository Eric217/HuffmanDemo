//
//  LinkedSet.h
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OC_Node : NSObject
@property (assign) id data;
@property (strong) OC_Node *link;
@end

@interface LinkedSet : NSObject
@property (strong) OC_Node *front;
@property (strong) OC_Node *rear;

- (id)init;
//- (void)dealloc;
- (bool)isEmpty;
//- (id)first;
//- (id)last;
- (LinkedSet *)pushWithData:(id)data;
//- (LinkedSet *)popToReceiver:(id *)r;
//- (LinkedSet *)pop;

@end
