//
//  UploadScene.h
//  seeker1
//
//  Created by Troy Stribling on 1/27/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UploadScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCLabel* percentUploadLabel;
    CCLabel* uploadProgressLabel;
    NSInteger counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCLabel* percentUploadLabel;
@property (nonatomic, retain) CCLabel* uploadProgressLabel;
@property (nonatomic, assign) NSInteger counter;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
