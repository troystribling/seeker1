//
//  IntroMap5Scene.h
//  seeker1
//
//  Created by Troy Stribling on 3/17/11.
//  Copyright 2011 imaginary products. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface IntroMap5Scene : CCLayer {
    StatusDisplay* statusDisplay;
    NSInteger counter;
    BOOL acceptTouches;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) BOOL acceptTouches;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
