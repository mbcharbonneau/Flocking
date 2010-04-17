//
//  TwoDimensionalObject.m
//  Flocking
//
//  Created by Marc Charbonneau on 4/15/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "TwoDimensionalObject.h"

double GetDistance( NSPoint p1, NSPoint p2 )
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

@implementation TwoDimensionalObject

#pragma mark TwoDimensionalObject Methods

@synthesize position = _position;
@synthesize velocity = _velocity;

- (id)initWithPosition:(NSPoint)point;
{
	if ( self = [super init] )
	{
		_position = point;
	}
	
	return self;
}

- (void)move;
{	
	// Apply the current velocity to position.
	
	NSPoint newPosition = self.position;
	
	newPosition.x = newPosition.x + self.velocity.x;
	newPosition.y = newPosition.y + self.velocity.y;
	
	self.position = newPosition;
}

@end
