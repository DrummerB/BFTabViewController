//
//  MyViewController.m
//  Demo
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "MyViewController.h"
#import "EmptyViewLabel.h"
#import "BFTabBar.h"

@implementation MyViewController

- (id)initWithTabBarItem:(BFTabBarItem *)tabBarItem
{
    self = [super init];
    if (self) {
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)loadView {
	NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 10000, 10000)];
	EmptyViewLabel *label = [[EmptyViewLabel alloc] init];
	label.title = _tabBarItem.tooltip;
	[view addSubview:label];
	self.view = view;
}

@end
