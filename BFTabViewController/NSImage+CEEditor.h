//
//  NSImage+CEEditor.h
//  CocosGame
//
//  Created by Balázs Faludi on 04.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (CEEditor)

typedef enum EmbossState {
	EmbossStateNormal = 0,
	EmbossStateInactive,
	EmbossStatePressed,
	EmbossStateDefault = EmbossStateNormal,
} EmbossState;

- (NSImage *)smoothResize:(CGSize)newSize;
- (CGRect)bounds;
- (void)drawAtCenter:(NSPoint)point fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

- (void)drawEmbossedInRect:(NSRect)rect state:(EmbossState)state;
- (NSImage *)imageWithEmbossState:(EmbossState)state;

@end
