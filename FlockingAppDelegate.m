//
//  FlockingAppDelegate.m
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import "FlockingAppDelegate.h"
#import "Flock.h"
#import "FlockView.h"
#import "Constants.h"

@implementation FlockingAppDelegate

#pragma mark FlockingAppDelegate Methods

@synthesize window = _window;
@synthesize view = _view;
@synthesize timerTextField = _timerTextField;
@synthesize boidCountTextField = _boidCountTextField;
@synthesize boidCountSlider = _boidCountSlider;
@synthesize flock = _flock;
@synthesize updateTimer = _updateTimer;
@synthesize drawTimer = _drawTimer;

- (void)update:(id)sender;
{
	NSTimeInterval start, end;
	
	start = [NSDate timeIntervalSinceReferenceDate];
	[self.flock update];
	end = [NSDate timeIntervalSinceReferenceDate];
	
	[self.timerTextField setStringValue:[NSString stringWithFormat:@"%f seconds", end - start]];
	[self.boidCountTextField setStringValue:[NSString stringWithFormat:@"%ld boids", (long)[self.flock.boids count]]];
}

- (void)redraw:(id)sender;
{
	[self.view setNeedsDisplay:YES];
}

- (void)adjustBoidsCount:(id)sender;
{
	self.flock.boidCount = [(NSSlider *)sender integerValue];
}

- (void)setPredatorCount:(id)sender;
{
	self.flock.predatorCount = [[(NSPopUpButton *)sender selectedItem] tag];
}

- (void)resetSimulation:(id)sender;
{
	self.flock = [[Flock alloc] initWithCount:50];
	self.view.flock = self.flock;
	[self.boidCountSlider setIntegerValue:50.0];
}

- (void)resetDefaults:(id)sender;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey:PresentationModeDefaultsKey];
	[defaults removeObjectForKey:PredatorMaxVelocityDefaultsKey];
	[defaults removeObjectForKey:BoidMaxVelocityDefaultsKey];
}

#pragma mark NSApplication Delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
	[self resetSimulation:self];
	
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(update:) userInfo:nil repeats:YES];
	self.drawTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(redraw:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
	[self.updateTimer invalidate];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
{
	return YES;
}

#pragma mark NSObject Overrides

+ (void)initialize;
{
	NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithBool:NO], PresentationModeDefaultsKey,
							  [NSNumber numberWithDouble:50.0], PredatorMaxVelocityDefaultsKey,
							  [NSNumber numberWithDouble:30.0], BoidMaxVelocityDefaultsKey, nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
