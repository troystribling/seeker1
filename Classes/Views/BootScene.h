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
    CCLabelTTF* bootingLabel;
    CCLabelTTF* productLabel;
    CCLabelTTF* post;
    CCLabelTTF* console;
    CCLabelTTF* connection;
    NSInteger counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabelTTF* bootingLabel;
@property (nonatomic, retain) CCLabelTTF* productLabel;
@property (nonatomic, retain) CCLabelTTF* post;
@property (nonatomic, retain) CCLabelTTF* console;
@property (nonatomic, retain) CCLabelTTF* connection;
@property (nonatomic, assign) NSInteger counter;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
