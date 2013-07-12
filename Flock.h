//
//  Flock.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Predator;

@interface Flock : NSObject 
{
	NSRect _bounds;
	BOOL _isScattered;
	NSMutableArray *_boids;
	NSMutableArray *_predators;
}

@property(assign) NSInteger boidCount;
@property(assign) NSInteger predatorCount;
@property(assign) NSRect bounds;
@property(assign) BOOL isScattered;
@property(strong) NSMutableArray *boids;
@property(strong) NSMutableArray *predators;

- (id)initWithCount:(NSInteger)count;

- (void)update;
- (void)scatterFlock;

@end
