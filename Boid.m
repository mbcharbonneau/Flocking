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
#import "Constants.h"

#define BOID_MIN_DISTANCE 150.0
#define BOID_AVG_VELOCITY_FRACTION 8.0
#define BOID_FLOCK_CENTER_FRACTION 100.0
#define BOID_PREDATOR_DISTANCE 1500.0
#define RULE1_MULTIPLIER 1.0
#define RULE2_MULTIPLIER 1.0
#define RULE3_MULTIPLIER 1.0
#define PREDATOR_MULTIPLIER 0.06

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
@synthesize dead = _dead;

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
	if ( self.dead )
		return;
	
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
	newVelocity = AddVector( newVelocity, MultiplyVector( [self avoidPredator], PREDATOR_MULTIPLIER ) );
	
	self.velocity = newVelocity;
	
	[self limitVelocity];
	
	[super move];
}

@end

@implementation Boid (Private)

- (Vector)rule1;
{
	// Move towards the center of the flock.
	
	NSPoint center = NSZeroPoint;
	NSInteger count = 0;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self || boid.dead )
			continue;
		
		center = AddPoints( center, boid.position );
		count++;
	}
	
	center.x = center.x / count;
	center.y = center.y / count;
	
	double x = ( center.x - self.position.x ) / BOID_FLOCK_CENTER_FRACTION;
	double y = ( center.y - self.position.y ) / BOID_FLOCK_CENTER_FRACTION;
	
	return MakeVector( x, y );
}

- (Vector)rule2;
{
	// Avoid any nearby boids.
	
	Vector vector = ZeroVector;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self || boid.dead )
			continue;
		
		if ( fabs( GetDistance( self.position, boid.position ) ) <= BOID_MIN_DISTANCE )
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
	NSInteger count = 0;
	
	// Average the velocity for all boids.
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self || boid.dead )
			continue;
		
		vector = AddVector( vector, boid.velocity );
		count++;
	}
	
	vector.x = vector.x / count;
	vector.y = vector.y / count;
	
	// Return a fraction of the difference between the current and 
	// average velocity.
	
	vector.x = ( vector.x - self.velocity.x ) / BOID_AVG_VELOCITY_FRACTION;
	vector.y = ( vector.y - self.velocity.y ) / BOID_AVG_VELOCITY_FRACTION;
	
	return vector;
}

- (Vector)boundsConstraint;
{
	double maxVelocity = [[NSUserDefaults standardUserDefaults] doubleForKey:BoidMaxVelocityDefaultsKey];
	Vector velocity = ZeroVector;
	NSRect bounds = [self.flock bounds];
	
	// Check X bounds.
	
	if ( self.position.x < NSMinX( bounds ) )
	{
		velocity.x = maxVelocity / 5.0;
	}
	else if ( self.position.x > NSMaxX( bounds ) )
	{
		velocity.x = maxVelocity * -1 / 5.0;
	}
	
	// Check Y bounds.
	
	if ( self.position.y < NSMinY( bounds ) )
	{
		velocity.y = maxVelocity / 5.0;
	}
	else if ( self.position.y > NSMaxY( bounds ) )
	{
		velocity.y = maxVelocity * -1 / 5.0;
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
	Vector vector = ZeroVector;
	
	for ( Predator *predator in self.flock.predators )
	{
		if ( fabs( GetDistance( self.position, predator.position ) ) <= BOID_PREDATOR_DISTANCE )
		{
			vector.x = vector.x - ( predator.position.x - self.position.x );
			vector.y = vector.y - ( predator.position.y - self.position.y );
		}
	}
	
	return vector;
	
}

- (void)limitVelocity;
{
	double maxVelocity = [[NSUserDefaults standardUserDefaults] doubleForKey:BoidMaxVelocityDefaultsKey];
	
	if ( fabs( self.velocity.x ) > maxVelocity )
	{
		Vector vector = self.velocity;
		vector.x = ( self.velocity.x / fabs( self.velocity.x ) ) * maxVelocity;
		self.velocity = vector;
	}
	
	if ( fabs( self.velocity.y ) > maxVelocity )
	{
		Vector vector = self.velocity;
		vector.y = ( self.velocity.y / fabs( self.velocity.y ) ) * maxVelocity;
		self.velocity = vector;
	}
}

@end
