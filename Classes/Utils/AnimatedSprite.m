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
+ (id)animationFromFile:(NSString*)_file {
    return [[[self alloc] initFromFile:_file] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initFromFile:(NSString*)_file {
    NSArray* fileComponents = [_file componentsSeparatedByString:@"."];
    NSString* plistFile = [NSString stringWithFormat:@"%@.plist", [fileComponents objectAtIndex:0]];
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile:plistFile];
	if ((self = [super initWithFile:_file capacity:10])) {
		CCAnimation* anim = [CCAnimation animationWithFrame:@"ship-anim" frameCount:5 delay:0.08f];
		CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
		[self runAction:repeat];
		[self scheduleUpdate];
	}
	return self;
}

@end
