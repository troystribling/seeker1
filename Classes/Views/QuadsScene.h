//
//  QuadsScene.h
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCSprite* tharsisSprite;
    CGPoint tharsisPosition;
    CCSprite* memnoniaSprite;
    CGPoint memnoniaPosition;
    CCSprite* elysiumSprite;
    CGPoint elysiumPosition;
    CCSprite* displayedSprite; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCSprite* tharsisSprite;
@property (nonatomic, assign) CGPoint tharsisPosition;
@property (nonatomic, retain) CCSprite* memnoniaSprite;
@property (nonatomic, assign) CGPoint memnoniaPosition;
@property (nonatomic, retain) CCSprite* elysiumSprite;
@property (nonatomic, assign) CGPoint elysiumPosition;
@property (nonatomic, assign) CCSprite* displayedSprite;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
