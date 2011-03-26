//
//  AnimatedSprite.h
//  seeker1
//
//  Created by Troy Stribling on 3/25/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "CCAnimationHelper.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AnimatedSprite : CCSprite {
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)animationFromFile:(NSString*)_file withFrameCount:(int)_frameCount andDelay:(CGFloat)_delay;
- (id)initFromFile:(NSString*)_file withFrameCount:(int)_frameCount andDelay:(CGFloat)_delay;

@end
