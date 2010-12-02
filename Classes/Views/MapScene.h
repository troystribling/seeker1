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
typedef enum tagMapItemID {
    StationMapItemID,
    SensorSiteMapItemID,
    SensorMapItemID,
    SampleMapItemID,
} MapItemID;

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagMapID {
    EmptyMapID,
    Terrain1MapID,
    Terrain2MapID,
    Terrain3MapID,
    Terrain4MapID,
    Terrain5MapID,
} MapID;

//-----------------------------------------------------------------------------------------------------------------------------------
@class SeekerSprite;
@class StatusDisplay;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene : CCLayer {
    SeekerSprite* seeker1;
    StatusDisplay* statusDisplay;
    NSInteger level;
    NSInteger energyLevel;
    NSInteger energyCurrent;
    NSInteger speed;
    NSMutableDictionary* startSite;
    NSMutableArray* sensorSites;
    NSMutableArray* sampleSites;
    CGPoint screenCenter;
    CCTMXTiledMap* tileMap;
    CCTMXLayer* mapLayer;
    CCTMXLayer* terrainLayer;
    CCTMXLayer* itemsLayer;
    CCTMXObjectGroup* objectsLayer;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) SeekerSprite* seeker1;
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, assign) NSMutableDictionary* startSite;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger energyLevel;
@property (nonatomic, assign) NSInteger energyCurrent;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, retain) NSMutableArray* sensorSites;
@property (nonatomic, retain) NSMutableArray* sampleSites;
@property (nonatomic, assign) CGPoint screenCenter;
@property (nonatomic, retain) CCTMXTiledMap* tileMap;
@property (nonatomic, retain) CCTMXLayer* mapLayer;
@property (nonatomic, retain) CCTMXLayer* terrainLayer;
@property (nonatomic, retain) CCTMXLayer* itemsLayer;
@property (nonatomic, retain) CCTMXObjectGroup* objectsLayer;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;

@end
