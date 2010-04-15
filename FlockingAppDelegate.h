//
//  FlockingAppDelegate.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Flock;
@class FlockView;

@interface FlockingAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *_window;
	FlockView *_view;
	NSTextField *_timerTextField;
	NSTextField *_boidCountTextField;
	Flock *_flock;
	NSTimer *_updateTimer;
	NSTimer *_drawTimer;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet FlockView *view;
@property(assign) IBOutlet NSTextField *timerTextField;
@property(assign) IBOutlet NSTextField *boidCountTextField;
@property(assign) Flock *flock;
@property(assign) NSTimer *updateTimer;
@property(assign) NSTimer *drawTimer;

- (void)update:(id)sender;
- (void)redraw:(id)sender;
- (void)adjustBoidsCount:(id)sender;

@end
