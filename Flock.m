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

@end

@implementation Flock

#pragma mark Flock Methods

@synthesize bounds = _bounds;
@synthesize isScattered = _isScattered;
@synthesize boids = _boids;
@synthesize predator = _predator;

- (id)initWithCount:(NSInteger)count;
{
	if ( self = [super init] )
	{
		_bounds = NSMakeRect( 0.0f, 0.0f, 10000.0, 7500.0 );
		
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
		NSInteger index;
		
		for ( index = 0; index < count; index++ )
			[array addObject:[self newBoid]];
		
		_boids = array;
		_predator = [[Predator alloc] initWithPosition:NSMakePoint( 5000, 2000 ) flock:self];
	}
	
	return self;
}

- (NSInteger)count;
{
	return [self.boids count];
}

- (void)setCount:(NSInteger)count;
{
	NSInteger current = [self.boids count];
	NSInteger index;
	
	for ( index = 0; index < abs( count - current ); index++ )
	{
		if ( count < current )
			[self.boids removeLastObject];
		else
			[self.boids addObject:[self newBoid]];
	}
}

- (void)update;
{
	for ( Boid *boid in self.boids )
	{
		[boid move];
	}
	
	[self.predator move];
}
	 
- (void)scatterFlock;
{
	self.isScattered = YES;
	[NSTimer scheduledTimerWithTimeInterval:( arc4random() % 3 + 1 ) target:self selector:@selector(endScatter) userInfo:nil repeats:NO];
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

@end
