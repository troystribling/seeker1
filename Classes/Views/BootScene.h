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
    CCLabel* post;
    CCLabel* console;
    CCLabel* connection;
    NSInteger counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabel* bootingLabel;
@property (nonatomic, retain) CCLabel* productLabel;
@property (nonatomic, retain) CCLabel* post;
@property (nonatomic, retain) CCLabel* console;
@property (nonatomic, retain) CCLabel* connection;
@property (nonatomic, assign) NSInteger counter;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
