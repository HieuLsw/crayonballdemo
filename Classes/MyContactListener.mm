/*
 *  MyContactListener.cpp
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#include "MyContactListener.h"


MyContactListener::MyContactListener(){}

void MyContactListener::Add(const b2ContactPoint* point){
	ContactPoint cp;
	cp.shape1 = point->shape1;
	cp.shape2 = point->shape2;
	cp.normal = point->normal;
	cp.position = point->position;
	cp.velocity = point->velocity;
	cp.key = point->id.key;
	mContactPointVector.push_back(cp);
}

void MyContactListener::Persist(const b2ContactPoint* point){
}

void MyContactListener::Remove(const b2ContactPoint* point){
	/*
	b2ContactID cid = point->id;
	b2Shape* shape1 = point->shape1;
	b2Shape* shape2 = point->shape2;
	
	std::vector<ContactPoint>::iterator itr = mContactPointVector.begin();
	for (;itr!=mContactPointVector.end();itr++){
			if ((*itr).key==cid.key&&(*itr).shape1==shape1&&(*itr).shape2==shape2)
				mContactPointVector.erase(itr,itr+1);
	}
	NSLog(@"Remove Contact Point:%d",point->id.key);
	 */
}

const std::vector<ContactPoint>& MyContactListener::GetContactPoints(){
	return mContactPointVector;
}

void MyContactListener::Clear(){
	mContactPointVector.clear();
	//NSLog(@"clear");
}

