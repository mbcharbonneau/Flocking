//
//  TwoDimensionalObject.h
//  Flocking
//
//  Created by Marc Charbonneau on 4/15/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Vector.h"

double GetDistance( NSPoint p1, NSPoint p2 );
NSPoint AddPoints( NSPoint p1, NSPoint p2 );

@interface TwoDimensionalObject : NSObject 
{
	NSPoint _position;
	Vector _velocity;
}

@property(assign) NSPoint position;
@property(assign) Vector velocity;

- (id)initWithPosition:(NSPoint)point;

- (void)move;

@end
