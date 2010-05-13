//
//  Boid.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwoDimensionalObject.h"

@class Flock;

@interface Boid : TwoDimensionalObject 
{
	BOOL _dead;
	Flock *_flock;
	double _flockDistance;
	double _boidDistance;
	double _windX;
	double _windY;	
	double _maxVelocity;
	double _predatorDistance;
	double _cohesionMultiplier;
	double _avoidanceMultiplier;
	double _velocityMultiplier;
	double _predatorMultiplier;
}

@property(assign) BOOL dead;
@property(assign) Flock *flock;
@property(assign) double flockDistance;
@property(assign) double boidDistance;
@property(assign) double windX;
@property(assign) double windY;
@property(assign) double maxVelocity;
@property(assign) double predatorDistance;
@property(assign) double cohesionMultiplier;
@property(assign) double avoidanceMultiplier;
@property(assign) double velocityMultiplier;
@property(assign) double predatorMultiplier;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;

@end
