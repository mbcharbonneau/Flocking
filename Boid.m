//
//  Boid.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Boid.h"
#import "Flock.h"

@implementation Boid

#pragma mark Boid Methods

@synthesize position = _position;
@synthesize velocity = _velocity;
@synthesize lastUpdate = _lastUpdate;

- (void)move:(Flock *)flock;
{
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];

	Vector v1, v2, v3, v4;
	
	for ( Boid *boid in flock.boids )
	{
		// Calculate new velocity.
		
		v1 = [self rule1:boid flock:flock];
		v2 = [self rule2:boid flock:flock];
		v3 = [self rule3:boid flock:flock];
		v4 = [self constrainPosition:boid];
		
		Vector newVelocity;
		newVelocity.x = boid.velocity.x + v1.x + v2.x + v3.x + v4.x;
		newVelocity.y = boid.velocity.y + v1.y + v2.y + v3.y + v4.x;
		boid.velocity = newVelocity;
		
		[self limitVelocity:boid];
		
		// Apply new velocity.
		
		NSPoint newPos;
		newPos.x = boid.position.x + boid.velocity.x;
		newPos.y = boid.position.y + boid.velocity.y;
		boid.position = newPos;
		
		/*
		 v1 = rule1(b)
		 v2 = rule2(b)
		 v3 = rule3(b)
		 
		 b.velocity = b.velocity + v1 + v2 + v3
		 b.position = b.position + b.velocity
		 */
	}
	
	_lastUpdate = interval;
}

- (Vector)rule1:(Boid *)boid flock:(Flock *)flock;
{
	Vector center, ret;
	
	center.x = 400.0;
	center.y = 300.0;
	/*
	for ( Boid *next in flock.boids )
	{
		if ( next == boid )
			continue;
		
		center.x = center.x + next.position.x;
		center.y = center.y + next.position.y;
	}
	
	center.x = center.x / ( [flock.boids count] - 1 );
	center.y = center.y / ( [flock.boids count] - 1 );
		*/
	ret.x = ( center.x - boid.position.x ) / 10000.0;
	ret.y = ( center.y - boid.position.y ) / 10000.0;

	return ret;
	
	/*
	 Vector pcJ
	 
	 FOR EACH BOID b
	 IF b != bJ THEN
	 pcJ = pcJ + b.position
	 END IF
	 END
	 
	 pcJ = pcJ / N-1
	 
	 RETURN (pcJ - bJ.position) / 100

	 */
}

- (Vector)rule2:(Boid *)boid flock:(Flock *)flock;
{
	Vector velocity = { 0.0, 0.0 };
	
	for ( Boid *next in flock.boids )
	{
		if ( next == boid )
			continue;
		
		double xDistance = abs( next.position.x - boid.position.x );
		double yDistance = abs( next.position.y - boid.position.y );
		double distance = sqrt( xDistance * xDistance + yDistance * yDistance );
		
		if ( distance < 5.0 )
		{
			velocity.x = velocity.x - ( boid.position.x - next.position.x );
			velocity.y = velocity.y - ( boid.position.y - next.position.y );
		}
	}
	
	return velocity;
	
	/*
	 Vector c = 0;
	 
	 FOR EACH BOID b
	 IF b != bJ THEN
	 IF |b.position - bJ.position| < 100 THEN
	 c = c - (b.position - bJ.position)
	 END IF
	 END IF
	 END
	 
	 RETURN c
	 */
}

- (Vector)rule3:(Boid *)boid flock:(Flock *)flock;
{
	Vector vector = { 0.0, 0.0 };
	
	for ( Boid *next in flock.boids )
	{
		if ( boid == next )
			continue;
		
		vector.x = vector.x + next.velocity.x;
		vector.y = vector.y + next.velocity.y;
	}
	
	vector.x = vector.x / ( [flock.boids count] - 1 );
	vector.y = vector.y / ( [flock.boids count] - 1 );
	
	vector.x = ( vector.x - boid.velocity.x ) / 8.0;
	vector.y = ( vector.y - boid.velocity.y ) / 8.0;

	return vector;
	/*
	 PROCEDURE rule3(boid bJ)
	 
	 Vector pvJ
	 
	 FOR EACH BOID b
	 IF b != bJ THEN
	 pvJ = pvJ + b.velocity
	 END IF
	 END
	 
	 pvJ = pvJ / N-1
	 
	 RETURN (pvJ - bJ.velocity) / 8
	 
	 END PROCEDURE
	 */
}

- (Vector)constrainPosition:(Boid *)boid;
{
	Vector velocity = { 0.0, 0.0 };
	
	if ( boid.position.x < 0.0 )
	{
		boid.position = NSMakePoint( 0.1, boid.position.y );
		velocity.x = velocity.x * -1.0;
	}
	else if ( boid.position.x > 800.0 )
	{
		boid.position = NSMakePoint( 799, boid.position.y );
		velocity.x = velocity.x * -1;
	}
	
	if ( boid.position.y < 0.0 )
	{
		boid.position = NSMakePoint( boid.position.x, 0.1 );
		velocity.y = velocity.y * -1;
	}
	else if ( boid.position.y > 600.0 )
	{
		boid.position = NSMakePoint( boid.position.x, 599 );		
		velocity.y = velocity.y * -1;
	}
	
	return velocity;
	
	/*
	 PROCEDURE bound_position(Boid b)
	 Integer Xmin, Xmax, Ymin, Ymax, Zmin, Zmax
	 Vector v
	 
	 IF b.position.x < Xmin THEN
	 v.x = 10
	 ELSE IF b.position.x > Xmax THEN
	 v.x = -10
	 END IF
	 IF b.position.y < Ymin THEN
	 v.y = 10
	 ELSE IF b.position.y > Ymax THEN
	 v.y = -10
	 END IF
	 IF b.position.z < Zmin THEN
	 v.z = 10
	 ELSE IF b.position.z > Zmax THEN
	 v.z = -10
	 END IF
	 
	 RETURN v
	 END PROCEDURE
	 */
}

- (void)limitVelocity:(Boid *)boid;
{
	double maxVelocity = 1.0;
	
	if ( fabs( boid.velocity.x ) > maxVelocity )
	{
		Vector vector = boid.velocity;
		vector.x = ( boid.velocity.x / fabs( boid.velocity.x ) ) * maxVelocity;
		boid.velocity = vector;
	}
		
	if ( fabs( boid.velocity.y ) > maxVelocity )
	{
		Vector vector = boid.velocity;
		vector.y = ( boid.velocity.y / fabs( boid.velocity.y ) ) * maxVelocity;
		boid.velocity = vector;
	}
	/*
	 PROCEDURE limit_velocity(Boid b)
	 Integer vlim
	 Vector v
	 
	 IF |b.velocity| > vlim THEN
	 b.velocity = (b.velocity / |b.velocity|) * vlim
	 END IF
	 END PROCEDURE
	 */
}

#pragma mark NSObject Overrides

- (id)init;
{
	if ( self = [super init] )
	{
		_position = NSMakePoint( arc4random() % 800, arc4random() % 600 );
		_velocity.x = ( arc4random() % 20 + 1 ) / 10.0;
		_velocity.y = ( arc4random() % 20 + 1 ) / 10.0;
	}
	
	return self;
}

@end
