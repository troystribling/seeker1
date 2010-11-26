//
//  SeekerSprite.h
//  seeker1
//
//  Created by Troy Stribling on 11/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeekerSprite : CCSprite {
    BOOL isUninitiailized;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) BOOL isUninitiailized;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)setToStartPoint:(CGPoint)_point withOrientation:(NSString*)_orientation;
- (void)moveToPoint:(CGPoint)_point;

@end
