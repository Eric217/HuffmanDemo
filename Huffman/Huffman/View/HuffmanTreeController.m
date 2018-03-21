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
#import "LinkedSet.h"

@interface HuffmanTreeController ()
@property (strong) NSScrollView *scrollView;
@end

@implementation HuffmanTreeController

+ (HuffmanTreeController *)treeControllerWithDict:(NSDictionary *)dict treeHeight:(int)height {
    HuffmanTreeController *cont = [[HuffmanTreeController alloc] init];
    cont.tree = dict;
    cont.height = height;
    return cont;
}

- (void)loadView {
    self.view = [[NSView alloc] init];
}

//思路：高度为N的二叉树，其所有可能节点的位置存到数组。对字典中的霍夫曼树遍历，把存在的节点和树杈利用位置数组初始化并保存到集合中。遍历集合，显示视图。
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_tree) {
        NSLog(@"Not Initialized");
        return;
    }
    //MARK: - 确定各个frame
    CGPoint *locations = [self getLocations];
    CGFloat contentH = locations[0].y + UnitSize + 55;
    int unitNum = (int)pow(2, _height-1);
    CGFloat contentW = UnitSize*unitNum + SepaWidth*(unitNum+1);
    CGFloat w1, h1, colorSpace = 231.0/255;
    if (contentH < ScreenHeigh) {
        h1 = contentH;
    } else
        h1 = ScreenHeigh;
    if (contentW < ScreenWidth) {
        w1 = contentW;
    } else
        w1 = ScreenWidth;
    
    self.view.frame = CGRectMake(ScreenWidth/2-w1/2, ScreenHeigh/2-h1/2, w1, h1);
    _scrollView = [[NSScrollView alloc] initWithFrame:CGRectMake(0, 0, w1, h1)];
    [self.view addSubview:_scrollView];
    TreePanel *p = [[TreePanel alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    [p setWantsLayer:1];
    [p.layer setBackgroundColor:[NSColor colorWithRed:colorSpace green:colorSpace blue:colorSpace alpha:1].CGColor];
    _scrollView.documentView = p;
    
    //MARK: - 对树字典遍历
    LinkedSet *buttonSet = [[LinkedSet alloc] init]; //装的是内部节点在 locations中的位置
    LinkedSet *legSet = [[LinkedSet alloc] init]; //装的Line对象，特例化的集合内部已实现Line的不重复(为了省事。正常的应该写个 isEqual)
    
    [_tree enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = obj;
        int len = (int)(str.length), result = 0;
        for (int i = 0; i < len; i++) {
            [buttonSet pushWithData:result];
            CGPoint st = CGPointMake(locations[result].x+UnitSize/2, locations[result].y);
            if ([str characterAtIndex:i] == HFMLEFTPATH_OC) {
                result = result*2 + 1;
                CGPoint en = CGPointMake(locations[result].x+UnitSize, locations[result].y+UnitSize);
                Line *line = [Line lineWithStart:st end:en];
                [legSet pushWithLine:line];
                
            } else {
                result = result*2 + 2;
                CGPoint en = CGPointMake(locations[result].x, locations[result].y+UnitSize);
                Line *line = [Line lineWithStart:st end:en];
                [legSet pushWithLine:line];
            }
        }
        NSButton *but = [NSButton huffmanButtonWithLoca:locations[result] andElement:key];
        [p addSubview:but];
    }];
    
    //MARK: - 所有位置收集完毕，边交给drawRect，节点加子视图
    p.legs = legSet;
    [buttonSet enumeratDataWithBlock:^(int loca) {
        NSButton *but = [NSButton huffmanButtonWithLoca:locations[loca] andElement:@Zero_Sign];
        [p addSubview:but];
    }];
    free(locations);
    
    _scrollView.scrollerStyle = NSScrollerStyleOverlay;
    _scrollView.hasVerticalScroller = 1;
    _scrollView.hasHorizontalScroller = 1;
    //[_scrollView scrollToEndOfDocument:nil];
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
                y2 = points[point1Idx].y + UnitSize + bian*cos(HeightAngle);
            } else
                y2 = points[j-1].y;
            points[j] = CGPointMake(x2, y2);
        }
        
    }
    return points;
}

@end
