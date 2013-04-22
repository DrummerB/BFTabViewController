//
//  BFTabViewController.h
//  BFTabViewController
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFTabBar.h"


@protocol BFTabViewControllerDelegate;

@interface BFTabViewController : NSViewController <BFTabBarDelegate>

@property (nonatomic) NSObject<BFTabViewControllerDelegate> *delegate;
@property (nonatomic) BFTabBar *tabBar;
@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, weak) NSViewController *selectedViewController;

@end


@protocol BFTabViewControllerDelegate <NSObject>

- (BOOL)tabBarController:(BFTabViewController *)tabBarController shouldSelectViewController:(NSViewController *)viewController;
- (void)tabBarController:(BFTabViewController *)tabBarController didSelectViewController:(NSViewController *)viewController;

@end
