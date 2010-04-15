//
//  Boid.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@class Flock;

@interface Boid : NSObject 
{
	NSPoint _position;
	Vector _velocity;
	NSTimeInterval _lastUpdate;
}

@property(assign) NSPoint position;
@property(assign) Vector velocity;
@property(assign) NSTimeInterval lastUpdate;

- (void)move:(Flock *)flock;

- (Vector)rule1:(Boid *)boid flock:(Flock *)flock;
- (Vector)rule2:(Boid *)boid flock:(Flock *)flock;
- (Vector)rule3:(Boid *)boid flock:(Flock *)flock;

- (Vector)constrainPosition:(Boid *)boid;
- (void)limitVelocity:(Boid *)boid;

@end
