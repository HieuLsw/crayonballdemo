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

/*
 * Box2D joint和shape的删除事件监听器实现类。主要实现当接收shape的删除事件时，清除其对应body的userdata
 */
class MyDestructionListener : public b2DestructionListener {
public:
	void SayGoodbye(b2Joint* joint) { B2_NOT_USED(joint); }
	void SayGoodbye(b2Shape* shape);
};
#endif