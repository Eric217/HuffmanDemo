//
//  NSViewController+tools.h
//  Huffman
//
//  Created by Eric on 03/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSViewController (tools)

- (void)selectPathIsDirAllowed:(BOOL)dirAllowed multiSelect:(BOOL)multiAllowed successHandler:(void (^) (NSArray *))handler;
- (void)presentAlertWithMsg:(NSString *)msg;

@end
