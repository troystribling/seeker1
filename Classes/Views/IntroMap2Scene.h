//
//  IntroMap2Scene.h
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;
@class SeekerSprite;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroMap2Scene : CCLayer {
    StatusDisplay* statusDisplay;
    CCSprite* displayedMessageSprite;
    CCSprite* tapCounterMessageSprite;
    CCSprite* sensorSiteSprite;
    CCSprite* sensorSprite;
    SeekerSprite* seeker;
    NSInteger counter;
    NSInteger messageDisplayedCount;;
    NSInteger tapCounter;
    NSInteger energy;
    BOOL acceptTouches;
    BOOL readyForItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCSprite* displayedMessageSprite;
@property (nonatomic, retain) CCSprite* tapCounterMessageSprite;
@property (nonatomic, retain) CCSprite* sensorSiteSprite;
@property (nonatomic, retain) CCSprite* sensorSprite;
@property (nonatomic, retain) SeekerSprite* seeker;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger messageDisplayedCount;
@property (nonatomic, assign) NSInteger tapCounter;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) BOOL acceptTouches;
@property (nonatomic, assign) BOOL readyForItem;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
