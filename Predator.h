//
//  Predator.h
//  Flocking
//
//  Created by Marc Charbonneau on 4/15/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TwoDimensionalObject.h"

@class Flock;
@class Boid;

@interface Predator : TwoDimensionalObject 
{
	BOOL _feeding;
	Boid *_prey;
	Flock *_flock;
	NSTimer *_preyTimer;
}

@property(assign) BOOL feeding;
@property(strong) Boid *prey;
@property(strong) Flock *flock;
@property(strong) NSTimer *preyTimer;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;

@end