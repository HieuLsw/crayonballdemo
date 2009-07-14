/*
 *  MyBoundaryListener.cpp
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-12.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#include <cassert>
#import <Foundation/Foundation.h>
#include "MyBoundaryListener.h"

void MyBoundaryListener::Violation(b2Body* body) {
	mViolatedBodies.push_back(body);
	NSLog(@"Body Violated:%x",body);
}

void MyBoundaryListener::RemoveViolatedBodiesFromWorld(b2World* world) {
	assert(world!=NULL);
	
	//将所有超出范围的body从world中删除
	std::vector<b2Body*>::iterator itr = mViolatedBodies.begin();
	for (;itr<mViolatedBodies.end();itr++){
		world->DestroyBody(*itr);
	}
	
	//清理vector
	mViolatedBodies.clear();
}