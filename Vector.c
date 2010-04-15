/*
 *  Vector.c
 *  Flocking
 *
 *  Created by Marc Charbonneau on 4/15/10.
 *  Copyright 2010 Downtown Software House. All rights reserved.
 *
 */

#import "Vector.h"

Vector MakeVector( double x, double y )
{
	Vector result = { x, y };
	return result;
}

Vector AddVector( Vector v1, Vector v2 )
{
	Vector result = { v1.x + v2.x, v1.y + v2.y };
	return result;
}

Vector MultiplyVector( Vector v, double amount )
{
	Vector result;
	result.x = v.x * amount;
	result.y = v.y * amount;
	return result;
}
