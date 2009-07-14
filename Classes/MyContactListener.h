/*
 *  MyContactListener.h
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef MyContactListener_H
#define MyContactListener_H

#include <vector>
#include "Box2D.h"

#include "MyConstants.h"

using namespace std;


struct ContactPoint
{
	b2Shape* shape1;
	b2Shape* shape2;
	b2Vec2 normal;
	b2Vec2 position;
	b2Vec2 velocity;
	uint32 key;
	ContactState state;
};

class MyContactListener : public b2ContactListener 
{
public:
	MyContactListener();
	//Methods override from b2ContactListener
	void Add(const b2ContactPoint* point) ;
	void Persist(const b2ContactPoint* point);
	void Remove(const b2ContactPoint* point);
	
	//获取contact point的stl容器
	const vector<ContactPoint>& GetContactPoints();
	
	//clear contact point vector
	void Clear();
private:
	vector<ContactPoint> mContactPointVector;//保存contactpoint的stl容器
};
#endif