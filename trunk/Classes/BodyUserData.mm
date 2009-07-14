//
//  BodyUserData.m
//  CrayonBallDemo
//
//  Created by rick on 09-7-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BodyUserData.h"


@implementation BodyUserData
@synthesize bodyType = mBodyType; 
@synthesize sprite = mSprite;
@synthesize spriteManager = mSpriteManager;

-(id) initWithBodyType:(BodyType) bodyType AtlasSprite:(AtlasSprite*) sprite AtlasSpriteManager:(AtlasSpriteManager*) sptmgr {
	if (self=[super init]){
		mBodyType = bodyType;
		mSprite = sprite;
		[mSprite retain];
		
		mSpriteManager = sptmgr;
		[mSpriteManager retain];
	}
	return self;
}

-(id) initWithBodyType:(BodyType) bodyType {
	self=[self initWithBodyType:bodyType AtlasSprite:nil AtlasSpriteManager:nil];
	return self;
}

-(void) dealloc{
	[mSpriteManager release];
	[mSprite release];
	[super dealloc];
}
@end
