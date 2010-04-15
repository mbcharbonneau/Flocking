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
#import "Predator.h"

#define BOID_WIDTH 2.0f

@implementation FlockView

#pragma mark FlockView Methods

@synthesize flock = _flock;

- (void)drawRect:(NSRect)dirtyRect;
{
	CGFloat scale = NSWidth( [self bounds] ) / NSWidth( self.flock.bounds );
	NSColor *color = [NSColor alternateSelectedControlColor];
	[color set];
	
	for ( Boid *boid in self.flock.boids )
	{
		CGFloat x = boid.position.x * scale;
		CGFloat y = boid.position.y * scale;
		NSRectFill( NSMakeRect( x, y, BOID_WIDTH, BOID_WIDTH ) );
	}
	
	[[NSColor redColor] set];
	CGFloat x = self.flock.predator.position.x * scale;
	CGFloat y = self.flock.predator.position.y * scale;
	NSRectFill( NSMakeRect( x, y, BOID_WIDTH * 2, BOID_WIDTH * 2 ) );
}

#pragma mark NSResponder Overrides

- (void)mouseDown:(NSEvent *)theEvent;
{
	[self.flock scatterFlock];
}

@end
