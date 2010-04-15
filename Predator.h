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

@interface Predator : TwoDimensionalObject 
{
	Flock *_flock;
}

@property(assign) Flock *flock;

- (id)initWithPosition:(NSPoint)point flock:(Flock *)flock;

@end