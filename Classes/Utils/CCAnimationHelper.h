//
//  CCAnimationHelper.h
//  SpriteBatches
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CCAnimation (Helper) 

+(CCAnimation*) animationWithFile:(NSString*)_name frameCount:(int)_frameCount delay:(CGFloat)_delay;
+(CCAnimation*) animationWithFrame:(NSString*)_frame frameCount:(int)_frameCount delay:(CGFloat)_delay;

@end
