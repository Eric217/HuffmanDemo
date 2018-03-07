//
//  TreePanel.h
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TreePanel : NSView
@property (nonatomic, copy) NSArray *legs;

+ (TreePanel *)panelWithFrame:(NSRect)f Legs:(NSArray *)arr;

@end
