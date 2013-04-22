//
//  IconTabBar.m
//  CocosGame
//
//  Created by Balázs Faludi on 20.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import "BFTabBar.h"
#import "NSImage+CEEditor.h"


#define kHorizonalMargin 0.1	// relative (0-1)
#define kVerticalMargin 0.2	// relative (0-1)

@implementation BFTabBar {
	NSMutableIndexSet *_selectedIndexes;
	BFTabBarItem *_pressedItem;
	BOOL _firstItemWasSelected;
}

@synthesize items = _items;

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		_itemWidth = 32.0f;
		_multipleSelection = NO;
		_iconScaleMode = BFTabBarScaleProportionallyDown;
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
		
    }
    
    return self;
}

#pragma mark -
#pragma mark Convenience Methods

// x coordinate of the first item.
- (CGFloat)startX {
	NSUInteger itemCount = [_items count];
	CGFloat totalWidth = itemCount * _itemWidth;
	CGFloat startX = (self.bounds.size.width - totalWidth) / 2.0f;
	return startX;
}

- (BFTabBarItem *)itemAtX:(CGFloat)x {
	int index = floorf((x - [self startX]) / _itemWidth);
	if (index >= 0 && index < [_items count]) {
		return [_items objectAtIndex:index];
	}
	return nil;
}

#pragma mark -
#pragma mark Getters & Setters

- (NSMutableArray *)items {
	if (!_items) {
		_items = [NSMutableArray arrayWithCapacity:3];
	}
	return _items;
}

- (void)setItems:(NSArray *)newItems {
	if (newItems != _items) {
		_items = [NSMutableArray arrayWithArray:newItems];
		
		for (BFTabBarItem *item in _items) {
			item.tabBar = self;
		}
		
		if ([_selectedIndexes count] < 1) {
			[_selectedIndexes addIndex:0];
		}
		
		[self setNeedsDisplay];
	}
}

- (void)setIconScaleMode:(BFTabBarScale)iconScaleMode {
	if (_iconScaleMode != iconScaleMode) {
		_iconScaleMode = iconScaleMode;
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -
#pragma mark Selection

- (BFTabBarItem *)selectedItem {
	if ([_selectedIndexes count] > 0) {
		return [_items objectAtIndex:[_selectedIndexes firstIndex]];
	}
	return nil;
}

- (NSInteger)selectedIndex {
	return [_selectedIndexes count] < 1 ? -1 : [_selectedIndexes firstIndex];
}

- (NSArray *)selectedItems {
	if ([_selectedIndexes count] > 0) {
		return [_items objectsAtIndexes:_selectedIndexes];
	}
	return nil;
}

- (NSIndexSet *)selectedIndexes {
	return [[NSIndexSet alloc] initWithIndexSet:_selectedIndexes];
}

- (void)setMultipleSelection:(BOOL)multiple {
	if (multiple != _multipleSelection) {
		_multipleSelection = multiple;
		if (!_multipleSelection && [_selectedIndexes count] > 1) {
			NSUInteger firstIndex = [_selectedIndexes firstIndex];
			[_selectedIndexes removeAllIndexes];
			[_selectedIndexes addIndex:firstIndex];
			[self setNeedsDisplay];
		}
	}
}

- (void)selectIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extending {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Selection indexset empty.");
		return;
	}
	if (!extending || !_multipleSelection) {
		[self deselectAll];
	}
	if (_multipleSelection) {
		[_selectedIndexes addIndexes:indexes];
	} else {
		[_selectedIndexes addIndex:[indexes firstIndex]];
	}
	[self setNeedsDisplay];
}

- (void)selectIndex:(NSUInteger)index {
	[self selectIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:YES];
}

- (void)selectItem:(BFTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self selectIndex:index];
	}
}

- (IBAction)selectAll {
	[_selectedIndexes addIndexesInRange:(NSRange){0, [_items count] - 1}];
	[self setNeedsDisplay];
}

- (void)deselectIndexes:(NSIndexSet *)indexes {
	if (!indexes || [indexes count] < 1) {
		NSLog(@"Deselection indexset empty.");
		return;
	}
	[_selectedIndexes removeIndexes:indexes];
	[self setNeedsDisplay];
}

- (void)deselectIndex:(NSUInteger)index {
	[self deselectIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deselectItem:(BFTabBarItem *)item {
	if ([_items containsObject:item]) {
		NSUInteger index = [_items indexOfObject:item];
		[self deselectIndex:index];
	}
}

- (IBAction)deselectAll {
	[_selectedIndexes removeAllIndexes];
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Status

- (void)viewDidMoveToWindow {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowStateChanged:)
												 name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowStateChanged:)
												 name:NSWindowDidResignMainNotification object:nil];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
	if (self.window) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignMainNotification object:nil];
	}
}

