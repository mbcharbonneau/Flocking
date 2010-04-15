//
//  Flock.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flock : NSObject 
{
	BOOL _scatter;
	NSArray *_boids;
}

@property(assign) BOOL scatter;
@property(assign) NSArray *boids;

- (id)initWithCount:(NSInteger)count;
- (void)update;
- (void)scatterFlock;

@end
