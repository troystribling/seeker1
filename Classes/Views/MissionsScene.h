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
@class NavigationDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MissionsScene : CCLayer {
    NavigationDisplay* navigationDisplay;
    NSInteger quadrangle;
    NSInteger levelsUnlocked;
    CGSize screenSize;    
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NavigationDisplay* navigationDisplay;
@property (nonatomic, assign) NSInteger quadrangle;
@property (nonatomic, assign) NSInteger levelsUnlocked;
@property (nonatomic, assign) CGSize screenSize;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
