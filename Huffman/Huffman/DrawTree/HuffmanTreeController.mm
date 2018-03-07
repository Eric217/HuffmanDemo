//
//  HuffmanTreeController.m
//  Huffman
//
//  Created by Eric on 04/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "HuffmanTreeController.h"
#import "TreePanel.h"
#import "NSButton+HuffmanUnit.h"
#import "MainViewController.h"

@implementation HuffmanTreeController

+ (HuffmanTreeController *)treeControllerWithDict:(NSDictionary *)dict treeHeight:(int)height {
    HuffmanTreeController *cont = [[HuffmanTreeController alloc] init];
    cont.tree = dict;
    cont.height = height;
    return cont;
}

- (void)loadView {
    NSView *aView = [[NSView alloc] init];
    self.view = aView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFrameSize];
    [self drawTree];
    using namespace std;
    
 
}

- (void)setupFrameSize {
    int unitNum = (int)pow(2, _height-1);
    CGFloat totalWidth = UnitSize*unitNum + SepaWidth*(unitNum+1);
    if (totalWidth > ScreenWidth)
        totalWidth = ScreenWidth;
    self.view.frame = CGRectMake(ScreenWidth/2-totalWidth/2, 80, totalWidth, ScreenHeigh-160);
}

- (void)drawTree {
    if (!_tree) {
        NSLog(@"Not Initialized");
        return;
    }
    TreePanel *p = [TreePanel panelWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Legs:nil];
    [self.view addSubview:p];
    CGPoint *locations = [self getLocations];
    
    
    NSMutableSet *buttonSet = [[NSMutableSet alloc] init]; //装的是 内部节点的 locations
    NSMutableSet *legSet = [[NSMutableSet alloc] init]; //装的是 leg struct
    [_tree enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = obj;
        int len = (int)(str.length), result = 0;
        for (int i = 0; i < len; i++) {
            
        //    [buttonSet addObject:locations[result]];
            if ([str characterAtIndex:i] == HFMLEFTPATH_OC) {
                result = result*2 + 1;
            } else
                result = result*2 + 2;
        }
        
        
        NSButton *but = [NSButton huffmanButtonWithLoca:locations[[self transformFromPath:obj]] andElement:key];
        [p addSubview:but];
    }];
    
    free(locations);
    
}

- (int)transformFromPath:(NSString *)str {
    
    int len = (int)str.length, result = 0;
    for (int i = 0; i < len; i++) {
        //NSMutableSet *mSet = [[NSMutableSet alloc] init];
        if ([str characterAtIndex:i] == HFMLEFTPATH_OC) {
            result = result*2 + 1;
        } else
            result = result*2 + 2;
    }
    return result;
}

- (CGPoint *)getLocations {
    int c = pow(2, _height)-1;
    CGPoint *points = (CGPoint *)malloc(c*sizeof(CGPoint));
    //最底层单独确定位置
    int s = pow(2, _height-1) - 1;
    CGFloat bottom = 15;
    for (int i = s; i <= 2*s; i++) {
        points[i] = CGPointMake((i-s+1)*SepaWidth+(i-s)*UnitSize, bottom);
    }
    
    //其余层靠子树确定位置
    for (int i = _height-2; i >= 0; i--) {
        int s = pow(2, i) - 1;
        for (int j = s; j <= 2*s; j++) {
            int point1Idx = 2*j+1;
            CGFloat x1 = points[point1Idx].x + UnitSize;
            CGFloat bian = points[point1Idx+1].x - x1;
            CGFloat x2 = x1 + bian/2 - UnitSize/2;
            CGFloat y2;
            if (j == s) {
                y2 = points[point1Idx].y + UnitSize + bian*cos(30);
            } else
                y2 = points[j-1].y;
            points[j] = CGPointMake(x2, y2);
        }
        
    }
    return points;
}


//- (void)drawTree {
//    CGPoint starter = CGPointMake(self.view.frame.size.width/2-LegWidth-TextSizeW/2, self.view.frame.size.height-80);
//    _root = [ELHuffmanUnit huffmanUnitWithLocation:starter value:@Zero_Sign andLevel:0];
//    [self.view addSubview:_root];
//
//    __weak typeof(self) weakSelf = self;
//    [_tree enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSString *str = obj;
//        int len = (int)str.length;
//        ELHuffmanUnit *rootTemp = weakSelf.root;
//        int curLevel = 0;
//        for (; curLevel < len-1; curLevel++) {
//            if (HFMLEFTPATH_OC == [str characterAtIndex:curLevel]) {
//                if (!rootTemp.leftChild) {
//                    CGFloat curRate = pow(RADIX, curLevel+1);
//                    CGPoint tempPoint = CGPointMake(rootTemp.frame.origin.x-TextSizeW-LegWidth*curRate, rootTemp.frame.origin.y-TextSizeH-LegHeight*curRate);
//                    rootTemp.leftChild = [ELHuffmanUnit huffmanUnitWithLocation:tempPoint value:@Zero_Sign andLevel:curLevel+1];
//                    [weakSelf.view addSubview:rootTemp.leftChild];
//                }
//                [rootTemp setLegsWithLeft:1 right:0];
//                rootTemp = rootTemp.leftChild;
//            } else {
//                if (!rootTemp.rightChild) {
//                    CGFloat curRate = pow(RADIX, curLevel+1);
//                    CGPoint tempPoint = CGPointMake(rootTemp.frame.origin.x+rootTemp.frame.size.width-LegWidth*curRate, rootTemp.frame.origin.y-TextSizeH-LegHeight*curRate);
//                    rootTemp.rightChild = [ELHuffmanUnit huffmanUnitWithLocation:tempPoint value:@Zero_Sign andLevel:curLevel+1];
//                    [weakSelf.view addSubview:rootTemp.rightChild];
//                }
//                [rootTemp setLegsWithLeft:0 right:1];
//                rootTemp = rootTemp.rightChild;
//            }
//        }
//
//        if (HFMLEFTPATH_OC == [str characterAtIndex:curLevel]) {
//            [rootTemp setLegsWithLeft:1 right:0];
//            NSText *aText = [NSText huffmanUnitWithLocation:CGPointMake(rootTemp.frame.origin.x-TextSizeW, rootTemp.frame.origin.y-TextSizeH) andElement:key];
//            [weakSelf.view addSubview:aText];
//        } else {
//            [rootTemp setLegsWithLeft:0 right:1];
//            NSText *aText = [NSText huffmanUnitWithLocation:CGPointMake(rootTemp.frame.origin.x+rootTemp.frame.size.width, rootTemp.frame.origin.y-TextSizeH) andElement:key];
//            [weakSelf.view addSubview:aText];
//        }
//
//    }];
//
//}

@end
