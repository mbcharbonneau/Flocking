//
//  TwoDimensionalObject.m
//  Flocking
//
//  Created by Marc Charbonneau on 4/15/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "TwoDimensionalObject.h"

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
	// Apply velocity to position.
	
	NSPoint newPosition = self.position;
	
	newPosition.x = newPosition.x + self.velocity.x;
	newPosition.y = newPosition.y + self.velocity.y;
	
	self.position = newPosition;
}

@end
