//
//  Flock.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Flock.h"
#import "Boid.h"
#import "Predator.h"

@interface Flock (Private)

- (void)endScatter;
- (Boid *)newBoid;
- (Predator *)newPredator;

@end

@implementation Flock

#pragma mark Flock Methods

@synthesize bounds = _bounds;
@synthesize isScattered = _isScattered;
@synthesize boids = _boids;
@synthesize predators = _predators;

- (id)initWithCount:(NSInteger)count;
{
	if ( self = [super init] )
	{
		_bounds = NSMakeRect( 0.0f, 0.0f, 10000.0, 7500.0 );
		_boids = [NSMutableArray arrayWithCapacity:count];
		_predators = [NSMutableArray arrayWithCapacity:1];
		
		NSInteger index;
		
		for ( index = 0; index < count; index++ )
			[_boids addObject:[self newBoid]];
		
		[_predators addObject:[self newPredator]];
	}
	
	return self;
}

- (NSInteger)boidCount;
{
	return [self.boids count];
}

- (void)setBoidCount:(NSInteger)boidCount;
{
	NSInteger current = [self.boids count];
	NSInteger index;
	
	for ( index = 0; index < abs( boidCount - current ); index++ )
	{
		if ( boidCount < current )
			[self.boids removeLastObject];
		else
			[self.boids addObject:[self newBoid]];
	}
}

- (NSInteger)predatorCount;
{
	return [self.predators count];
}

- (void)setPredatorCount:(NSInteger)predatorCount;
{
	NSInteger current = [self.predators count];
	NSInteger index;
	
	for ( index = 0; index < abs( predatorCount - current ); index++ )
	{
		if ( predatorCount < current )
			[self.predators removeLastObject];
		else
			[self.predators addObject:[self newPredator]];
	}
}

- (void)update;
{
	for ( Boid *boid in self.boids )
		[boid move];

	for ( Predator *predator in self.predators )
		[predator move];
}
	 
- (void)scatterFlock;
{
	self.isScattered = YES;
	[NSTimer scheduledTimerWithTimeInterval:( arc4random() % 5 + 3 ) target:self selector:@selector(endScatter) userInfo:nil repeats:NO];
}

@end

@implementation Flock (Private)

- (void)endScatter;
{
	self.isScattered = NO;
}

- (Boid *)newBoid;
{
	double x = arc4random() % (NSInteger)NSMaxX( self.bounds );
	double y = arc4random() % (NSInteger)NSMaxY( self.bounds );
	
	return [[Boid alloc] initWithPosition:NSMakePoint( x, y ) flock:self];
}

- (Predator *)newPredator;
{
	double x = arc4random() % (NSInteger)NSMaxX( self.bounds );
	double y = arc4random() % (NSInteger)NSMaxY( self.bounds );
	
	return [[Predator alloc] initWithPosition:NSMakePoint( x, y ) flock:self];
}

@end
