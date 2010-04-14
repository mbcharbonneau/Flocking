//
//  Flock.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Flock.h"
#import "Boid.h"

@implementation Flock

#pragma mark Flock Methods

@synthesize boids = _boids;

- (id)initWithCount:(NSInteger)count;
{
	if ( self = [super init] )
	{
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
		NSInteger index;
		
		for ( index = 0; index < count; index++ )
		{
			[array addObject:[[Boid alloc] init]];
		}
			 
		_boids = array;
	}
	
	return self;
}

- (void)update;
{
	for ( Boid *boid in self.boids )
	{
		[boid move:self];
	}
}

@end
