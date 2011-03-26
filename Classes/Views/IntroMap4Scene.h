//
//  IntroMap4Scene.h
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
@interface IntroMap4Scene : CCLayer {
    StatusDisplay* statusDisplay;
    CCSprite* displayedMessageSprite;
    CCSprite* tapCounterMessageSprite;
    CCSprite* sampleSprite;
    CCSprite* instructionSprite;
    SeekerSprite* seeker;
    NSInteger counter;
    NSInteger messageDisplayedCount;
    NSInteger tapCounter;
    NSInteger startCount;
    NSInteger instructionCount;
    NSInteger seekerMoveCount;
    NSInteger energy;
    BOOL startMission;
    BOOL setInstructionCounter;
    BOOL stopMission;
    BOOL acceptTouches;
    BOOL moveSeekerDown;
    BOOL moveSeekerUp;
    BOOL getSample;
    BOOL turnLeft1;
    BOOL tuenLeft2;
    BOOL missionComplete;
    BOOL tapContinue;
}

//-----------------------------------------------------------------------------------------------------------------------------------
    @property (nonatomic, retain) StatusDisplay* statusDisplay;
    @property (nonatomic, retain) CCSprite* displayedMessageSprite;
    @property (nonatomic, retain) CCSprite* tapCounterMessageSprite;
    @property (nonatomic, retain) CCSprite* sampleSprite;
    @property (nonatomic, retain) CCSprite* instructionSprite;
    @property (nonatomic, retain) SeekerSprite* seeker;
    @property (nonatomic, assign) NSInteger tapCounter;
    @property (nonatomic, assign) NSInteger startCount;
    @property (nonatomic, assign) NSInteger instructionCount;
    @property (nonatomic, assign) NSInteger counter;
    @property (nonatomic, assign) NSInteger messageDisplayedCount;
    @property (nonatomic, assign) NSInteger seekerMoveCount;
    @property (nonatomic, assign) NSInteger energy;
    @property (nonatomic, assign) BOOL setInstructionCounter;
    @property (nonatomic, assign) BOOL startMission;
    @property (nonatomic, assign) BOOL stopMission;
    @property (nonatomic, assign) BOOL acceptTouches;
    @property (nonatomic, assign) BOOL moveSeekerDown;
    @property (nonatomic, assign) BOOL moveSeekerUp;
    @property (nonatomic, assign) BOOL getSample;
    @property (nonatomic, assign) BOOL turnLeft1;
    @property (nonatomic, assign) BOOL turnLeft2;
    @property (nonatomic, assign) BOOL missionComplete;
    @property (nonatomic, assign) BOOL tapContinue;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
