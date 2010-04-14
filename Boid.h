//
//  Boid.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Flock;

struct Vector
{
	NSInteger x, y, z;
}

@interface Boid : NSObject 
{
	NSPoint _position;
	double _speed;
	double _trajectory;
	NSTimeInterval _lastUpdate;
}

@property(readonly) NSPoint position;
@property(readonly) double speed;
@property(readonly) double trajectory;
@property(readonly) NSTimeInterval lastUpdate;

- (void)move:(Flock *)flock;

@end
