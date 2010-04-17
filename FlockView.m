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
#import "Constants.h"

#define BOID_WIDTH 2.0f
#define BORDER_WIDTH 40.0f

@implementation FlockView

#pragma mark FlockView Methods

@synthesize flock = _flock;

- (void)drawRect:(NSRect)dirtyRect;
{
	CGFloat scaleX = ( NSWidth( [self bounds] ) - BORDER_WIDTH * 2.0f ) / NSWidth( self.flock.bounds );
	CGFloat scaleY = ( NSHeight( [self bounds] ) - BORDER_WIDTH * 2.0f ) / NSHeight( self.flock.bounds );
	
	NSColor *boidColor = [NSColor blueColor];
	NSColor *deadBoidColor = [NSColor lightGrayColor];
	NSColor *predatorColor = [NSColor redColor];
	
	NSArray *gameObjects = [self.flock.boids arrayByAddingObjectsFromArray:self.flock.predators];
	
	for ( TwoDimensionalObject *object in gameObjects )
	{
		BOOL boid = [object isKindOfClass:[Boid class]];
		CGFloat x = object.position.x * scaleX + BORDER_WIDTH;
		CGFloat y = object.position.y * scaleY + BORDER_WIDTH;
		CGFloat width = ( boid ) ? BOID_WIDTH : BOID_WIDTH * 2.0;
		
		if ( [[NSUserDefaults standardUserDefaults] boolForKey:PresentationModeDefaultsKey] )
			width = width * 2.0;

		if ( !boid )
			[predatorColor set];
		else if ( ((Boid *)object).dead )
			[deadBoidColor set];
		else
			[boidColor set];
		
		NSRectFill( NSMakeRect( x, y, width, width ) );
	}
}

#pragma mark NSResponder Overrides

- (void)mouseDown:(NSEvent *)theEvent;
{
	[self.flock scatterFlock];
}

@end
