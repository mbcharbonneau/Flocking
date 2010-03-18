//
//  FlockingAppDelegate.h
//  Flocking
//
//  Created by Marc Charbonneau on 3/18/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FlockingAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
