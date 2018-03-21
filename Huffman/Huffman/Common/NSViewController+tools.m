//
//  NSViewController+tools.m
//  Huffman
//
//  Created by Eric on 03/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "NSViewController+tools.h"

@implementation NSViewController (tools)

- (void)selectPathIsDirAllowed:(BOOL)dirAllowed multiSelect:(BOOL)multiAllowed successHandler:(void (^) (NSArray *))handler {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
     panel.canCreateDirectories = 0;
    panel.canChooseDirectories = dirAllowed;
    panel.canChooseFiles = 1;
    [panel setAllowsMultipleSelection:multiAllowed];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result)
            handler(panel.URLs);
    }];
    
}

- (void)presentAlertWithMsg:(NSString *)msg {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = @"选取失败";
    alert.informativeText = msg;
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
    
}

@end
