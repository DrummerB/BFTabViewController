//
//  MyViewController.h
//  Demo
//
//  Created by Balázs Faludi on 22.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BFTabBarItem;

@interface MyViewController : NSViewController

@property (nonatomic) BFTabBarItem *tabBarItem;

- (id)initWithTabBarItem:(BFTabBarItem *)tabBarItem;

@end
