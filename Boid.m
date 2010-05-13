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

#define BOID_AVG_VELOCITY_FRACTION 8.0
#define BOID_AVOID_PREDATOR_FRACTION 8.0
#define BOID_FLOCK_CENTER_FRACTION 100.0
#define BOID_BOUNDS_FRACTION 2.0

@interface Boid (Private)

- (Vector)cohesion;
- (Vector)avoidance;
- (Vector)averageVelocities;
- (Vector)boundsConstraint;
- (Vector)wind;
- (Vector)avoidPredator;
- (void)limitVelocity;
- (void)setDefaults;

@end

@implementation Boid

#pragma mark Boid Methods

@synthesize flock = _flock;
@synthesize dead = _dead;
@synthesize flockDistance = _flockDistance;
@synthesize boidDistance = _boidDistance;
@synthesize windX = _windX;
@synthesize windY = _windY;
@synthesize maxVelocity = _maxVelocity;
@synthesize predatorDistance = _predatorDistance;
@synthesize cohesionMultiplier = _cohesionMultiplier;
@synthesize avoidanceMultiplier = _avoidanceMultiplier;
@synthesize velocityMultiplier = _velocityMultiplier;
@synthesize predatorMultiplier = _predatorMultiplier;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;
{
	if ( self = [super initWithPosition:point] )
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults addObserver:self forKeyPath:BoidFlockDistanceDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:BoidDistanceDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:WindXVelocityDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:WindYVelocityDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:BoidMaxVelocityDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:PredatorDistanceDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:CohesionMultiplierDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:AvoidanceMultiplierDefaultsKey options:0 context:NULL];		
		[defaults addObserver:self forKeyPath:VelocityMultiplierDefaultsKey options:0 context:NULL];
		[defaults addObserver:self forKeyPath:PredatorMultiplierDefaultsKey options:0 context:NULL];		

		[self setDefaults];
		
		_dead = NO;
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
	
	Vector rule1 = MultiplyVector( [self cohesion], self.cohesionMultiplier );
	Vector rule2 = MultiplyVector( [self avoidance], self.avoidanceMultiplier );
	Vector rule3 = MultiplyVector( [self averageVelocities], self.velocityMultiplier );
	Vector rule4 = [self wind];
	Vector rule5 = [self boundsConstraint];
	Vector rule6 = MultiplyVector( [self avoidPredator], self.predatorMultiplier );
	
	if ( self.flock.isScattered )
		rule1 = MultiplyVector( rule1, -1.0 );
	
	newVelocity = AddVector( newVelocity, rule1 );
	newVelocity = AddVector( newVelocity, rule2 );
	newVelocity = AddVector( newVelocity, rule3 );
	newVelocity = AddVector( newVelocity, rule4 );
	newVelocity = AddVector( newVelocity, rule5 );
	newVelocity = AddVector( newVelocity, rule6 );
	
	self.velocity = newVelocity;
	
	[self limitVelocity];
	[super move];
}

#pragma mark NSObject Overrides

- (void)finalize;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObserver:self forKeyPath:BoidFlockDistanceDefaultsKey];
	[defaults removeObserver:self forKeyPath:BoidDistanceDefaultsKey];
	[defaults removeObserver:self forKeyPath:WindXVelocityDefaultsKey];
	[defaults removeObserver:self forKeyPath:WindYVelocityDefaultsKey];
	[defaults removeObserver:self forKeyPath:BoidMaxVelocityDefaultsKey];
	[defaults removeObserver:self forKeyPath:PredatorDistanceDefaultsKey];
	[defaults removeObserver:self forKeyPath:CohesionMultiplierDefaultsKey];
	[defaults removeObserver:self forKeyPath:AvoidanceMultiplierDefaultsKey];
	[defaults removeObserver:self forKeyPath:VelocityMultiplierDefaultsKey];
	[defaults removeObserver:self forKeyPath:PredatorMultiplierDefaultsKey];

	[super finalize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	[self setDefaults];
}

@end

@implementation Boid (Private)

- (Vector)cohesion;
{
	// Move towards the center of the flock.
	
	NSPoint center = NSZeroPoint;
	NSInteger count = 0;
	
	for ( Boid *boid in self.flock.boids )
	{
		double distance = fabs( GetDistance( boid.position, self.position ) );
		
		if ( boid == self || boid.dead || distance > self.flockDistance )
			continue;
		
		center = AddPoints( center, boid.position );
		count++;
	}

	if ( count == 0 )
		return ZeroVector;
	
	center.x = center.x / count;
	center.y = center.y / count;
	
	double x = ( center.x - self.position.x ) / BOID_FLOCK_CENTER_FRACTION;
	double y = ( center.y - self.position.y ) / BOID_FLOCK_CENTER_FRACTION;
	
	return MakeVector( x, y );
}

