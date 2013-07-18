//
//  BFTabViewController.m
//  BFTabViewController
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabViewController.h"
#import "BFTabBar.h"

#define kTabBarHeight 23.0f

@implementation BFTabViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
	NSRect tempRect = NSMakeRect(0.0f, 0.0f, 50.0f, 50.0f);
	NSView *view = [[NSView alloc] initWithFrame:tempRect];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	
	NSRect barRect = NSMakeRect(0.0f, tempRect.size.height - kTabBarHeight,
								tempRect.size.width, kTabBarHeight);
	_tabBar = [[BFTabBar alloc] initWithFrame:barRect];
	_tabBar.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	_tabBar.delegate = self;
	[view addSubview:_tabBar];
	[self gatherTabBarItems];
	
	self.view = view;
}

- (void)presentViewController:(NSViewController *)viewController {
	NSRect rect = NSMakeRect(0.0f, 0.0f, self.view.bounds.size.width,
							 self.view.bounds.size.height - _tabBar.frame.size.height);
	viewController.view.frame = rect;
	viewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	
	if ([viewController respondsToSelector:@selector(viewWillAppear)]) {
		[viewController performSelector:@selector(viewWillAppear)];
	}
	[self.view addSubview:viewController.view];
	if ([viewController respondsToSelector:@selector(viewDidAppear)]) {
		[viewController performSelector:@selector(viewDidAppear)];
	}
}

- (void)disposeViewController:(NSViewController *)viewController {
	if ([viewController respondsToSelector:@selector(viewWillDisappear)]) {
		[viewController performSelector:@selector(viewWillDisappear)];
	}
	[viewController.view removeFromSuperview];
	if ([viewController respondsToSelector:@selector(viewDidDisappear)]) {
		[viewController performSelector:@selector(viewDidDisappear)];
	}
}

- (void)gatherTabBarItems {
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:_viewControllers.count];
	for (NSViewController *viewController in _viewControllers) {
		if ([viewController respondsToSelector:@selector(tabBarItem)]) {
			BFTabBarItem *item = [viewController performSelector:@selector(tabBarItem)];
			[items addObject:item];
		} else {
			BFTabBarItem *item = [[BFTabBarItem alloc] initWithIcon:nil tooltip:viewController.title];
			[items addObject:item];
			NSLog(@"View controller doesn't implement tabBarItem.");
		}
	}
	[_tabBar setItems:items];
}

- (void)setViewControllers:(NSArray *)viewControllers {
	if (_viewControllers != viewControllers) {
		_viewControllers = viewControllers;
		
		[_selectedViewController.view removeFromSuperview];
		
		[self gatherTabBarItems];
		
		self.selectedIndex = --_selectedIndex + 1;
	}
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	if (_selectedIndex != selectedIndex) {
		if (selectedIndex >= 0 && selectedIndex < _viewControllers.count) {
			self.selectedViewController = [_viewControllers objectAtIndex:selectedIndex];
		}
	}
}

- (void)setSelectedViewController:(NSViewController *)selectedViewController {
	if (_selectedViewController != selectedViewController) {
		NSInteger index = [_viewControllers indexOfObject:selectedViewController];
		if (index != NSNotFound) {
			[self disposeViewController:_selectedViewController];
			_selectedViewController = selectedViewController;
			_selectedIndex = index;
			[self presentViewController:_selectedViewController];
		}
	}
}

- (void)tabBarChangedSelection:(BFTabBar *)tabbar {
	self.selectedIndex = tabbar.selectedIndex;
}

@end
