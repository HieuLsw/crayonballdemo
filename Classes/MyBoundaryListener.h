/*
 *  MyBoundaryListener.h
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-12.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef MyBoundaryListener_H
#define MyBoundaryListener_H

#include <vector>
#include "Box2D.h"

class MyBoundaryListener : public b2BoundaryListener {
public:
	void Violation(b2Body* body);
	void RemoveViolatedBodiesFromWorld(b2World* world);
private:
	std::vector<b2Body*> mViolatedBodies;
};
#endif