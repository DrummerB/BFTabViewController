//
//  EmptyViewLabel.h
//  EmptyViewLabel
//
//  Created by Balázs Faludi on 12.07.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EmptyViewLabel : NSView {
	NSString *_title;
}

@property (nonatomic, copy) NSString *title;
@property (unsafe_unretained, nonatomic, readonly) NSDictionary *textAttributes;

@end
