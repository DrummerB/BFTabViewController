//
//  IconTabBar.h
//  CocosGame
//
//  Created by Balázs Faludi on 20.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, BFTabBarScale) {
	BFTabBarScaleNone,
	BFTabBarScaleProportionallyDown,
	BFTabBarScaleProportionallyUpOrDown
};

@class BFTabBarItem;
@class BFTabBar;

@protocol BFTabBarDelegate <NSObject>

- (void)tabBarChangedSelection:(BFTabBar *)tabbar;

@end


@interface BFTabBar : NSControl

@property (nonatomic) NSMutableArray *items;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) BFTabBarScale iconScaleMode;
@property (nonatomic) BOOL multipleSelection;
@property (nonatomic, weak) IBOutlet NSObject<BFTabBarDelegate> *delegate;

- (BFTabBarItem *)selectedItem;
- (NSInteger)selectedIndex;
- (NSArray *)selectedItems;
- (NSIndexSet *)selectedIndexes;

- (IBAction)selectAll;
- (void)selectIndex:(NSUInteger)index;
- (void)selectItem:(BFTabBarItem *)item;
- (void)selectIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extending;

- (IBAction)deselectAll;
- (void)deselectIndex:(NSUInteger)index;
- (void)deselectIndexes:(NSIndexSet *)indexes;

@end


@interface BFTabBarItem : NSObject

@property (nonatomic, strong) NSImage *icon;
@property (nonatomic, copy) NSString *tooltip;
@property (nonatomic, weak) BFTabBar *tabBar;

- (id)initWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString;
+ (BFTabBarItem *)itemWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString;

@end