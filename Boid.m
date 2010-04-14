//
//  Boid.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "Boid.h"

@implementation Boid

#pragma mark Boid Methods

@synthesize position = _position;
@synthesize speed = _speed;
@synthesize trajectory = _trajectory;
@synthesize lastUpdate = _lastUpdate;

- (void)move:(Flock *)flock;
{
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
	
	_position.x += self.speed * cos( _trajectory );
	_position.y += self.speed * sin( _trajectory );
	
	if ( _position.x < 0.0 )
	{
		_position.x = 0.0;
		_trajectory = (NSInteger)( 180 - _trajectory ) % 360;
	}
	
	if ( _position.x > 800.0 )
	{
		_position.x = 800.0;
		_trajectory = (NSInteger)( 180 - _trajectory ) % 360;
	}
	
	if ( _position.y < 0.0 )
	{
		_position.y = 0.0;
		_trajectory = (NSInteger)( 180 - _trajectory ) % 360;
	}
	
	if ( _position.y > 600.0 )
	{
		_position.y = 600.0;
		_trajectory = (NSInteger)( 180 - _trajectory ) % 360;
	}
	
	_lastUpdate = interval;
}

#pragma mark NSObject Overrides

- (id)init;
{
	if ( self = [super init] )
	{
		_position = NSMakePoint( 400.0, 300.0 );
		_speed = ( arc4random() % 9 ) + 1;
		_trajectory = arc4random() % 360;
	}
	
	return self;
}

@end
