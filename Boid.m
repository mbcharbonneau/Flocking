//
//  Boid.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Boid.h"
#import "Flock.h"

#define FLOCKING_AREA_MAX_WIDTH 20000.0
#define FLOCKING_AREA_MAX_HEIGHT 15000.0
#define BOID_VELOCITY_MAX 5.0
#define BOID_MIN_DISTANCE 300.0
#define BOID_AVG_VELOCITY_FRACTION 8.0
#define BOID_FLOCK_CENTER_FRACTION 100.0
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

@implementation Boid

#pragma mark Boid Methods

@synthesize position = _position;
@synthesize velocity = _velocity;
@synthesize lastUpdate = _lastUpdate;

- (void)move:(Flock *)flock;
{
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
	
	for ( Boid *boid in flock.boids )
	{
		// Calculate new velocity.
		
		Vector newVelocity = boid.velocity;
		Vector rule1 = MultiplyVector( [self rule1:boid flock:flock], flock.scatter ? RULE1_MULTIPLIER * -1.0 : RULE1_MULTIPLIER );
		Vector rule2 = MultiplyVector( [self rule2:boid flock:flock], RULE1_MULTIPLIER );
		Vector rule3 = MultiplyVector( [self rule3:boid flock:flock], RULE1_MULTIPLIER );
		
		newVelocity = AddVector( newVelocity, rule1 );
		newVelocity = AddVector( newVelocity, rule2 );
		newVelocity = AddVector( newVelocity, rule3 );
		newVelocity = AddVector( newVelocity, [self windVector] );
		newVelocity = AddVector( newVelocity, [self constrainPosition:boid] );
		
		boid.velocity = newVelocity;
		
		[self limitVelocity:boid];
		
		// Apply velocity to position.
		
		NSPoint newPosition = boid.position;
		
		newPosition.x = newPosition.x + boid.velocity.x;
		newPosition.y = newPosition.y + boid.velocity.y;
		
		boid.position = newPosition;		
	}
	
	_lastUpdate = interval;
}

- (Vector)rule1:(Boid *)boid flock:(Flock *)flock;
{
	NSInteger count = [flock.boids count];
	NSPoint center = NSZeroPoint;
	
	for ( Boid *next in flock.boids )
	{
		if ( next == boid )
			continue;
		
		center = AddPoints( center, next.position );
	}
	
	center.x = center.x / ( count - 1 );
	center.y = center.y / ( count - 1 );
	
	double x = ( center.x - boid.position.x ) / BOID_FLOCK_CENTER_FRACTION;
	double y = ( center.y - boid.position.y ) / BOID_FLOCK_CENTER_FRACTION;
	
	return MakeVector( x, y );
}

- (Vector)rule2:(Boid *)boid flock:(Flock *)flock;
{
	Vector velocity = ZeroVector;
	
	for ( Boid *next in flock.boids )
	{
		if ( next == boid )
			continue;

		if ( fabs( Distance( boid.position, next.position ) ) <= BOID_MIN_DISTANCE )
		{
			velocity.x = velocity.x - ( next.position.x - boid.position.x );
			velocity.y = velocity.y - ( next.position.y - boid.position.y );
		}
	}
	
	return velocity;
}

- (Vector)rule3:(Boid *)boid flock:(Flock *)flock;
{
	Vector vector = ZeroVector;
	
	// Average the velocity for all boids.
	
	for ( Boid *next in flock.boids )
	{
		if ( boid == next )
			continue;
		
		vector = AddVector( vector, next.velocity );
	}
	
	vector.x = vector.x / ( [flock.boids count] - 1 );
	vector.y = vector.y / ( [flock.boids count] - 1 );
	
	// Return a fraction of the difference between the current and 
	// average velocity.
	
	vector.x = ( vector.x - boid.velocity.x ) / BOID_AVG_VELOCITY_FRACTION;
	vector.y = ( vector.y - boid.velocity.y ) / BOID_AVG_VELOCITY_FRACTION;

	return vector;
}

- (Vector)constrainPosition:(Boid *)boid;
{
	Vector velocity = ZeroVector;
	
	// Check X bounds.
	
	if ( boid.position.x < 0.0 )
	{
		velocity.x = BOID_VELOCITY_MAX / 10.0;
	}
	else if ( boid.position.x > FLOCKING_AREA_MAX_WIDTH )
	{
		velocity.x = BOID_VELOCITY_MAX * -1 / 10.0;
	}
	
	// Check Y bounds.
	
	if ( boid.position.y < 0.0 )
	{
		velocity.y = BOID_VELOCITY_MAX / 10.0;
	}
	else if ( boid.position.y > FLOCKING_AREA_MAX_HEIGHT )
	{
		velocity.y = BOID_VELOCITY_MAX * -1 / 10.0;
	}
	
	return velocity;
}

- (Vector)windVector;
{
	// Stub-- return random vector based on current time?
	
	return MakeVector( 0.0, 0.0 );
}

- (void)limitVelocity:(Boid *)boid;
{	
	if ( fabs( boid.velocity.x ) > BOID_VELOCITY_MAX )
	{
		Vector vector = boid.velocity;
		vector.x = ( boid.velocity.x / fabs( boid.velocity.x ) ) * BOID_VELOCITY_MAX;
		boid.velocity = vector;
	}
		
	if ( fabs( boid.velocity.y ) > BOID_VELOCITY_MAX )
	{
		Vector vector = boid.velocity;
		vector.y = ( boid.velocity.y / fabs( boid.velocity.y ) ) * BOID_VELOCITY_MAX;
		boid.velocity = vector;
	}
}

#pragma mark NSObject Overrides

- (id)init;
{
	if ( self = [super init] )
	{
		double x = arc4random() % (NSInteger)FLOCKING_AREA_MAX_WIDTH;
		double y = arc4random() % (NSInteger)FLOCKING_AREA_MAX_HEIGHT;
		double xVel = arc4random() % ( (NSInteger)BOID_VELOCITY_MAX - 1 ) + 1;
		double yVel = arc4random() % ( (NSInteger)BOID_VELOCITY_MAX - 1 ) + 1;
		
		_position = NSMakePoint( x, y );
		_velocity = MakeVector( xVel, yVel );
	}
	
	return self;
}

@end
