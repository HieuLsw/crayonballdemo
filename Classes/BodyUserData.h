//
//  BodyUserData.h
//  CrayonBallDemo
//
//  Created by rick on 09-7-11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AtlasSpriteManager.h"

#import "MyConstants.h"

@interface BodyUserData : NSObject {
@private
	BodyType mBodyType;
	AtlasSprite* mSprite;
	AtlasSpriteManager* mSpriteManager;
}

@property(readonly) BodyType bodyType;
@property(readonly) AtlasSprite* sprite;
@property(readonly) AtlasSpriteManager* spriteManager;

//使用bodytype,sprite,spritemanager初始化userdata
-(id) initWithBodyType:(BodyType) bodyType AtlasSprite:(AtlasSprite*) sprite AtlasSpriteManager:(AtlasSpriteManager*) sptmgr;
-(id) initWithBodyType:(BodyType) bodyType;
@end
