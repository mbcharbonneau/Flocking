//
//  Constants.h
//  Flocking
//
//  Created by Marc Charbonneau on 4/16/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *PredatorCountDefaultsKey;
extern NSString *PresentationModeDefaultsKey;

extern NSString *PredatorMaxVelocityDefaultsKey;
extern NSString *BoidMaxVelocityDefaultsKey;

extern NSString *PredatorDistanceDefaultsKey;
extern NSString *BoidDistanceDefaultsKey;
extern NSString *BoidFlockDistanceDefaultsKey;

extern NSString *CohesionMultiplierDefaultsKey;
extern NSString *AvoidanceMultiplierDefaultsKey;
extern NSString *VelocityMultiplierDefaultsKey;
extern NSString *PredatorMultiplierDefaultsKey;

extern NSString *WindXVelocityDefaultsKey;
extern NSString *WindYVelocityDefaultsKey;

extern NSString *UpdateMethodKey;

typedef enum
{
	Sequential = 0,
	SMPMethodA = 1,
	SMPMethodB = 2,
	Cluster = 3
} UpdateMethod;
