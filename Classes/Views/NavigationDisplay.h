//
//  NavigationDisplay.h
//  seeker1
//
//  Created by Troy Stribling on 3/4/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NavigationDisplay : CCSprite {
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)createWithTarget:(id)_target andSelector:(SEL)_selector;
- (void)insert:(CCLayer*)_layer;
- (id)initWithTarget:(id)_target andSelector:(SEL)_selector;

@end
