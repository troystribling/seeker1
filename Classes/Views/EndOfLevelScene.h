//
//  EndOfLevelScene.h
//  seeker1
//
//  Created by Troy Stribling on 1/25/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfLevelScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCLabel* title;
    CCLabel* samplesReturned;
    CCLabel* samplesCollected;
    CCLabel* sensorsPlaced;
    CCLabel* energyBonus;
    CCLabel* levelCompletedBonus;
    CCLabel* totalScore;
    NSInteger counter;
    BOOL levelCompleted;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) BOOL levelCompleted;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
