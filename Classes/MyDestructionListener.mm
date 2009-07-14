/*
 *  MyDestructionListener.cpp
 *  CrayonBallDemo
 *
 *  Created by rick on 09-7-11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "MyDestructionListener.h"
#include "MyConstants.h"
#include "BodyUserData.h"
#import <Foundation/Foundation.h>

void MyDestructionListener::SayGoodbye(b2Shape* shape){
	NSLog(@"Goodby to shape:%e",shape);
	BodyUserData* userData = static_cast<BodyUserData*> (shape->GetBody()->GetUserData());
	if (userData==nil)
		return;
	if (userData.sprite!=nil&&userData.spriteManager!=nil){
		[userData.spriteManager removeChild:userData.sprite cleanup:YES];
		[userData release];
	}
	shape->GetBody()->SetUserData(NULL);
}