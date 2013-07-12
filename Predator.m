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
#import "Constants.h"

#define PREDATOR_VECTOR_FRACTION 10.0
#define PREDATOR_KILL_DISTANCE 35.0

@interface Predator (Private)

- (void)limitVelocity;
- (void)stopFeeding:(id)sender;
- (void)findPrey:(id)sender;

@end

@implementation Predator

#pragma mark Predator Methods

@synthesize feeding = _feeding;
@synthesize prey = _prey;
@synthesize flock = _flock;
@synthesize preyTimer = _preyTimer;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;
{
	if ( self = [super initWithPosition:point] )
	{
		_flock = [flock retain];
		_preyTimer = [[NSTimer scheduledTimerWithTimeInterval:( arc4random() % 3 + 2 ) target:self selector:@selector(findPrey:) userInfo:nil repeats:YES] retain];

		[_preyTimer fire];
	}
	
	return self;
}

- (void)move;
{
	if ( self.feeding || self.prey == nil )
		return;
	
	// Add new velocity towards prey.
	
	double x = ( self.prey.position.x - self.position.x ) / PREDATOR_VECTOR_FRACTION;
	double y = ( self.prey.position.y - self.position.y ) / PREDATOR_VECTOR_FRACTION;

	self.velocity = AddVector( self.velocity, MakeVector( x, y) );
	[self limitVelocity];
	[super move];
	
	// Kill any unlucky boids and pause for a moment.
	
	if ( fabs( GetDistance( self.position, self.prey.position ) ) <= PREDATOR_KILL_DISTANCE )
	{
		self.prey.dead = YES;
		self.velocity = ZeroVector;
		self.feeding = YES;
		[NSTimer scheduledTimerWithTimeInterval:( arc4random() % 4 + 1 ) target:self selector:@selector(stopFeeding:) userInfo:nil repeats:NO];
	}
}

- (void)dealloc;
{
    [_flock release];
    [_preyTimer release];
    [super dealloc];
}

@end

@implementation Predator (Private)

- (void)limitVelocity;
{
	double maxVelocity = [[NSUserDefaults standardUserDefaults] doubleForKey:PredatorMaxVelocityDefaultsKey];
	
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

- (void)stopFeeding:(id)sender;
{
	self.feeding = NO;
	[_preyTimer fire];
}

- (void)findPrey:(id)sender;
{
	self.prey = nil;
	double smallestDistance;
	
	for ( Boid *boid in self.flock.boids )
	{
		if ( boid.dead )
			continue;
		
		double distance = GetDistance( self.position, boid.position );
		
		if ( self.prey == nil || distance < smallestDistance )
		{
			self.prey = boid;
			smallestDistance = distance;
		}
	}
}

@end
