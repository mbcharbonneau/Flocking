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
}

@property(assign) BOOL dead;
@property(assign) Flock *flock;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;

@end
