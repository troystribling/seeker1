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
    NSInteger counter;
    LevelModel* level;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, retain) LevelModel* level;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
