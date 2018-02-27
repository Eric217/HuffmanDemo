//
//  AppDelegate.m
//  Huffman
//
//  Created by Eric on 27/02/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) MainViewController *mainViewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [_window.contentView addSubview:_mainViewController.view];
    _mainViewController.view.frame = _window.contentView.bounds;
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
