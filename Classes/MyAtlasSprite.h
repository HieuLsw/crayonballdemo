//
//  MyAtlasSpriteCategory.h
//  CrayonBallDemo
//
//  Created by rick on 09-7-13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AtlasSpriteManager.h"

@interface MyAtlasSprite : AtlasSprite {
@private
	ParticleSystem* mEmitter;
}
@property(nonatomic,retain) ParticleSystem* emitter;
@end
