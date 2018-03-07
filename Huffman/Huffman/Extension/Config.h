//
//  Config.h
//  Huffman
//
//  Created by Eric on 2018/3/7.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Zero_Sign "###"
#define UnitSize 36
#define SepaWidth UnitSize/2

#define HFMLEFTPATH_OC '0'
#define HFMRIGHTPATH_OC '1'
#define LEFT_HIGH_OC 1

#define ScreenWidth NSScreen.mainScreen.frame.size.width
#define ScreenHeigh NSScreen.mainScreen.frame.size.height


@interface Config : NSObject

+ (void)logRect:(CGRect)rect;

@end
