//
//  CCAnimationHelper.m
//  SpriteBatches
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CCAnimationHelper.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CCAnimation (Helper)

//===================================================================================================================================
#pragma mark CCAnimationHelper

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CCAnimation*)animationWithFile:(NSString*)_name frameCount:(int)_frameCount delay:(CGFloat)_delay {
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:_frameCount];
	for (int i = 0; i < _frameCount; i++) {
		NSString* file = [NSString stringWithFormat:@"%@-%i.png", _name, i];
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:file];
		CGSize texSize = texture.contentSize;
		CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];		
		[frames addObject:frame];
	}
	return [CCAnimation animationWithFrames:frames delay:_delay];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CCAnimation*)animationWithFrame:(NSString*)_frame frameCount:(int)_frameCount delay:(CGFloat)_delay {
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:_frameCount];
	for (int i = 1; i < _frameCount; i++) {
		NSString* file = [NSString stringWithFormat:@"%@-%i.png", _frame, i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	return [CCAnimation animationWithFrames:frames delay:_delay];
}

@end
