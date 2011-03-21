//
//  IntroInstruction1Scene.h
//  seeker1
//
//  Created by Troy Stribling on 3/16/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroInstruction1Scene : CCLayer {
    CCSprite* displayedMessageSprite;
    CCSprite* tapCounterMessageSprite;
    NSInteger messageDisplayedCount;;
    NSInteger tapCounter;
    NSInteger counter;
    BOOL acceptTouches;
    BOOL readyForPrompt;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) CCSprite* displayedMessageSprite;
@property (nonatomic, retain) CCSprite* tapCounterMessageSprite;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger messageDisplayedCount;
@property (nonatomic, assign) NSInteger tapCounter;
@property (nonatomic, assign) BOOL acceptTouches;
@property (nonatomic, assign) BOOL readyForPrompt;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
