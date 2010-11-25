//
//  MapScene.h
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class SeekerSprite;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene : CCLayer {
    SeekerSprite* seeker1;
    NSInteger level;
    CGPoint screenCenter;
    CCTMXTiledMap* tileMap;
    CCTMXLayer* gameDisplay;
    CCTMXLayer* terrain;
    CCTMXLayer* items;
    CCTMXObjectGroup* pathObjects;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) SeekerSprite* seeker1;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) CGPoint screenCenter;
@property (nonatomic, retain) CCTMXTiledMap* tileMap;
@property (nonatomic, retain) CCTMXLayer* gameDisplay;
@property (nonatomic, retain) CCTMXLayer* terrain;
@property (nonatomic, retain) CCTMXLayer* items;
@property (nonatomic, retain) CCTMXObjectGroup* pathObjects;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
