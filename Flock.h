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
	NSArray *_boids;
}

@property(readonly) NSArray *boids;

- (id)initWithCount:(NSInteger)count;
- (void)update;

@end
