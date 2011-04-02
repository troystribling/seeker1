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
    NSMutableDictionary* startSite;
    NSMutableArray* seekerPath;
    NSInteger level;
    NSInteger endOfMissionCounter;
    CGPoint screenCenter;
    CGPoint firstTouch;
    CGPoint onTouchMoveDelta;
    CGSize tileMapSize;
    CCTMXTiledMap* tileMap;
    CCTMXLayer* mapLayer;
    CCTMXLayer* terrainLayer;
    CCTMXLayer* itemsLayer;
    CCTMXLayer* sandLayer;
    CCTMXObjectGroup* objectsLayer;
    CCSprite* crashSprite;
    CCSprite* victorySprite;
    CCMenu* menu;
    NSInteger counter;
    NSInteger crashAnimationCounter;
    NSInteger victoryAnimationCounter;
    BOOL levelResetSeeker;
    BOOL levelResetMap;
    BOOL levelCrash;
    BOOL levelInitSeeker;
    BOOL levelInitZoom;
    BOOL levelInitialized;
    BOOL levelCompleted;
    BOOL nextLevel;
    BOOL movingMapOnTouch;
    BOOL centeringOnSeekerPosition;
    BOOL zoomingMap;
    BOOL mapZoomedOut;
    BOOL checkLevelCompleted;
    BOOL canTouch;
    BOOL pinchDetected;
    BOOL featureUnlocked;
    BOOL gameOver;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) SeekerSprite* seeker1;
@property (nonatomic, retain) StatusDisplay* statusDisplay;
@property (nonatomic, retain) NSMutableDictionary* startSite;
@property (nonatomic, retain) NSMutableArray* seekerPath;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger endOfMissionCounter;
@property (nonatomic, assign) CGPoint screenCenter;
@property (nonatomic, assign) CGPoint firstTouch;
@property (nonatomic, assign) CGPoint onTouchMoveDelta;
@property (nonatomic, assign) CGSize tileMapSize;
@property (nonatomic, retain) CCTMXTiledMap* tileMap;
@property (nonatomic, retain) CCTMXLayer* mapLayer;
@property (nonatomic, retain) CCTMXLayer* terrainLayer;
@property (nonatomic, retain) CCTMXLayer* itemsLayer;
@property (nonatomic, retain) CCTMXLayer* sandLayer;
@property (nonatomic, retain) CCTMXObjectGroup* objectsLayer;
@property (nonatomic, retain) CCSprite* crashSprite;
@property (nonatomic, retain) CCSprite* victorySprite;
@property (nonatomic, retain) CCMenu* menu;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger crashAnimationCounter;
@property (nonatomic, assign) NSInteger victoryAnimationCounter;
@property (nonatomic, assign) BOOL levelResetSeeker;
@property (nonatomic, assign) BOOL levelResetMap;
@property (nonatomic, assign) BOOL levelCrash;
@property (nonatomic, assign) BOOL levelInitSeeker;
@property (nonatomic, assign) BOOL levelInitZoom;
@property (nonatomic, assign) BOOL levelInitialized;
@property (nonatomic, assign) BOOL levelCompleted;
@property (nonatomic, assign) BOOL nextLevel;
@property (nonatomic, assign) BOOL movingMapOnTouch;
@property (nonatomic, assign) BOOL centeringOnSeekerPosition;
@property (nonatomic, assign) BOOL zoomingMap;
@property (nonatomic, assign) BOOL mapZoomedOut;
@property (nonatomic, assign) BOOL checkLevelCompleted;
@property (nonatomic, assign) BOOL canTouch;
@property (nonatomic, assign) BOOL pinchDetected;
@property (nonatomic, assign) BOOL featureUnlocked;
@property (nonatomic, assign) BOOL gameOver;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene;
- (void)resetLevel;

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary*)getTileProperties:(CGPoint)_point forLayer:(CCTMXLayer*)_layer;
- (CGPoint)getSeekerTile;
- (NSInteger)terrainGradient;
- (BOOL)isTerrainClear:(NSInteger)_gradient;
- (BOOL)positionIsInPlayingArea:(CGPoint)_position;
- (CGPoint)moveDeltaTileCoords;
- (CGPoint)moveDeltaScreenCoords:(CGPoint)_delta;
- (CGPoint)nextPositionForDelta:(CGPoint)_delta;
- (CGPoint)nextPosition;

@end