- (void)windowStateChanged:(NSNotification *)notification {
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{

	//--------------------------
	// DRAW BACKGROUND GRADIENT
	//--------------------------
	
	//// Color Declarations
	NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.83 green: 0.83 blue: 0.83 alpha: 1];
	NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 0.68 green: 0.68 blue: 0.68 alpha: 1];
	NSColor* lineColor = [NSColor colorWithCalibratedRed:0.333 green:0.333 blue:0.333 alpha:1.000];
	
	if (![[self window] isMainWindow])
	{
		gradientColor = [NSColor colorWithCalibratedRed:0.961 green:0.961 blue:0.961 alpha:1.000];
		gradientColor2 = [NSColor colorWithCalibratedRed:0.855 green:0.855 blue:0.855 alpha:1.000];
		lineColor = [NSColor colorWithCalibratedRed:0.502 green:0.502 blue:0.502 alpha:1.000];
	}
	
	//// Gradient Declarations
	NSGradient* gradient = [[NSGradient alloc] initWithStartingColor: gradientColor endingColor: gradientColor2];
	
	//// Abstracted Graphic Attributes
	NSRect rectangleFrame = self.bounds;
	
	//// Rectangle Drawing
	NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: rectangleFrame];
	[gradient drawInBezierPath: rectanglePath angle: -90];
	
	//// Cleanup


	//------------------
	// DRAW BUTTON ITEMS
	//------------------
	
	//// Prepare selection border gradients.
	
	//// Color Declarations
	NSColor* gradientOutsideTop = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
	NSColor* gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.37 alpha:1.0];
	NSColor* gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.59 alpha:1.0];
	NSColor* gradientInsideTop = gradientColor;
	NSColor* gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.59 alpha:1.0];
	NSColor* gradientInsideBottom = gradientColor2;
	NSColor* selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.67 alpha:1.0];
	
	if (![self.window isMainWindow]) {
		gradientOutsideTop = [NSColor colorWithDeviceWhite:0.83 alpha:1.0];
		gradientOutsideMiddle = [NSColor colorWithDeviceWhite:0.43 alpha:1.0];
		gradientOutsideBottom = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		gradientInsideMiddle = [NSColor colorWithDeviceWhite:0.71 alpha:1.0];
		selectionGradientMiddle = [NSColor colorWithDeviceWhite:0.79 alpha:1.0];
	}
	
	NSGradient* selectionGradient = [[NSGradient alloc] initWithColorsAndLocations: 
									 gradientColor, 0.0, 
									 selectionGradientMiddle, 0.50, 
									 gradientColor2, 1.0, nil];
	NSGradient* gradientOutside = [[NSGradient alloc] initWithColorsAndLocations: 
								   gradientOutsideTop, 0.0, 
								   gradientOutsideMiddle, 0.50, 
								   gradientOutsideBottom, 1.0, nil];
	NSGradient* gradientInside = [[NSGradient alloc] initWithColorsAndLocations: 
								  gradientInsideTop, 0.0, 
								  gradientInsideMiddle, 0.50, 
								  gradientInsideBottom, 1.0, nil];
	
	
	CGFloat startX = [self startX];
	[self removeAllToolTips];
	
	for (int i = 0; i < [_items count]; i++) {
		BFTabBarItem *item = [_items objectAtIndex:i];
		CGFloat currentX = startX + i * _itemWidth;
		
		// Add tooltip area.
		NSRect selectionFrame = NSMakeRect(floorf(currentX + 0.5), 0, _itemWidth, self.bounds.size.height);
		[self addToolTipRect:selectionFrame owner:item.tooltip userData:nil];
		
		if ([_selectedIndexes containsIndex:i]) {
			
			//// Draw selection gradients
			NSRect outsideLineFrameLeft = NSMakeRect(floorf(currentX + 0.5), 1, 1, 21);
			NSRect insideLineFrameLeft = NSMakeRect(floorf(currentX + 1.5), 1, 1, 21);
			NSRect outsideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth + 0.5), 1, 1, 21);
			NSRect insideLineFrameRight = NSMakeRect(floorf(currentX + _itemWidth - 0.5), 1, 1, 21);
			
			NSBezierPath* selectionFramePath = [NSBezierPath bezierPathWithRect: selectionFrame];
			[selectionGradient drawInBezierPath: selectionFramePath angle: -90];
			
			NSBezierPath* outsideLinePathLeft = [NSBezierPath bezierPathWithRect: outsideLineFrameLeft];
			[gradientOutside drawInBezierPath: outsideLinePathLeft angle: -90];
			
			NSBezierPath* insideLinePathLeft = [NSBezierPath bezierPathWithRect: insideLineFrameLeft];
			[gradientInside drawInBezierPath: insideLinePathLeft angle: -90];
			
			NSBezierPath* outsideLinePathRight = [NSBezierPath bezierPathWithRect: outsideLineFrameRight];
			[gradientOutside drawInBezierPath: outsideLinePathRight angle: -90];
			
			NSBezierPath* insideLinePathRight = [NSBezierPath bezierPathWithRect: insideLineFrameRight];
			[gradientInside drawInBezierPath: insideLinePathRight angle: -90];
		}
		
		// Draw icon
		CGPoint center = CGPointMake(currentX + _itemWidth / 2.0f, self.bounds.size.height / 2.0f);
		
		EmbossState state = [self.window isMainWindow] ? EmbossStateDefault : EmbossStateInactive;
		if (item == _pressedItem) {
			state = EmbossStatePressed;
		}
		NSImage *embossedImage = [item.icon imageWithEmbossState:state];
		
		if (_iconScaleMode != BFTabBarScaleNone) {
			CGFloat maxWidth = _itemWidth - 2 * kHorizonalMargin * _itemWidth;
			CGFloat maxHeight = self.bounds.size.height - 2 * kVerticalMargin * self.bounds.size.height;
			CGFloat hRatio = maxWidth / embossedImage.size.width;
			CGFloat vRatio = maxHeight / embossedImage.size.height;
			CGFloat ratio = MIN(hRatio, vRatio);
			if (_iconScaleMode == BFTabBarScaleProportionallyDown)
				ratio = MIN(1.0f, ratio);
			embossedImage.size = NSMakeSize(embossedImage.size.width * ratio, embossedImage.size.height * ratio);
		}
		[embossedImage drawAtCenter:center fromRect:embossedImage.bounds operation:NSCompositeSourceOver fraction:1.0f];
	}
	
	
	
	//// Line Drawing
	NSBezierPath* line1 = [NSBezierPath bezierPath];
	[line1 moveToPoint: NSMakePoint(0.0, 0.5)];
	[line1 lineToPoint: NSMakePoint(self.bounds.size.width, 0.5)];
	[lineColor setStroke];
	[line1 setLineWidth: 1];
	[line1 stroke];
	
	//// Line Drawing
	NSBezierPath* line2 = [NSBezierPath bezierPath];
	[line2 moveToPoint: NSMakePoint(0.0, self.bounds.size.height - 0.5)];
	[line2 lineToPoint: NSMakePoint(self.bounds.size.width, self.bounds.size.height - 0.5)];
	[lineColor setStroke];
	[line2 setLineWidth: 1];
	[line2 stroke];
}

