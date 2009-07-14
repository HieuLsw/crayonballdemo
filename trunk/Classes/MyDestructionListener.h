/*
 *  MyDestructionListener.h
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef DestructionListener_H
#define DestructionListener_H
#include "Box2D.h"

class MyDestructionListener : public b2DestructionListener {
public:
	void SayGoodbye(b2Joint* joint) { B2_NOT_USED(joint); }
	void SayGoodbye(b2Shape* shape);
};
#endif