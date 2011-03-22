//
//  IntroScene.h
//  seeker1
//
//  Created by Troy Stribling on 3/21/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroScene : CCLayer {
    CCSprite* displayedMessageSprite;
    CCSprite* tapCounterMessageSprite;
    NSInteger messageDisplayedCount;;
    NSInteger tapCounter;
    NSInteger counter;
    NSInteger maxTaps;
    BOOL acceptTouches;
    BOOL readyForPrompt;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) CCSprite* displayedMessageSprite;
@property (nonatomic, retain) CCSprite* tapCounterMessageSprite;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger messageDisplayedCount;
@property (nonatomic, assign) NSInteger tapCounter;
@property (nonatomic, assign) NSInteger maxTaps;
@property (nonatomic, assign) BOOL acceptTouches;
@property (nonatomic, assign) BOOL readyForPrompt;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMessage;
- (void)showPrompt;

@end
