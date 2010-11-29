//
//  StartScene.h
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
@interface StartScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCLabel* bootingLabel;
    CCLabel* consoleLabel;
    CCLabel* protocolsLabel;
    CCLabel* connectingLabel;
    CCLabel* productLabel;
    NSInteger counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabel* bootingLabel;
@property (nonatomic, retain) CCLabel* consoleLabel;
@property (nonatomic, retain) CCLabel* protocolsLabel;
@property (nonatomic, retain) CCLabel* connectingLabel;
@property (nonatomic, retain) CCLabel* productLabel;
@property (nonatomic, assign) NSInteger counter;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
