//
//  EndOfSiteScene.h
//  seeker1
//
//  Created by Troy Stribling on 3/14/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EndOfSiteScene : CCLayer {
    StatusDisplay* statusDisplay;
    NSInteger counter;
    BOOL showNextMenu;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) BOOL showNextMenu;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
