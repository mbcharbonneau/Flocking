//
//  Vector.h
//  Flocking
//
//  Created by Marc Charbonneau on 4/14/10.
//  Copyright 2010 Downtown Software House. All rights reserved.
//

struct Vector
{
	double x;
	double y;
};
typedef struct Vector Vector;

const Vector ZeroVector;

Vector MakeVector( double x, double y );
Vector AddVector( Vector v1, Vector v2 );
Vector MultiplyVector( Vector v, double amount );
