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
#import "Constants.h"

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
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSInteger index;
		
		for ( index = 0; index < count; index++ )
			[_boids addObject:[self newBoid]];
		
		for ( index = 0; index < [defaults integerForKey:PredatorCountDefaultsKey]; index++ )
			[_predators addObject:[self newPredator]];
		
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
	for ( Boid *boid in self.boids )
		[boid resetBehaviors];
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
