//
//  Boid.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Boid.h"
#import "Flock.h"
#import "Predator.h"

#define BOID_VELOCITY_MAX 30.0
#define BOID_MIN_DISTANCE 150.0
#define BOID_AVG_VELOCITY_FRACTION 8.0
#define BOID_FLOCK_CENTER_FRACTION 100.0
#define BOID_PREDATOR_DISTANCE 1000.0
#define RULE1_MULTIPLIER 1.0
#define RULE2_MULTIPLIER 1.0
#define RULE3_MULTIPLIER 1.0

double Distance( NSPoint p1, NSPoint p2 )
{
	double xDiff = p2.x - p1.x;
	double yDiff = p2.y - p1.y;
	
	return sqrt( xDiff * xDiff + yDiff * yDiff );
}

NSPoint AddPoints( NSPoint p1, NSPoint p2 )
{
	NSPoint result;
	result.x = p1.x + p2.x;
	result.y = p1.y + p2.y;
	return result;
}

@interface Boid (Private)

- (Vector)rule1;
- (Vector)rule2;
- (Vector)rule3;
- (Vector)boundsConstraint;
- (Vector)wind;
- (Vector)avoidPredator;
- (void)limitVelocity;

@end

@implementation Boid

#pragma mark Boid Methods

@synthesize flock = _flock;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;
{
	if ( self = [super initWithPosition:point] )
	{
		_flock = flock;
	}
	
	return self;
}

#pragma mark TwoDimensionalObject Overrides

- (void)move;
{
	// Calculate new velocity.
	
	Vector newVelocity = self.velocity;
	Vector rule1 = MultiplyVector( [self rule1], self.flock.isScattered ? RULE1_MULTIPLIER * -1.0 : RULE1_MULTIPLIER );
	Vector rule2 = MultiplyVector( [self rule2], RULE1_MULTIPLIER );
	Vector rule3 = MultiplyVector( [self rule3], RULE1_MULTIPLIER );
	
	newVelocity = AddVector( newVelocity, rule1 );
	newVelocity = AddVector( newVelocity, rule2 );
	newVelocity = AddVector( newVelocity, rule3 );
	newVelocity = AddVector( newVelocity, [self wind] );
	newVelocity = AddVector( newVelocity, [self boundsConstraint] );
	newVelocity = AddVector( newVelocity, [self avoidPredator] );
	
	self.velocity = newVelocity;
	
	[self limitVelocity];
	[super move];
}

@end

@implementation Boid (Private)

- (Vector)rule1;
{
	NSInteger count = [self.flock.boids count];
	NSPoint center = NSZeroPoint;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self )
			continue;
		
		center = AddPoints( center, boid.position );
	}
	
	center.x = center.x / ( count - 1 );
	center.y = center.y / ( count - 1 );
	
	double x = ( center.x - self.position.x ) / BOID_FLOCK_CENTER_FRACTION;
	double y = ( center.y - self.position.y ) / BOID_FLOCK_CENTER_FRACTION;
	
	return MakeVector( x, y );
}

- (Vector)rule2;
{
	Vector vector = ZeroVector;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self )
			continue;
		
		if ( fabs( Distance( self.position, boid.position ) ) <= BOID_MIN_DISTANCE )
		{
			vector.x = vector.x - ( boid.position.x - self.position.x );
			vector.y = vector.y - ( boid.position.y - self.position.y );
		}
	}
	
	return vector;
}

- (Vector)rule3;
{
	Vector vector = ZeroVector;
	
	// Average the velocity for all boids.
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self )
			continue;
		
		vector = AddVector( vector, boid.velocity );
	}
	
	vector.x = vector.x / ( [self.flock.boids count] - 1 );
	vector.y = vector.y / ( [self.flock.boids count] - 1 );
	
	// Return a fraction of the difference between the current and 
	// average velocity.
	
	vector.x = ( vector.x - self.velocity.x ) / BOID_AVG_VELOCITY_FRACTION;
	vector.y = ( vector.y - self.velocity.y ) / BOID_AVG_VELOCITY_FRACTION;
	
	return vector;
}

- (Vector)boundsConstraint;
{
	Vector velocity = ZeroVector;
	NSRect bouds = [self.flock bounds];
	
	// Check X bounds.
	
	if ( self.position.x < NSMinX( bouds ) )
	{
		velocity.x = BOID_VELOCITY_MAX / 10.0;
	}
	else if ( self.position.x > NSMaxX( bouds ) )
	{
		velocity.x = BOID_VELOCITY_MAX * -1 / 10.0;
	}
	
	// Check Y bounds.
	
	if ( self.position.y < NSMinY( bouds ) )
	{
		velocity.y = BOID_VELOCITY_MAX / 10.0;
	}
	else if ( self.position.y > NSMaxY( bouds ) )
	{
		velocity.y = BOID_VELOCITY_MAX * -1 / 10.0;
	}
	
	return velocity;
}

- (Vector)wind;
{
	// Stub-- return random vector based on current time?
	
	return MakeVector( 0.0, 0.0 );
}

- (Vector)avoidPredator;
{
	NSPoint predator = self.flock.predator.position;
	Vector vector = ZeroVector;
	
	if ( fabs( Distance( self.position, predator ) ) <= BOID_PREDATOR_DISTANCE )
	{
		vector.x = vector.x - ( predator.x - self.position.x );
		vector.y = vector.y - ( predator.y - self.position.y );
	}
	
	return vector;
}

- (void)limitVelocity;
{
	if ( fabs( self.velocity.x ) > BOID_VELOCITY_MAX )
	{
		Vector vector = self.velocity;
		vector.x = ( self.velocity.x / fabs( self.velocity.x ) ) * BOID_VELOCITY_MAX;
		self.velocity = vector;
	}
	
	if ( fabs( self.velocity.y ) > BOID_VELOCITY_MAX )
	{
		Vector vector = self.velocity;
		vector.y = ( self.velocity.y / fabs( self.velocity.y ) ) * BOID_VELOCITY_MAX;
		self.velocity = vector;
	}
}

@end
