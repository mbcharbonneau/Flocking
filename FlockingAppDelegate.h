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
	NSTableView *_timeRecordsTableView;
	Flock *_flock;
	NSTimer *_updateTimer;
	NSTimer *_drawTimer;
	BOOL _paused;
	NSMutableArray *_timeRecords;
}

@property(strong, nonatomic) IBOutlet NSWindow *window;
@property(strong, nonatomic) IBOutlet FlockView *view;
@property(strong, nonatomic) IBOutlet NSTextField *timerTextField;
@property(strong, nonatomic) IBOutlet NSTextField *fpsTextField;
@property(strong, nonatomic) IBOutlet NSTextField *boidCountTextField;
@property(strong, nonatomic) IBOutlet NSSlider *boidCountSlider;
@property(strong, nonatomic) IBOutlet NSTableView *timeRecordsTableView;
@property(strong, nonatomic) Flock *flock;
@property(strong, nonatomic) NSTimer *updateTimer;
@property(strong, nonatomic) NSTimer *drawTimer;
@property(assign, nonatomic) BOOL paused;
@property(strong, nonatomic) NSMutableArray *timeRecords;

- (void)update:(id)sender;
- (void)redraw:(id)sender;
- (void)adjustBoidsCount:(id)sender;
- (void)setPredatorCount:(id)sender;
- (void)resetSimulation:(id)sender;
- (void)resetDefaults:(id)sender;
- (void)togglePaused:(id)sender;
- (void)newTimeRecord:(id)sender;
- (void)clearTimeRecords:(id)sender;

@end