#pragma mark -
#pragma mark Events

- (void)notify {
	[NSApp sendAction:[self action] to:[self target] from:self];
	if ([_delegate respondsToSelector:@selector(tabBarChangedSelection:)]) {
		[_delegate tabBarChangedSelection:self];
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	BFTabBarItem *item = [self itemAtX:point.x];
	if (item) {
		_pressedItem = item;
		if (_multipleSelection) {
			// Remember if the first clicked item was selected or deselected. Dragging onto other items will do the same operation, if multipleSelection is enabled.
			_firstItemWasSelected = ![[self selectedItems] containsObject:_pressedItem];
			if (_firstItemWasSelected) {
				[self selectItem:_pressedItem];
			} else {
				[self deselectItem:_pressedItem];
			}
		} else {
			[self selectItem:_pressedItem];
		}
		[self notify];
		[self setNeedsDisplay];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	[super mouseDragged:theEvent];
	CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	BFTabBarItem *item = [self itemAtX:point.x];
	if (item != _pressedItem) {
		_pressedItem = item;
		if (_multipleSelection && !_firstItemWasSelected) {
			[self deselectItem:_pressedItem];
		} else {
			[self selectItem:_pressedItem];
		}
		[self notify];
		[self setNeedsDisplay];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	[super mouseUp:theEvent];
	_pressedItem = nil;
	[self setNeedsDisplay];
}

//- (BOOL)needsPanelToBecomeKey {
//	return YES;
//}
//
//- (BOOL)acceptsFirstResponder {
//	return YES;
//}

@end

#pragma mark -
#pragma mark -

@implementation BFTabBarItem

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
    self = [super init];
    if (self) {
        self.icon = image;
		self.tooltip = tooltipString;
    }
    return self;
}

+ (BFTabBarItem *)itemWithIcon:(NSImage *)image tooltip:(NSString *)tooltipString {
	return [[BFTabBarItem alloc] initWithIcon:image tooltip:tooltipString];
}


#pragma mark -
#pragma mark Getters & Setters

- (void)setIcon:(NSImage *)newIcon {
	if (newIcon != _icon) {
		_icon = newIcon;
		
		[_tabBar setNeedsDisplay];
	}
}

@end





