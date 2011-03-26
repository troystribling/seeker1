//
//  AnimatedSprite.m
//  seeker1
//
//  Created by Troy Stribling on 3/25/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import "AnimatedSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AnimatedSprite (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AnimatedSprite

//===================================================================================================================================
#pragma mark AnimatedSprite PrivateAPI

//===================================================================================================================================
#pragma mark AnimatedSprite

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)animationFromFile:(NSString*)_file withFrameCount:(int)_frameCount andDelay:(CGFloat)_delay {
    return [[[self alloc] initFromFile:_file withFrameCount:_frameCount andDelay:_delay] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initFromFile:(NSString*)_file withFrameCount:(int)_frameCount andDelay:(CGFloat)_delay {
    NSString* plistFile = [NSString stringWithFormat:@"%@.plist", _file];
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile:plistFile];
    NSString* frameName = [NSString stringWithFormat:@"%@.png", _file];
	if ((self = [super initWithSpriteFrameName:frameName])) {
		CCAnimation* anim = [CCAnimation animationWithFrame:_file frameCount:_frameCount delay:_delay];
		CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
		[self runAction:repeat];
		[self scheduleUpdate];
	}
	return self;
}

@end
