//
//  NavigationDisplay.m
//  seeker1
//
//  Created by Troy Stribling on 3/4/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "NavigationDisplay.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NavigationDisplay (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NavigationDisplay

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark NavigationDisplay PrivateAPI

//===================================================================================================================================
#pragma mark NavigationDisplay

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)createWithTarget:(id)_target andSelector:(SEL)_selector {
    return [[[self alloc] initWithTarget:(id)_target andSelector:_selector] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert:(CCLayer*)_layer {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect rect = self.textureRect;
    self.position = CGPointMake(0.0f, screenSize.height-rect.size.height);
    [_layer addChild:self z:10];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithTarget:(id)_target andSelector:(SEL)_selector {
	if((self=[super initWithFile:@"terminal-launcher.png"])) {
        self.anchorPoint = CGPointMake(0.0, 0.0);
        CCSprite* backSprite = [CCSprite spriteWithFile:@"terminal-launcher-back.png"];
        CCMenuItemSprite* backItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSprite target:_target selector:_selector];
        CCMenu* menu = [CCMenu menuWithItems:backItem, nil];
        [menu alignItemsHorizontallyWithPadding:0.0];
        menu.position = CGPointMake(60.0, 32.5);
        [self addChild:menu];
	}
	return self;
}

@end
