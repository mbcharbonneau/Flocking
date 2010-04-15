//
//  FlockView.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "FlockView.h"
#import "Flock.h"
#import "Boid.h"

@implementation FlockView

#pragma mark FlockView Methods

@synthesize flock = _flock;

- (void)drawRect:(NSRect)dirtyRect;
{
	NSColor *color = [NSColor alternateSelectedControlColor];
	[color set];
	
	for ( Boid *boid in self.flock.boids )
	{
		CGFloat x = boid.position.x;
		CGFloat y = boid.position.y;
		NSRectFill( NSMakeRect( x, y, 2.0f, 2.0f ) );
	}
}

#pragma mark NSResponder Overrides


@end
