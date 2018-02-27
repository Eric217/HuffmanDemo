//
//  MainViewController.m
//  Huffman
//
//  Created by Eric on 27/02/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CGFloat wid = self.view.bounds.size.width;
    CGFloat hei = self.view.bounds.size.height;

    _button = [[NSButton alloc] initWithFrame:NSMakeRect(wid/4, hei/4, wid/2, hei/2)];
    
    [self.view addSubview:_button];
    [_button setTitle:@"click Me"];
    [_button setImage:[NSImage imageNamed:@"testButton"]];
 
    [_button setImageScaling:NSImageScaleAxesIndependently];
}

@end
