//
//  Predator.m
//  Flocking
//
//  Created by Marc Charbonneau on 4/15/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Predator.h"
#import "Flock.h"
#import "Boid.h"

#define PREDATOR_VELOCITY_MAX 5.0
#define PREDATOR_FLOCK_CENTER_FRACTION 100.0

NSPoint AddPoints( NSPoint p1, NSPoint p2 );

@interface Predator (Private)

- (Vector)flockCenter;
- (void)limitVelocity;

@end

@implementation Predator

#pragma mark Predator Methods

@synthesize flock = _flock;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;
{
	if ( self = [super initWithPosition:point] )
	{
		_flock = flock;
	}
	
	return self;
}

- (void)move;
{
	// Calculate new velocity.
	
	self.velocity = AddVector( self.velocity, [self flockCenter] );	
	[self limitVelocity];
	[super move];
}


@end

@implementation Predator (Private)

- (Vector)flockCenter;
{
	NSInteger count = [self.flock.boids count];
	NSPoint center = NSZeroPoint;
	
	for ( Boid *boid in self.flock.boids )
		center = AddPoints( center, boid.position );
	
	center.x = center.x / ( count - 1 );
	center.y = center.y / ( count - 1 );
	
	double x = ( center.x - self.position.x ) / PREDATOR_FLOCK_CENTER_FRACTION;
	double y = ( center.y - self.position.y ) / PREDATOR_FLOCK_CENTER_FRACTION;
	
	return MakeVector( x, y );
}

- (void)limitVelocity;
{
	if ( fabs( self.velocity.x ) > PREDATOR_VELOCITY_MAX )
	{
		Vector vector = self.velocity;
		vector.x = ( self.velocity.x / fabs( self.velocity.x ) ) * PREDATOR_VELOCITY_MAX;
		self.velocity = vector;
	}
	
	if ( fabs( self.velocity.y ) > PREDATOR_VELOCITY_MAX )
	{
		Vector vector = self.velocity;
		vector.y = ( self.velocity.y / fabs( self.velocity.y ) ) * PREDATOR_VELOCITY_MAX;
		self.velocity = vector;
	}
}

@end
