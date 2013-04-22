//
//  AppDelegate.m
//  Demo
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "AppDelegate.h"
#import "BFTabViewController.h"
#import "MyViewController.h"
#import "BFTabBar.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSArray *titles = @[@"Bear View", @"Alien View", @"Viking View", @"Genie View"];
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:titles.count];
	for (int i = 0; i < titles.count; i++) {
		NSString *imageName = [NSString stringWithFormat:@"icon%d.png", i+1];
		NSImage *image = [NSImage imageNamed:imageName];
		BFTabBarItem *item = [[BFTabBarItem alloc] initWithIcon:image tooltip:titles[i]];
		MyViewController *viewController = [[MyViewController alloc] initWithTabBarItem:item];
		[viewControllers addObject:viewController];
	}
	
	NSRect frame = ((NSView *)self.window.contentView).bounds;
	frame.size.height++;
	_tabController = [[BFTabViewController alloc] init];
	_tabController.view.frame = frame;
	_tabController.viewControllers = viewControllers;
	
	[self.window.contentView addSubview:_tabController.view];
	
}

@end
