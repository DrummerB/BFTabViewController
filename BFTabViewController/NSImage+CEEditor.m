//
//  NSImage+CEEditor.m
//  CocosGame
//
//  Created by Balázs Faludi on 04.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import "NSImage+CEEditor.h"

@implementation NSImage (CEEditor)

- (NSImage *)smoothResize:(CGSize)newSize {

	NSImage *sourceImage = self;
	// Report an error if the source isn't a valid image 
	if (![sourceImage isValid]) {
		NSLog(@"Invalid Image");
	} else { 
		NSImage *smallImage;
		smallImage = [[NSImage alloc] initWithSize:newSize]; 
		[smallImage lockFocus]; 
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh]; 
		[sourceImage setSize:newSize]; 
		[sourceImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
		[smallImage unlockFocus];
		return smallImage;
	}
	return nil;
}

- (CGRect)bounds {
	return CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
}

- (void)drawAtCenter:(NSPoint)point fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta {
	CGPoint position = CGPointMake(roundf(point.x - self.size.width / 2.0f), roundf(point.y - self.size.height / 2.0f));
	[self drawAtPoint:position fromRect:fromRect operation:op fraction:delta];
}

- (NSImage *)imageWithEmbossState:(EmbossState)state {
	
	NSImage* image = [[NSImage alloc] initWithSize:self.size];
	[image lockFocus];
	
	[self drawEmbossedInRect:self.bounds state:state];
	
	[image unlockFocus];
	return image;
}

- (void)drawEmbossedInRect:(NSRect)rect state:(EmbossState)state
{
	NSColor *gradientTop;
	NSColor *gradientBottom;
	NSColor *dropShadow;
	NSColor *innerShadow;
	
	switch (state) {
		default:
		case EmbossStateNormal:
			gradientTop = [NSColor colorWithDeviceWhite:0.35 alpha:1.0];
			gradientBottom = [NSColor colorWithDeviceWhite:0.45 alpha:1.0];
			dropShadow = [NSColor colorWithDeviceWhite:0.87 alpha:1.0];
			innerShadow = [NSColor colorWithDeviceWhite:0.10 alpha:1.0];
			break;
		case EmbossStateInactive:
			gradientTop = [NSColor colorWithDeviceWhite:0.58 alpha:1.0];
			gradientBottom = [NSColor colorWithDeviceWhite:0.63 alpha:1.0];
			dropShadow = [NSColor colorWithDeviceWhite:0.87 alpha:1.0];
			innerShadow = [NSColor colorWithDeviceWhite:0.40 alpha:1.0];
			break;
		case EmbossStatePressed:
			gradientTop = [NSColor colorWithDeviceWhite:0.23 alpha:1.0];
			gradientBottom = [NSColor colorWithDeviceWhite:0.33 alpha:1.0];
			dropShadow = [NSColor colorWithDeviceWhite:0.83 alpha:1.0];
			innerShadow = [NSColor colorWithDeviceWhite:0.07 alpha:1.0];
			break;
	}
	
    NSSize size = rect.size;
    CGFloat dropShadowOffsetY = size.width <= 64.0 ? -1.0 : -2.0;
    CGFloat innerShadowBlurRadius = size.width <= 32.0 ? 1.0 : 4.0;
	
    CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
	
    //save the current graphics state
    CGContextSaveGState(c);
	
    //Create mask image:
    NSRect maskRect = rect;
    CGImageRef maskImage = [self CGImageForProposedRect:&maskRect context:[NSGraphicsContext currentContext] hints:nil];
	
    //Draw image and white drop shadow:
	CGColorRef dropShadowColor = [self copyCGColorFromColor:dropShadow];
    CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0, dropShadowColor);
    [self drawInRect:maskRect fromRect:NSMakeRect(0, 0, self.size.width, self.size.height) operation:NSCompositeSourceOver fraction:1.0];
	CGColorRelease(dropShadowColor);
	
    //Clip drawing to mask:
    CGContextClipToMask(c, NSRectToCGRect(maskRect), maskImage);
	
    //Draw gradient:
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:gradientTop
                                                          endingColor:gradientBottom];
    [gradient drawInRect:maskRect angle:90.0];
	CGColorRef innerShadowColor = [self copyCGColorFromColor:innerShadow];
    CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius, innerShadowColor);
	CGColorRelease(innerShadowColor);
	
    //Draw inner shadow with inverted mask:
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef maskContext = CGBitmapContextCreate(NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8,
													 CGImageGetWidth(maskImage) * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
    CGContextDrawImage(maskContext, maskRect, maskImage);
    CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(maskContext, maskRect);
    CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
    CGContextDrawImage(c, maskRect, invertedMaskImage);
    CGImageRelease(invertedMaskImage);
    CGContextRelease(maskContext);
	
    //restore the graphics state
    CGContextRestoreGState(c);
}

- (CGColorRef)copyCGColorFromColor:(NSColor *)color
{
	NSColor *colorRGB = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGFloat components[4];
	[colorRGB getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
	CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGColorRef theColor = CGColorCreate(theColorSpace, components);
	CGColorSpaceRelease(theColorSpace);
	return theColor;
}

@end
