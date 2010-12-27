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
@class StatusDisplay;
@class TermMenuView;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene : CCLayer {
    StatusDisplay* statusDisplay;
    CCSprite* tharsisSprite;
    CCSprite* memnoniaSprite;
    CCSprite* elysiumSprite;
    QuadType displayedQuad; 
    CGPoint screenCenter;
    CGPoint firstTouch;
    CGRect menuRect;
    TermMenuView* menu;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) CCSprite* tharsisSprite;
@property (nonatomic, retain) CCSprite* memnoniaSprite;
@property (nonatomic, retain) CCSprite* elysiumSprite;
@property (nonatomic, assign) QuadType displayedQuad;
@property (nonatomic, assign) CGPoint screenCenter;
@property (nonatomic, assign) CGPoint firstTouch;
@property (nonatomic, assign) CGRect menuRect;
@property (nonatomic, retain) TermMenuView* menu;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
