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
@class LevelModel;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfLevelScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCLabel* titleLabel;
    CCLabel* samplesReturnedLabel;
    CCLabel* samplesCollectedLabel;
    CCLabel* sensorsPlacedLabel;
    CCLabel* energyBonusLabel;
    CCLabel* levelCompletedBonusLabel;
    CCLabel* totalScoreLabel;
    NSInteger counter;
    LevelModel* level;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabel* titleLabel;
@property (nonatomic, retain) CCLabel* samplesReturnedLabel;
@property (nonatomic, retain) CCLabel* samplesCollectedLabel;
@property (nonatomic, retain) CCLabel* sensorsPlacedLabel;
@property (nonatomic, retain) CCLabel* energyBonusLabel;
@property (nonatomic, retain) CCLabel* levelCompletedBonusLabel;
@property (nonatomic, retain) CCLabel* totalScoreLabel;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, retain) LevelModel* level;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
