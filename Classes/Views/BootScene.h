//
//  BootScene.h
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BootScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCLabel* bootingLabel;
    CCLabel* productLabel;
    CCSprite* postRunning;
    CCSprite* postOK;
    CCSprite* consoleStarting;
    CCSprite* consoleStarted;
    CCSprite* connecting;
    CCSprite* connected;
    NSInteger counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabel* bootingLabel;
@property (nonatomic, retain) CCLabel* productLabel;
@property (nonatomic, retain) CCSprite* postRunning;
@property (nonatomic, retain) CCSprite* postOK;
@property (nonatomic, retain) CCSprite* consoleStarting;
@property (nonatomic, retain) CCSprite* consoleStarted;
@property (nonatomic, retain) CCSprite* connecting;
@property (nonatomic, retain) CCSprite* connected;
@property (nonatomic, assign) NSInteger counter;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
