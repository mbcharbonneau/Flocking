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

@implementation FlockingAppDelegate

#pragma mark FlockingAppDelegate Methods

@synthesize window = _window;
@synthesize view = _view;
@synthesize timerTextField = _timerTextField;
@synthesize flock = _flock;
@synthesize updateTimer = _updateTimer;

- (void)update:(id)sender;
{
	NSTimeInterval start, end;
	
	start = [NSDate timeIntervalSinceReferenceDate];
	[self.flock update];
	end = [NSDate timeIntervalSinceReferenceDate];
	
	[self.timerTextField setStringValue:[NSString stringWithFormat:@"%f seconds", end - start]];
	
	[self.view setNeedsDisplay:YES];
}

#pragma mark NSApplication Delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
	self.flock = [[Flock alloc] initWithCount:10000];
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
	self.view.flock = self.flock;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification;
{
	[self.updateTimer invalidate];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
{
	return YES;
}

@end
