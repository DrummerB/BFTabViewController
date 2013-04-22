//
//  EmptyViewLabel.m
//  EmptyViewLabel
//
//  Created by Balázs Faludi on 12.07.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import "EmptyViewLabel.h"

#define kEmptyViewLabelSideMargin 15.0f
#define kEmptyViewLabelTopMargin -4.0f
#define kEmptyViewLabelHeight 27.0f

@implementation EmptyViewLabel

@synthesize title = _title;

#pragma mark -
#pragma mark Convenience Methods

- (NSDictionary *)textAttributes {
	NSColor* fontColor = [NSColor colorWithCalibratedRed: 0.9 green: 0.9 blue: 0.9 alpha: 1];
	
	NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	[textStyle setAlignment: NSCenterTextAlignment];
	
	NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize:13],
										NSForegroundColorAttributeName: fontColor,
										NSParagraphStyleAttributeName: textStyle};
	return textFontAttributes;
}

- (void)updateFrame {
	if (!self.superview) return;
	NSSize size = [_title sizeWithAttributes:[self textAttributes]];
	size = NSMakeSize(size.width + 2 * kEmptyViewLabelSideMargin, kEmptyViewLabelHeight);
	NSPoint center = NSMakePoint(self.superview.bounds.size.width / 2.0f, self.superview.bounds.size.height / 2.0f);
	NSRect rect = NSMakeRect(roundf(center.x - size.width / 2.0f), roundf(center.y - size.height / 2.0f), roundf(size.width), roundf(size.height));
	self.frame = rect;
}

- (void)awakeFromNib {
	[self updateFrame];
}

//- (void)removeFromSuperview {
//	// Don't remove it.
//}
//
//- (void)removeFromSuperviewWithoutNeedingDisplay {
//	// Don't remove it.
//}

- (void)viewDidMoveToSuperview {
	[self updateFrame];
}

#pragma mark -
#pragma mark Initialization & Destruction

- (void)setup {
	self.title = @"No Caption";
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
		self.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
		self.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin;
    }
    return self;
}


#pragma mark -
#pragma mark Getters & Setters

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[self setNeedsDisplay:YES];
}

- (void)setTitle:(NSString *)title {
	if (_title != title) {
		_title = title;
		[self updateFrame];
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
	//// Abstracted Graphic Attributes
	NSRect roundedRectangleRect = self.bounds;
	NSRect textRect = NSMakeRect(0.0f, kEmptyViewLabelTopMargin, self.bounds.size.width, self.bounds.size.height);
	NSString* textContent = _title;
	
	//// Color Declarations
	NSColor* fillColor = [NSColor colorWithCalibratedRed: 0.52 green: 0.52 blue: 0.52 alpha: 1];
	NSColor* innerShadowColor = [NSColor colorWithCalibratedRed: 0.52 green: 0.52 blue: 0.52 alpha: 1];
	NSColor* outerShadowColor = [NSColor colorWithCalibratedRed: 0.99 green: 0.99 blue: 0.99 alpha: 1];
	NSColor* fontShadowColor = [NSColor colorWithCalibratedRed: 0.55 green: 0.55 blue: 0.55 alpha: 1];
	
	//// Shadow Declarations
	NSShadow* innerShadow = [[NSShadow alloc] init];
	[innerShadow setShadowColor: innerShadowColor];
	[innerShadow setShadowOffset: NSMakeSize(0, -1)];
	[innerShadow setShadowBlurRadius: 0];
	NSShadow* outerShadow = [[NSShadow alloc] init];
	[outerShadow setShadowColor: outerShadowColor];
	[outerShadow setShadowOffset: NSMakeSize(0, -1)];
	[outerShadow setShadowBlurRadius: 0];
	NSShadow* fontShadow = [[NSShadow alloc] init];
	[fontShadow setShadowColor: fontShadowColor];
	[fontShadow setShadowOffset: NSMakeSize(0, -1)];
	[fontShadow setShadowBlurRadius: 0];
	
	//// Rounded Rectangle Drawing
	NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: roundedRectangleRect xRadius: 6 yRadius: 6];
	[NSGraphicsContext saveGraphicsState];
	[outerShadow set];
	[fillColor setFill];
	[roundedRectanglePath fill];
	
	////// Rounded Rectangle Inner Shadow
	NSRect roundedRectangleBorderRect = NSInsetRect([roundedRectanglePath bounds], -innerShadow.shadowBlurRadius, -innerShadow.shadowBlurRadius);
	roundedRectangleBorderRect = NSOffsetRect(roundedRectangleBorderRect, -innerShadow.shadowOffset.width, -innerShadow.shadowOffset.height);
	roundedRectangleBorderRect = NSInsetRect(NSUnionRect(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
	
	NSBezierPath* roundedRectangleNegativePath = [NSBezierPath bezierPathWithRect: roundedRectangleBorderRect];
	[roundedRectangleNegativePath appendBezierPath: roundedRectanglePath];
	[roundedRectangleNegativePath setWindingRule: NSEvenOddWindingRule];
	
	[NSGraphicsContext saveGraphicsState];
	{
		NSShadow* innerShadowWithOffset = [innerShadow copy];
		CGFloat xOffset = innerShadowWithOffset.shadowOffset.width + round(roundedRectangleBorderRect.size.width);
		CGFloat yOffset = innerShadowWithOffset.shadowOffset.height;
		innerShadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
		[innerShadowWithOffset set];
		[[NSColor grayColor] setFill];
		[roundedRectanglePath addClip];
		NSAffineTransform* transform = [NSAffineTransform transform];
		[transform translateXBy: -round(roundedRectangleBorderRect.size.width) yBy: 0];
		[[transform transformBezierPath: roundedRectangleNegativePath] fill];
	}
	[NSGraphicsContext restoreGraphicsState];
	
	[NSGraphicsContext restoreGraphicsState];
	
	
	
	//// Text Drawing
	[NSGraphicsContext saveGraphicsState];
	[fontShadow set];
	[textContent drawInRect: textRect withAttributes:[self textAttributes]];
	[NSGraphicsContext restoreGraphicsState];
	
	//// Cleanup

}

@end
