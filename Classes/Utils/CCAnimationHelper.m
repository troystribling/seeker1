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
+ (CCAnimation*)animationWithFile:(NSString*)name frameCount:(int)frameCount delay:(CGFloat)delay {
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 0; i < frameCount; i++) {
		NSString* file = [NSString stringWithFormat:@"%@-%i.png", name, i];
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:file];
		CGSize texSize = texture.contentSize;
		CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:texRect offset:CGPointZero];		
		[frames addObject:frame];
	}
	return [CCAnimation animationWithName:name delay:delay frames:frames];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (CCAnimation*)animationWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(CGFloat)delay {
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 0; i < frameCount; i++) {
		NSString* file = [NSString stringWithFormat:@"%@%i.png", frame, i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	return [CCAnimation animationWithName:frame delay:delay frames:frames];
}

@end