- (Vector)avoidance;
{
	// Avoid any nearby boids.
	
	Vector vector = ZeroVector;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid == self || boid.dead )
			continue;
		
		if ( fabs( GetDistance( self.position, boid.position ) ) <= self.boidDistance )
		{
			vector.x = vector.x - ( boid.position.x - self.position.x );
			vector.y = vector.y - ( boid.position.y - self.position.y );
		}
	}
	
	return vector;
}

- (Vector)averageVelocities;
{
	Vector vector = ZeroVector;
	NSInteger count = 0;
	
	// Average the velocity for all boids.
	
	for ( Boid *boid in self.flock.boids )
	{
		double distance = fabs( GetDistance( boid.position, self.position ) );
		
		if ( boid == self || boid.dead || distance > self.flockDistance )
			continue;
		
		vector = AddVector( vector, boid.velocity );
		count++;
	}
	
	if ( count == 0 )
		return ZeroVector;
	
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
	Vector velocity = ZeroVector;
	NSRect bounds = [self.flock bounds];
	
	// Check X bounds.
	
	if ( self.position.x < NSMinX( bounds ) )
	{
		velocity.x = self.maxVelocity / BOID_BOUNDS_FRACTION;
	}
	else if ( self.position.x > NSMaxX( bounds ) )
	{
		velocity.x = self.maxVelocity * -1 / BOID_BOUNDS_FRACTION;
	}
	
	// Check Y bounds.
	
	if ( self.position.y < NSMinY( bounds ) )
	{
		velocity.y = self.maxVelocity / BOID_BOUNDS_FRACTION;
	}
	else if ( self.position.y > NSMaxY( bounds ) )
	{
		velocity.y = self.maxVelocity * -1 / BOID_BOUNDS_FRACTION;
	}
	
	return velocity;
}

- (Vector)wind;
{
	return MakeVector( self.windX, self.windY );
}

- (Vector)avoidPredator;
{
	Vector vector = ZeroVector;

	for ( Predator *predator in self.flock.predators )
	{
		if ( fabs( GetDistance( self.position, predator.position ) ) <= self.predatorDistance )
		{
			vector.x = vector.x - ( predator.position.x - self.position.x ) / BOID_AVOID_PREDATOR_FRACTION;
			vector.y = vector.y - ( predator.position.y - self.position.y ) / BOID_AVOID_PREDATOR_FRACTION;
		}
	}
	
	return vector;
	
}

- (void)limitVelocity;
{
	double maxVelocity = self.maxVelocity;
	double AbsXVelocity = fabs( self.velocity.x );
	double AbsYVelocity = fabs( self.velocity.y );
	
	if ( AbsXVelocity > maxVelocity )
	{
		Vector vector = self.velocity;
		vector.x = ( self.velocity.x / AbsXVelocity ) * maxVelocity;
		self.velocity = vector;
	}
	
	if ( AbsYVelocity > maxVelocity )
	{
		Vector vector = self.velocity;
		vector.y = ( self.velocity.y / AbsYVelocity ) * maxVelocity;
		self.velocity = vector;
	}

	NSAssert( fabs( self.velocity.x ) <= maxVelocity, ( [NSString stringWithFormat:@"X velocity (%f) exceeds bounds", fabs( self.velocity.x )] ) );
	NSAssert( fabs( self.velocity.y ) <= maxVelocity, ( [NSString stringWithFormat:@"Y velocity (%f) exceeds bounds", fabs( self.velocity.y )] ) );
}

- (void)setDefaults;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	_flockDistance = [defaults doubleForKey:BoidFlockDistanceDefaultsKey];
	_boidDistance = [defaults doubleForKey:BoidDistanceDefaultsKey];
	_windX = [defaults doubleForKey:WindXVelocityDefaultsKey];
	_windY = [defaults doubleForKey:WindYVelocityDefaultsKey];
	_maxVelocity = [defaults doubleForKey:BoidMaxVelocityDefaultsKey];
	_predatorDistance = [defaults doubleForKey:PredatorDistanceDefaultsKey];
	
	_cohesionMultiplier = [defaults doubleForKey:CohesionMultiplierDefaultsKey];
	_avoidanceMultiplier = [defaults doubleForKey:AvoidanceMultiplierDefaultsKey];
	_velocityMultiplier = [defaults doubleForKey:VelocityMultiplierDefaultsKey];
	_predatorMultiplier = [defaults doubleForKey:PredatorMultiplierDefaultsKey];
}

@end
