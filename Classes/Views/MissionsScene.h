//
//  MissionsScene.h
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;
@class TermMenuView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MissionsScene : CCLayer {
    StatusDisplay* statusDisplay;
    NSInteger quadrangle;
    NSInteger levelsUnlocked;
    CGSize screenSize;    
    TermMenuView* menu;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSInteger quadrangle;
@property (nonatomic, assign) NSInteger levelsUnlocked;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, retain) TermMenuView* menu;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
