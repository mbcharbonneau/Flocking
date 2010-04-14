//
//  FlockView.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Flock;

@interface FlockView : NSView
{
	Flock *_flock;
}

@property(assign) Flock *flock;

@end
