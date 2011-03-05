//
//  QuadsScene.h
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagQuadType {
    TharsisQuadType,
    MemnoniaQuadType,
    ElysiumQuadType,
} QuadType;

//-----------------------------------------------------------------------------------------------------------------------------------
@class NavigationDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene : CCLayer {
    NavigationDisplay* navigationDisplay;
    CCSprite* tharsisSprite;
    CCSprite* memnoniaSprite;
    CCSprite* elysiumSprite;
    CCLabel* titleLabel;
    QuadType displayedQuad; 
    CGPoint screenCenter;
    CGPoint firstTouch;
    BOOL setTitle;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) NavigationDisplay* navigationDisplay;
@property (nonatomic, retain) CCSprite* tharsisSprite;
@property (nonatomic, retain) CCSprite* memnoniaSprite;
@property (nonatomic, retain) CCSprite* elysiumSprite;
@property (nonatomic, retain) CCLabel* titleLabel;
@property (nonatomic, assign) QuadType displayedQuad;
@property (nonatomic, assign) CGPoint screenCenter;
@property (nonatomic, assign) CGPoint firstTouch;
@property (nonatomic, assign) BOOL setTitle;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
