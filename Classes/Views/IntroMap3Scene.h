//
//  IntroMap3Scene.h
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
@interface IntroMap3Scene : CCLayer {
    StatusDisplay* statusDisplay;
    CCSprite* displayedMessageSprite;
    CCSprite* tapCounterMessageSprite;
    CCSprite* sensorSiteSprite;
    CCSprite* sensorSprite;
    CCSprite* instructionSprite;
    SeekerSprite* seeker;
    NSInteger counter;
    NSInteger startCount;
    NSInteger seekerMoveCount;
    NSInteger energy;
    BOOL startMission;
    BOOL acceptTouches;
    BOOL moveSeeker;
    BOOL putPod;
    BOOL missionComplete;
    BOOL tapContinue;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCSprite* displayedMessageSprite;
@property (nonatomic, retain) CCSprite* tapCounterMessageSprite;
@property (nonatomic, retain) CCSprite* sensorSiteSprite;
@property (nonatomic, retain) CCSprite* sensorSprite;
@property (nonatomic, retain) CCSprite* instructionSprite;
@property (nonatomic, retain) SeekerSprite* seeker;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger startCount;
@property (nonatomic, assign) NSInteger seekerMoveCount;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) BOOL startMission;
@property (nonatomic, assign) BOOL acceptTouches;
@property (nonatomic, assign) BOOL moveSeeker;
@property (nonatomic, assign) BOOL putPod;
@property (nonatomic, assign) BOOL missionComplete;
@property (nonatomic, assign) BOOL tapContinue;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
