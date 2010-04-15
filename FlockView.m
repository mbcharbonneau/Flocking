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

#define SCALE 0.04f
#define BOID_WIDTH 3.0f

@implementation FlockView

#pragma mark FlockView Methods

@synthesize flock = _flock;

- (void)drawRect:(NSRect)dirtyRect;
{
	NSColor *color = [NSColor alternateSelectedControlColor];
	[color set];
	
	for ( Boid *boid in self.flock.boids )
	{
		CGFloat x = boid.position.x * SCALE;
		CGFloat y = boid.position.y * SCALE;
		NSRectFill( NSMakeRect( x, y, BOID_WIDTH, BOID_WIDTH ) );
	}
}

#pragma mark NSResponder Overrides

- (void)mouseDown:(NSEvent *)theEvent;
{
	[self.flock scatterFlock];
}

@end
