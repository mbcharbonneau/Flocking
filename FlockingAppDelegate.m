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
@synthesize fpsTextField = _fpsTextField;
@synthesize boidCountTextField = _boidCountTextField;
@synthesize boidCountSlider = _boidCountSlider;
@synthesize flock = _flock;
@synthesize updateTimer = _updateTimer;
@synthesize drawTimer = _drawTimer;
@synthesize paused = _paused;

- (void)update:(id)sender;
{
	NSTimeInterval start, end;
	
	start = [NSDate timeIntervalSinceReferenceDate];
	
	if ( !self.paused )
		[self.flock update];
	
	end = [NSDate timeIntervalSinceReferenceDate];
	
	NSArray *living = [self.flock.boids filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.dead == NO"]];
	
	[self.timerTextField setStringValue:[NSString stringWithFormat:@"%f seconds", end - start]];
	[self.boidCountTextField setStringValue:[NSString stringWithFormat:@"%ld boids (%ld eaten)", (long)[living count], (long)( [self.flock.boids count] - [living count] )]];
}

- (void)redraw:(id)sender;
{
	NSTimeInterval start, end;
	
	start = [NSDate timeIntervalSinceReferenceDate];
	[self.view display];
	end = [NSDate timeIntervalSinceReferenceDate];
	
	[self.fpsTextField setStringValue:[NSString stringWithFormat:@"%f FPS", 1.0 / ( end - start )]];
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
	
	[defaults removeObjectForKey:PredatorCountDefaultsKey];
	[defaults removeObjectForKey:PresentationModeDefaultsKey];
	[defaults removeObjectForKey:PredatorMaxVelocityDefaultsKey];
	[defaults removeObjectForKey:BoidMaxVelocityDefaultsKey];
	[defaults removeObjectForKey:PredatorDistanceDefaultsKey];
	[defaults removeObjectForKey:BoidDistanceDefaultsKey];
	[defaults removeObjectForKey:CohesionMultiplierDefaultsKey];
	[defaults removeObjectForKey:AvoidanceMultiplierDefaultsKey];
	[defaults removeObjectForKey:VelocityMultiplierDefaultsKey];
	[defaults removeObjectForKey:PredatorMultiplierDefaultsKey];
	[defaults removeObjectForKey:WindXVelocityDefaultsKey];
	[defaults removeObjectForKey:WindYVelocityDefaultsKey];
}

- (void)togglePaused:(id)sender;
{
	self.paused = !self.paused;
	
	[sender setTitle:( self.paused ) ? @"Resume" : @"Pause"];
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
							  [NSNumber numberWithInteger:1], PredatorCountDefaultsKey,
							  [NSNumber numberWithBool:NO], PresentationModeDefaultsKey,
							  [NSNumber numberWithDouble:50.0], PredatorMaxVelocityDefaultsKey,
							  [NSNumber numberWithDouble:30.0], BoidMaxVelocityDefaultsKey,
							  [NSNumber numberWithDouble:1500.0], PredatorDistanceDefaultsKey,
							  [NSNumber numberWithDouble:100.0], BoidDistanceDefaultsKey,
							  [NSNumber numberWithDouble:1.0], CohesionMultiplierDefaultsKey,
							  [NSNumber numberWithDouble:1.0], AvoidanceMultiplierDefaultsKey,
							  [NSNumber numberWithDouble:1.0], VelocityMultiplierDefaultsKey,
							  [NSNumber numberWithDouble:1.0], PredatorMultiplierDefaultsKey,
							  [NSNumber numberWithDouble:0.0], WindXVelocityDefaultsKey, 
							  [NSNumber numberWithDouble:0.0], WindYVelocityDefaultsKey, nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
