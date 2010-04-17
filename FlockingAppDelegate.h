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
	NSTextField *_fpsTextField;
	NSTextField *_boidCountTextField;
	NSSlider *_boidCountSlider;
	Flock *_flock;
	NSTimer *_updateTimer;
	NSTimer *_drawTimer;
	BOOL _paused;
}

@property(assign) IBOutlet NSWindow *window;
@property(assign) IBOutlet FlockView *view;
@property(assign) IBOutlet NSTextField *timerTextField;
@property(assign) IBOutlet NSTextField *fpsTextField;
@property(assign) IBOutlet NSTextField *boidCountTextField;
@property(assign) IBOutlet NSSlider *boidCountSlider;
@property(assign) Flock *flock;
@property(assign) NSTimer *updateTimer;
@property(assign) NSTimer *drawTimer;
@property(assign) BOOL paused;

- (void)update:(id)sender;
- (void)redraw:(id)sender;
- (void)adjustBoidsCount:(id)sender;
- (void)setPredatorCount:(id)sender;
- (void)resetSimulation:(id)sender;
- (void)resetDefaults:(id)sender;
- (void)togglePaused:(id)sender;

@end
