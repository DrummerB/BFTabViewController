//
//  AppDelegate.h
//  Demo
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BFTabViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) BFTabViewController *tabController;

@end
