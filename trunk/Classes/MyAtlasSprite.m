//
//  MyAtlasSpriteCategory.m
//  CrayonBallDemo
//
//  Created by rick on 09-7-13.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyAtlasSprite.h"


@implementation MyAtlasSprite
@synthesize emitter=mEmitter;

-(void) setPosition:(CGPoint) pos {
	[super setPosition:pos];
	if (mEmitter!=nil)
		mEmitter.position = pos;
}

-(void) dealloc {
	[mEmitter release];
	[super dealloc];
}
@end
