//
//  MapScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapScene.h"
#import "EndOfLevelScene.h"
#import "UserModel.h"
#import "LevelModel.h"
#import "ProgramModel.h"
#import "SeekerSprite.h"
#import "StatusDisplay.h"
#import "ProgramNgin.h"
#import "TouchUtils.h"
#import "ViewControllerManager.h"
#import "MainScene.h"
#import "MissionsScene.h"
#import "AnimatedSprite.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kERROR_CODE_HIT_MAP_BOUNDARY        @"A-1654"
#define kERROR_MSG_HIT_MAP_BOUNDARY         @"map boundary"
#define kERROR_CODE_NO_ENERGY               @"E-3967"
#define kERROR_MSG_NO_ENERGY                @"energy depleted"
#define kERROR_CODE_SPEED_HIGH              @"S-1471"
#define kERROR_MSG_SPEED_HIGH               @"maximum speed"
#define kERROR_CODE_SPEED_LOW               @"S-1013"
#define kERROR_MSG_SPEED_LOW                @"minimum speed"
#define kERROR_CODE_PROGRAM_CRASH           @"P-1962"
#define kERROR_MSG_PROGRAM_CRASH            @"program error"
#define kERROR_CODE_TERRRAIN                @"T-3891"
#define kERROR_MSG_TERRRAIN                 @"terrain gradient"
#define kERROR_CODE_SENSOR_BIN_EMPTY        @"B-1951"
#define kERROR_MSG_SENSOR_BIN_EMPTY         @"pod bin empty"
#define kERROR_CODE_EXPECTED_SENSOR         @"S-1453"
#define kERROR_MSG_EXPECTED_SENSOR          @"expected pod site"
#define kERROR_CODE_SAMPLE_BIN_FULL         @"B-1181"
#define kERROR_MSG_SAMPLE_BIN_FULL          @"sample bin full"
#define kERROR_CODE_EXPECTED_SAMPLE         @"S-3571"
#define kERROR_MSG_EXPECTED_SAMPLE          @"expected sample"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAP_EDGE_BUFFER                0
#define kMAP_INVERSE_PAN_SPEED          0.001
#define kMAP_ZOOM_FACTOR                0.5
#define kMAP_ZOOM_DURATION              1.0
#define kMAP_INIT_TRANS_BASE_LENGTH     90.0;
#define kEND_OF_LEVEL_COUNT             50
#define kSEEKER_DELTA_ENERGY            2
#define kSEEKER_DELTA_ENERGY_MIN        1
#define kSEEKER_DELTA_ENERGY_MAX        4
#define kCRASH_DURATION                 1.0
#define kCRASH_ANIMATION_DURATION       0.1
#define kCRASH_ANIMATION_LENGTH         100
#define kVICTORY_DURATION               1.0
#define kVICTORY_ANIMATION_DURATION     0.1
#define kVICTORY_ANIMATION_LENGTH       300

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

// inialize
- (void)initLevel;
- (void)setSeekerStartPosition;
- (void)intMapZoom;
- (void)initStatusDisplay;
- (CCTMXTiledMap*)initMap;
- (void)centerTileMapOnStartPoint;
- (void)loadProgram;
// reset
- (void)resetMap;
- (void)resetSeekerStartPosition;
// coordinate transforms
- (CGPoint)getPointFromObjectPropertiesInScreenCoords:(NSDictionary*)dict;
- (CGPoint)getPointFromObjectPropertiesInTileCoords:(NSDictionary*)dict;
- (CGPoint)screenCoordsToTileCoords:(CGPoint)_screenPoint;
- (CGPoint)tileCoordsToScreenCoords:(CGPoint)_tilePoint;
- (CGPoint)tileCoordsToTile:(CGPoint)point;
- (CGPoint)tileMapTranslatedToPoint:(CGPoint)_point;
- (CGPoint)moveDeltaScreenCoords:(CGPoint)_delta;
- (CGPoint)moveDeltaTileCoords;
// program instructions
- (BOOL)shouldMoveMap:(CGPoint)_delta;
- (BOOL)moveIsInPlayingAreaForDelta:(CGPoint)_delta;
- (void)completeLevel;
- (void)executeSeekerInstruction:(ccTime)dt;
- (void)updatePathForPosition:(CGPoint)_position;
- (CGFloat)useEnergy:(NSInteger)_gradient;
- (NSInteger)speedDelta:(NSInteger)_gradient;
- (BOOL)isItemTile:(NSDictionary*)_itemProperties ofType:(NSString*)_itemType;
- (BOOL)isStationTile:(NSDictionary*)_itemProperties;
- (void)move;
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration;
- (void)putSensor:(NSDictionary*)_properties atPoint:(CGPoint)_point;
- (void)getSample:(NSDictionary*)_properties atPoint:(CGPoint)_point;
- (void)halt;
- (NSInteger)mapIDToInteger:(NSString*)_mapID;
// display parameter updates
- (void)updateEnergy;
- (void)updateSpeed;
- (void)updateSensorCount;
- (void)updateSampleCount;
- (void)updateLevel;
// seeker crash
- (void)crashCompleted;
- (void)crashHitMapBoundary;
- (void)crashNoEnergy;
- (void)crashSpeedHigh;
- (void)crashSpeedLow;
- (void)crashProgram;
- (void)crashTerrain;
- (void)crashSensorBinEmpty;
- (void)crashNoSensorSiteAtPosition;
- (void)crashSampleBinFull;
- (void)crashNoSampleAtPosition;
// crash animations
- (void)initCrashSprite:(NSString*)_file;
- (void)initCrashAnimatedSprite:(NSString*)_file withFrameCount:(NSInteger)_frameCount andDelay:(CGFloat)_delay;
- (void)fadeToRed;
- (void)fadeToYellow;
- (void)blinkRed;
- (void)blinkYellow;
- (void)vanish;
- (void)vanishToPoint;
- (void)vanishToLine;
- (void)vanishToLineToPoint;
- (void)fadeToNoise;
- (void)spherize;
// level completed animations
- (void)runLevelCompletedAnimation;
- (void)levelCompletedAnimation;
- (void)initVictoryAnimatedSprite:(NSString*)_file withFrameCount:(NSInteger)_frameCount andDelay:(CGFloat)_delay;
- (void)rotateFull;
- (void)rotateHalfBounce;
- (void)rotateExpandContract;
- (void)rotateHead;
- (void)flapWings;
// menu
- (void)insertUpperMenu;
- (void)insertLowerMenu;
- (void)mapMenu;
- (void)mapProg;
- (void)mapSubs;
- (void)mapStop;
- (void)mapRun;  
- (void)mapBack;
// move map on touch
- (void)onTouchMoveMapUp;
- (void)onTouchMoveMapDown;
- (void)onTouchMoveMapLeft;
- (void)onTouchMoveMapRight;
- (void)onTouchMoveMap;
- (CGPoint)onTouchMoveDeltaToPlayingArea;
- (void)centerOnSeekerPosition;
- (CGFloat)panDuration:(CGPoint)_delta;
// zoom map
- (void)zoomMap;
- (void)zoomMapIn;
- (void)zoomMapOut;
- (CGPoint)zoomInScreenCoords:(CGPoint)_screenPoint;
- (CGPoint)zoomOutScreenCoords:(CGPoint)_screenPoint;
// utils
- (BOOL)acceptTouches:(CGPoint)_touchLocation;
- (float)calculatePinchScaleFromTouches:(NSSet*)touches;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize seeker1;
@synthesize statusDisplay;
@synthesize startSite;
@synthesize seekerPath;
@synthesize level;
@synthesize endOfMissionCounter;
@synthesize screenCenter;
@synthesize firstTouch;
@synthesize onTouchMoveDelta;
@synthesize tileMapSize;
@synthesize tileMap;
@synthesize mapLayer;
@synthesize terrainLayer;
@synthesize itemsLayer;
@synthesize sandLayer;
@synthesize objectsLayer;
@synthesize crashSprite;
@synthesize victorySprite;
@synthesize menu;
@synthesize counter;
@synthesize crashAnimationCounter;
@synthesize victoryAnimationCounter;
@synthesize levelResetSeeker;
@synthesize levelResetMap;
@synthesize levelInitSeeker;
@synthesize levelInitZoom;
@synthesize levelInitialized;
@synthesize levelCrash;
@synthesize levelCompleted;
@synthesize nextLevel;
@synthesize movingMapOnTouch;
@synthesize centeringOnSeekerPosition;
@synthesize zoomingMap;
@synthesize mapZoomedOut;
@synthesize checkLevelCompleted;
@synthesize canTouch;
@synthesize pinchDetected;

//===================================================================================================================================
#pragma mark MapScene PrivateAPI
//-----------------------------------------------------------------------------------------------------------------------------------
// initialize
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark initialize

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initLevel {
    self.level = [UserModel level];
    [LevelModel insertForLevel:self.level];
    self.tileMap = [self initMap];
    CGSize tileMapTiles = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    self.tileMapSize = CGSizeMake(tileMapTiles.width*tileMapTileSize.width, tileMapTiles.height*tileMapTileSize.height);
    [self centerTileMapOnStartPoint];
    [self.seekerPath removeAllObjects];
    [self loadProgram];
    [self addChild:self.tileMap z:-1 tag:kMAP];
    [self insertUpperMenu];
    self.levelInitSeeker = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CCTMXTiledMap*)initMap {
    NSString* mapName = [NSString stringWithFormat:@"map-%d.tmx", self.level];
    CCTMXTiledMap* map = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    self.mapLayer = [map layerNamed:@"map"];
    self.terrainLayer = [map layerNamed:@"terrain"];
    self.itemsLayer = [map layerNamed:@"items"];
    self.sandLayer = [map layerNamed:@"sand"];
    self.objectsLayer = [map objectGroupNamed:@"objects"];
    self.startSite = [self.objectsLayer objectNamed:@"startSite"];
    return map;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSeekerStartPosition {
    self.levelInitSeeker = NO;
    self.seeker1 = [SeekerSprite create];
    [self.seeker1 initParams:self.startSite];
    [self initStatusDisplay];
    CGPoint startPoint = [self getPointFromObjectPropertiesInScreenCoords:self.startSite];
    NSString* bearing = [self.startSite valueForKey:@"bearing"];
    [self.seeker1 setToStartPoint:startPoint withBearing:bearing];
    self.levelInitZoom = YES;
    [self addChild:self.seeker1 z:0];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)intMapZoom {
    NSString* zoom = [self.startSite valueForKey:@"zoom"];
    if ([zoom isEqualToString:@"out"]) {
        [self zoomMap];
    }
    self.levelInitZoom = NO;
    self.levelInitialized = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initStatusDisplay {
    [self.statusDisplay setDigits:self.seeker1.energyTotal forDisplay:EnergyDisplayType];
    [self.statusDisplay setDigits:self.seeker1.speed forDisplay:SpeedDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sensorSites forDisplay:SensorDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sampleSites forDisplay:SampleDisplayType];
    [self.statusDisplay setDigits:self.level forDisplay:LevelDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerTileMapOnStartPoint {
    CGPoint startPoint = [self getPointFromObjectPropertiesInTileCoords:self.startSite];
    CGPoint mapTranslated = [self tileMapTranslatedToPoint:startPoint];
    CGFloat transDistance = ccpLength(mapTranslated);
    CGFloat duration = transDistance/kMAP_INIT_TRANS_BASE_LENGTH;
    [self moveMapTo:mapTranslated withDuration:duration];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadProgram {
    ProgramModel* model = [ProgramModel findByLevel:self.level];
    if (model) {
        ProgramNgin* ngin = [ProgramNgin instance];
        NSMutableArray* programListing = [model codeListingToInstrictions];
        [ngin loadProgram:programListing];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
// reset
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark reset

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetMap {
    self.levelResetMap = NO;
    if (self.crashSprite){
        [self.crashSprite removeFromParentAndCleanup:YES];
        self.crashSprite = nil;
    } else {
        [self.seeker1 removeFromParentAndCleanup:YES];
    }
    CCTMXTiledMap* newTileMap = [self initMap];
    [self addChild:newTileMap z:-1 tag:kMAP];
    [self.tileMap removeFromParentAndCleanup:YES];
    self.tileMap = newTileMap;
    [self centerTileMapOnStartPoint];
    [self initStatusDisplay];
    [self.menu removeFromParentAndCleanup:YES];
    [self insertUpperMenu];
    [self.seeker1 initParams:self.startSite];
    self.levelResetSeeker = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetSeekerStartPosition {
    self.levelResetSeeker = NO;
    CGPoint startPoint = [self getPointFromObjectPropertiesInScreenCoords:self.startSite];
    NSString* bearing = [self.startSite valueForKey:@"bearing"];
    [self.seeker1 resetToStartPoint:startPoint withBearing:bearing];
    [self addChild:self.seeker1];
    self.mapZoomedOut = NO;
    self.levelInitZoom = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// coordinate transforms
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark coordinate transforms

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectPropertiesInScreenCoords:(NSDictionary*)dict {
	CGFloat x = [[dict valueForKey:@"x"] floatValue];
    CGFloat y = [[dict valueForKey:@"y"] floatValue];
    CGPoint mapPos = self.tileMap.position;
	return CGPointMake(x + mapPos.x, y + mapPos.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectPropertiesInTileCoords:(NSDictionary*)dict {
	CGFloat x = [[dict valueForKey:@"x"] floatValue];
    CGFloat y = [[dict valueForKey:@"y"] floatValue];
	return CGPointMake(x, y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)screenCoordsToTileCoords:(CGPoint)_screenPoint {
    CGPoint tileCoords = ccpSub(_screenPoint, self.tileMap.position);
    if (self.mapZoomedOut) {
        tileCoords = CGPointMake(tileCoords.x / kMAP_ZOOM_FACTOR, tileCoords.y / kMAP_ZOOM_FACTOR);
    }
	return CGPointMake(tileCoords.x, self.tileMapSize.height - tileCoords.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileCoordsToScreenCoords:(CGPoint)_tilePoint {
    CGPoint glCoords = CGPointMake(_tilePoint.x, self.tileMapSize.height - _tilePoint.y);
    if (self.mapZoomedOut) {
        glCoords = CGPointMake(kMAP_ZOOM_FACTOR * glCoords.x, kMAP_ZOOM_FACTOR * glCoords.y);
    }
    return ccpAdd(glCoords, self.tileMap.position);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileCoordsToTile:(CGPoint)_point {
	CGFloat tileWidth = self.tileMap.tileSize.width;
	CGFloat tileHeight = self.tileMap.tileSize.height;	
	return CGPointMake((int)(_point.x/tileWidth), (int)(_point.y/tileHeight));
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileMapTranslatedToPoint:(CGPoint)_point {
    CGPoint zCenter = self.screenCenter;
    if (self.mapZoomedOut) {
        zCenter = CGPointMake(zCenter.x / kMAP_ZOOM_FACTOR, zCenter.y / kMAP_ZOOM_FACTOR);
    }
    CGPoint mapTranslated = ccpSub(zCenter, _point);
    if (_point.x < zCenter.x) {
        mapTranslated.x = 0.0;
    } else if ((self.tileMapSize.width - _point.x) < zCenter.x) {
        mapTranslated.x = - (self.tileMapSize.width - 2.0 * zCenter.x);
    } 
    if (_point.y < zCenter.y) {
        mapTranslated.y = 0.0;
    } else if ((self.tileMapSize.height - _point.y) < zCenter.y) {
        mapTranslated.y = - (self.tileMapSize.height - 2.0 * zCenter.y);
    } 
    return mapTranslated;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)moveDeltaTileCoords {
    CGSize moveSize = self.tileMap.tileSize;
    return [self.seeker1 positionDeltaAlongBearing:moveSize];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)moveDeltaScreenCoords:(CGPoint)_delta {
    if (self.mapZoomedOut) {
        _delta = CGPointMake(kMAP_ZOOM_FACTOR * _delta.x, kMAP_ZOOM_FACTOR * _delta.y);
    }    
    return _delta;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// program instructions
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark program instructions

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldMoveMap:(CGPoint)_deltaTileCoords {
    CGSize tileMapTileSize = self.tileMapSize;
    CGPoint deltaScreenCoords = [self moveDeltaScreenCoords:_deltaTileCoords];
    CGPoint newMapPosition = ccpAdd(CGPointMake(-deltaScreenCoords.x, -deltaScreenCoords.y), self.tileMap.position);
    CGPoint seekerTileCoords = [self screenCoordsToTileCoords:self.seeker1.position];
    CGPoint newSeekerTilePosition = ccpAdd(seekerTileCoords, CGPointMake(_deltaTileCoords.x, -_deltaTileCoords.y));
    CGPoint newSeekerScreenPosition = [self tileCoordsToScreenCoords:newSeekerTilePosition];
    CGPoint centerScreenCoords = self.screenCenter;
    CGPoint centerEastTileCoords = self.screenCenter;
    CGPoint centerWestTileCoords = self.screenCenter;
    CGPoint centerNorthTileCoords = self.screenCenter;
    CGPoint centerSouthTileCoords = self.screenCenter;
    if (self.mapZoomedOut) {
        centerEastTileCoords = CGPointMake((centerEastTileCoords.x + 6.0) / kMAP_ZOOM_FACTOR, centerEastTileCoords.y / kMAP_ZOOM_FACTOR);
        centerNorthTileCoords = CGPointMake(centerNorthTileCoords.x / kMAP_ZOOM_FACTOR, (centerNorthTileCoords.y - 20.0) / kMAP_ZOOM_FACTOR);
        centerWestTileCoords = CGPointMake((centerWestTileCoords.x - 30.0) / kMAP_ZOOM_FACTOR, centerWestTileCoords.y / kMAP_ZOOM_FACTOR);
        centerSouthTileCoords = CGPointMake(centerSouthTileCoords.x / kMAP_ZOOM_FACTOR, (centerSouthTileCoords.y - 30.0) / kMAP_ZOOM_FACTOR);
    }
    if (self.seeker1.bearing == WestSeekerBearing) {
         if (newMapPosition.x > 0) {
             return NO;
         } else if ((newMapPosition.x + tileMapTileSize.width) < 0) {
             return NO;
         } else if ((newSeekerTilePosition.x - centerWestTileCoords.x) <= 0) {
             return NO;
         } else if ((centerScreenCoords.x - newSeekerScreenPosition.x) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == EastSeekerBearing) {
         if (newMapPosition.x > 0) {
             return NO;
         } else if ((newMapPosition.x + tileMapTileSize.width) < 0) {
             return NO;
         } else if ((tileMapTileSize.width - newSeekerTilePosition.x - centerEastTileCoords.x) <= 0) {
             return NO;
         } else if ((newSeekerScreenPosition.x - centerScreenCoords.x) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == NorthSeekerBearing) {
         if (newMapPosition.y > 0) {
             return NO;
         } else if ((newMapPosition.y + tileMapTileSize.height) < 0) {
             return NO;
         } else if ((newSeekerTilePosition.y - centerNorthTileCoords.y) <= 0) {
             return NO;
         } else if ((newSeekerScreenPosition.y - centerScreenCoords.y) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == SouthSeekerBearing) {
         if (newMapPosition.y > 0) {
             return NO;
         } else if ((newMapPosition.y + tileMapTileSize.height) < 0) {
             return NO;
         } else if ((tileMapTileSize.height - newSeekerTilePosition.y - centerSouthTileCoords.y) <= 0) {
             return NO;
         } else if ((centerScreenCoords.y - newSeekerScreenPosition.y) <= 0) {
             return NO;
         }
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)moveIsInPlayingAreaForDelta:(CGPoint)_delta {
    CGPoint tilePosition = [self nextPositionForDelta:_delta];
    return [self positionIsInPlayingArea:tilePosition];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)completeLevel {
    self.checkLevelCompleted = NO;
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* itemProperties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if ([self isStationTile:itemProperties]) {
        [self.seeker1 emptySampleBin];
        [self.seeker1 loadSensorBin];
    }
    if ([self.seeker1 isLevelCompleted]) {
        [[ProgramNgin instance] stopProgram];
        [LevelModel completeLevel:self.level forSeeker:self.seeker1];
        [self levelCompletedAnimation];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)executeSeekerInstruction:(ccTime)dt {
    NSMutableArray* instructionSet = nil;
    ProgramNgin* ngin = [ProgramNgin instance];
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* itemProperties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if ((instructionSet = [ngin nextInstruction:self])) {
        ProgramInstruction instruction = [[instructionSet objectAtIndex:0] intValue];
        switch (instruction) {
            case MoveProgramInstruction:
                [self move];
                break;
            case TurnLeftProgramInstruction:
                [self.seeker1 turnLeft];
                break;
            case PutSensorProgramInstruction:
                [self putSensor:itemProperties atPoint:seekerTile];
                break;
            case GetSampleProgramInstruction:
                [self getSample:itemProperties atPoint:seekerTile];
                break;
            case DoTimesProgramInstruction:
                break;
            case DoUntilProgramInstruction:
                break;
            default:
                break;
        }
        self.checkLevelCompleted = YES;
    } else {
        [self halt];
        [self crashProgram];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updatePathForPosition:(CGPoint)_position {
    [self.seekerPath addObject:[NSValue valueWithCGPoint:_position]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)useEnergy:(NSInteger)_gradient {
    CGFloat delta = kSEEKER_DELTA_ENERGY;
    if (_gradient < 0) {
        delta = kSEEKER_DELTA_ENERGY_MIN;
    } else if (_gradient > 0) {
        delta = kSEEKER_DELTA_ENERGY_MAX;
    }
    return delta;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)speedDelta:(NSInteger)_gradient {
    NSInteger delta = 0;
    if (_gradient < 0) {
        delta = kSEEKER_DELTA_SPEED;
    } else if (_gradient > 0) {
        delta = -kSEEKER_DELTA_SPEED;
    }
    return delta;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isItemTile:(NSDictionary*)_itemProperties ofType:(NSString*)_itemType {
    BOOL status = NO;
    if (_itemProperties) {
        NSString* itemID = [_itemProperties valueForKey:@"itemID"];
        if ([itemID isEqualToString:_itemType]) {
            status = YES;
        }            
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isStationTile:(NSDictionary*)_itemProperties {
    return [self isItemTile:_itemProperties ofType:@"station"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)move {
    CGPoint deltaTileCoords = [self moveDeltaTileCoords];
    if ([self moveIsInPlayingAreaForDelta:deltaTileCoords]) {
        NSInteger gradient = [self terrainGradient];
        CGFloat usedEnergy = [self useEnergy:gradient];
        if ([self.seeker1 useEnergy:usedEnergy]) {
            NSInteger deltaSpeed = [self speedDelta:gradient];
            if ([self.seeker1 changeSpeed:deltaSpeed]) {
                [self updateEnergy];
                [self updateSpeed];
                if ([self isTerrainClear:gradient]) {
                    CGPoint deltaScreenCoords = [self moveDeltaScreenCoords:deltaTileCoords];
                    if ([self shouldMoveMap:deltaTileCoords]) {
                        CGPoint mapPosition = ccpAdd(CGPointMake(-deltaScreenCoords.x, -deltaScreenCoords.y), self.tileMap.position);
                        CGFloat speedScale = [UserModel speedScaleFactor];
                        [self moveMapTo:mapPosition withDuration:kSEEKER_GRID_DISTANCE/(speedScale*self.seeker1.speed)];
                    } else {
                        [self.seeker1 moveBy:deltaScreenCoords];
                    }
                    CGPoint seekerTile = [self getSeekerTile];
                    [self updatePathForPosition:seekerTile];
                } else {
                    [self halt];
                    [self crashTerrain];
                }
            } else {
                [self halt];
                if (self.seeker1.speed == kSEEKER_MAX_SPEED) {
                    [self crashSpeedHigh];
                } else {
                    [self crashSpeedLow];
                }
            }
        } else {
            [self halt];
            [self crashNoEnergy];
        }
    } else {
        [self halt];
        [self crashHitMapBoundary];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration {
	[self.tileMap stopAllActions];
	[self.tileMap runAction:[CCMoveTo actionWithDuration:_duration position:_point]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)putSensor:(NSDictionary*)_properties atPoint:(CGPoint)_point {
    if (_properties) {
        NSString* itemID = [_properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sensorSite"]) {   
            if ([self.seeker1 putSensor]) {
                [self.itemsLayer removeTileAt:_point];
                [self.itemsLayer setTileGID:kMAP_SENSOR_GID at:_point];
                [self updateSensorCount];
            } else {
                [self halt];
                [self crashSensorBinEmpty];
            }
        } else {
            [self halt];
            [self crashNoSensorSiteAtPosition];
        }
    } else {
        [self halt];
        [self crashNoSensorSiteAtPosition];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getSample:(NSDictionary*)_properties atPoint:(CGPoint)_point {
    if (_properties) {
        NSString* itemID = [_properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sample"]) {        
            if ([self.seeker1 getSample]) {
                [self.itemsLayer removeTileAt:_point];
                [self updateSampleCount];
            } else {
                [self halt];
                [self crashSampleBinFull];
            }
        } else {        
            [self halt];
            [self crashNoSampleAtPosition];
        }
    } else {  
        [self halt];
        [self crashNoSampleAtPosition];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)halt {
    [[ProgramNgin instance] haltProgram];
    [LevelModel incompleteLevel:self.level forSeeker:self.seeker1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)mapIDToInteger:(NSString*)_mapID {
    NSInteger mapInt = 0;
    if ([_mapID isEqualToString:@"up-1"]) {
        mapInt =  5;
    } else if ([_mapID isEqualToString:@"up-2"]) {
        mapInt =  4;
    } else if ([_mapID isEqualToString:@"up-3"]) {
        mapInt = 3;
    } else if ([_mapID isEqualToString:@"up-4"]) {
        mapInt = 2;
    } else if ([_mapID isEqualToString:@"up-5"]) {
        mapInt = 1;
    } else if ([_mapID isEqualToString:@"down-1"]) {
        mapInt =  -5;
    } else if ([_mapID isEqualToString:@"down-2"]) {
        mapInt =  -4;
    } else if ([_mapID isEqualToString:@"down-3"]) {
        mapInt = -3;
    } else if ([_mapID isEqualToString:@"down-4"]) {
        mapInt = -2;
    } else if ([_mapID isEqualToString:@"down-5"]) {
        mapInt = -1;
    }
    return mapInt;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// display parameter updates
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark display parameter updates

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateEnergy {
    [self.statusDisplay setDigits:self.seeker1.energy forDisplay:EnergyDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSpeed {
    [self.statusDisplay setDigits:self.seeker1.speed forDisplay:SpeedDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSensorCount {
    [self.statusDisplay setDigits:self.seeker1.sensorsRemaining forDisplay:SensorDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSampleCount {
    [self.statusDisplay setDigits:self.seeker1.samplesRemaining forDisplay:SampleDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateLevel {
    [self.statusDisplay setDigits:self.level forDisplay:LevelDisplayType]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
// seeker crashes
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark seeker crashes

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashCompleted {
    self.levelCrash = NO;
    [self.seeker1 removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] replaceScene: [EndOfLevelScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashHitMapBoundary {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_HIT_MAP_BOUNDARY andMessage:kERROR_MSG_HIT_MAP_BOUNDARY];
    [self vanishToLine];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoEnergy {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_NO_ENERGY andMessage:kERROR_MSG_NO_ENERGY];
    [self vanishToPoint];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSpeedHigh {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SPEED_HIGH andMessage:kERROR_MSG_SPEED_HIGH];
    [self spherize];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSpeedLow {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SPEED_LOW andMessage:kERROR_MSG_SPEED_LOW];
    [self vanish];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashProgram {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_PROGRAM_CRASH andMessage:kERROR_MSG_PROGRAM_CRASH];
    [self fadeToNoise];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashTerrain {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_TERRRAIN andMessage:kERROR_MSG_TERRRAIN];
    [self vanishToLineToPoint];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSensorBinEmpty {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SENSOR_BIN_EMPTY andMessage:kERROR_MSG_SENSOR_BIN_EMPTY];
    [self fadeToYellow];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSensorSiteAtPosition {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_EXPECTED_SENSOR andMessage:kERROR_MSG_EXPECTED_SENSOR];
    [self blinkYellow];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSampleBinFull {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SAMPLE_BIN_FULL andMessage:kERROR_MSG_SAMPLE_BIN_FULL];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSampleAtPosition {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_EXPECTED_SAMPLE andMessage:kERROR_MSG_EXPECTED_SAMPLE];
    [self blinkRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// crash animations
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark crash animations

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initCrashSprite:(NSString*)_file {
    self.crashSprite = [[[CCSprite alloc] initWithFile:_file] autorelease]; 
    if (self.mapZoomedOut) {
        self.crashSprite.scale = kMAP_ZOOM_FACTOR;
    } else {
        self.crashSprite.scale = 1.0;
    }
    CGFloat startRotation = [self.seeker1 rotationFromNorthToBearing:self.seeker1.bearing];
    self.crashSprite.rotation = startRotation;
    self.crashSprite.position = self.seeker1.position;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initCrashAnimatedSprite:(NSString*)_file withFrameCount:(NSInteger)_frameCount andDelay:(CGFloat)_delay {
    self.crashSprite = [AnimatedSprite animationFromFile:_file withFrameCount:_frameCount andDelay:_delay]; 
    if (self.mapZoomedOut) {
        self.crashSprite.scale = kMAP_ZOOM_FACTOR;
    } else {
        self.crashSprite.scale = 1.0;
    }
    CGFloat startRotation = [self.seeker1 rotationFromNorthToBearing:self.seeker1.bearing];
    self.crashSprite.rotation = startRotation;
    self.crashSprite.position = self.seeker1.position;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fadeToRed {
    [self initCrashSprite:@"red-seeker-1.png"];
    self.crashSprite.opacity = 0.0;
    [self addChild:self.crashSprite];
	[self.crashSprite runAction:[CCFadeIn actionWithDuration:kCRASH_DURATION]];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fadeToYellow {
    [self initCrashSprite:@"yellow-seeker-1.png"];
    self.crashSprite.opacity = 0.0;
    [self addChild:self.crashSprite];
	[self.crashSprite runAction:[CCFadeIn actionWithDuration:kCRASH_DURATION]];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)blinkRed {
    [self initCrashAnimatedSprite:@"red-blink" withFrameCount:4 andDelay:kCRASH_ANIMATION_DURATION];
    [self addChild:self.crashSprite];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.crashAnimationCounter = self.counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)blinkYellow {
    [self initCrashAnimatedSprite:@"yellow-blink" withFrameCount:4 andDelay:kCRASH_ANIMATION_DURATION];
    [self addChild:self.crashSprite];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.crashAnimationCounter = self.counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)vanish {
    [self initCrashSprite:@"red-seeker-1.png"];
    [self addChild:self.crashSprite];
	[self.crashSprite runAction:[CCFadeOut actionWithDuration:kCRASH_DURATION]];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)vanishToPoint {
    [self initCrashSprite:@"red-seeker-1.png"];
    [self addChild:self.crashSprite];
	[self.crashSprite runAction:[CCScaleTo actionWithDuration:kCRASH_DURATION scale:0.0]];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)vanishToLine {
    [self initCrashSprite:@"red-seeker-1.png"];
    [self addChild:self.crashSprite];
    CGFloat scaleFactor = 1.0;
    if (self.mapZoomedOut) {
        scaleFactor = kMAP_ZOOM_FACTOR;
    } 
	[self.crashSprite runAction:[CCScaleTo actionWithDuration:kCRASH_DURATION scaleX:scaleFactor scaleY:0.0]];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)vanishToLineToPoint {
    [self initCrashSprite:@"red-seeker-1.png"];
    [self addChild:self.crashSprite];
    CGFloat scaleFactor = 1.0;
    if (self.mapZoomedOut) {
        scaleFactor = kMAP_ZOOM_FACTOR;
    } 
    id toLineAction = [CCScaleTo actionWithDuration:kCRASH_DURATION/2.0 scaleX:0.1 scaleY:scaleFactor];
    id toPointAction = [CCScaleTo actionWithDuration:kCRASH_DURATION/2.0 scaleX:0.0 scaleY:0.0];
	[self.crashSprite runAction:[CCSequence actions:toLineAction, toPointAction, nil]];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fadeToNoise {
    [self initCrashAnimatedSprite:@"noise" withFrameCount:20 andDelay:kCRASH_ANIMATION_DURATION];
    [self addChild:self.crashSprite];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.crashAnimationCounter = self.counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)spherize {
    [self initCrashAnimatedSprite:@"spherize" withFrameCount:12 andDelay:kCRASH_ANIMATION_DURATION];
    [self addChild:self.crashSprite];
    [self.seeker1 removeFromParentAndCleanup:YES];
    self.crashAnimationCounter = self.counter;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// level completed animations
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark level completed animations

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)runLevelCompletedAnimation {
    self.levelCompleted = NO;
    [self rotateHead];
//    if (self.level == kLEVEL_FOR_SUBROUTINES) {
//    } else if (self.level == kLEVEL_FOR_TIMES) {
//    } else if (self.level == kLEVEL_FOR_UNTIL) {
//    } else if (self.level == kLEVEL_FOR_BINS) {
//    } else if (self.level == kEND_OF_SITE_1) {
//    } else if (self.level == kEND_OF_SITE_2) {
//    } else if (self.level == kEND_OF_SITE_3) {
//    } else if (self.level < kEND_OF_SITE_1) {
//        [self rotateFull];
//    } else if (self.level < kEND_OF_SITE_2) {
//        [self rotateHalfBounce];
//    } else {        
//    }
    self.nextLevel = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)levelCompletedAnimation {
    self.levelCompleted = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initVictoryAnimatedSprite:(NSString*)_file withFrameCount:(NSInteger)_frameCount andDelay:(CGFloat)_delay {
    self.victorySprite = [AnimatedSprite animationFromFile:_file withFrameCount:_frameCount andDelay:_delay]; 
    if (self.mapZoomedOut) {
        self.victorySprite.scale = kMAP_ZOOM_FACTOR;
    } else {
        self.victorySprite.scale = 1.0;
    }
    CGFloat startRotation = [self.seeker1 rotationFromNorthToBearing:self.seeker1.bearing];
    self.victorySprite.rotation = startRotation;
    self.victorySprite.position = self.seeker1.position;
    self.victorySprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.victoryAnimationCounter = self.counter;
    [self addChild:self.victorySprite];
    [self.seeker1 removeFromParentAndCleanup:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotateFull {
    [self.seeker1 runAction:[CCRotateBy actionWithDuration:kVICTORY_DURATION angle:360.0]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotateHalfBounce {
    id rotateCW1 = [CCRotateBy actionWithDuration:kVICTORY_DURATION/4.0 angle:-90.0];
    id rotateCW = [CCRotateBy actionWithDuration:kVICTORY_DURATION/2.0 angle:180.0];
    [self.seeker1 runAction:[CCSequence actions:rotateCW1, rotateCW, rotateCW1, nil]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotateExpandContract {
    id expand = [CCScaleTo actionWithDuration:kVICTORY_DURATION/6.0 scale:1.2];
    id contract = [CCScaleTo actionWithDuration:kVICTORY_DURATION/6.0 scale:1.0];
    [self.seeker1 runAction:[CCSequence actions:expand, contract, expand, contract, expand, contract, nil]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)rotateHead {
    [self initVictoryAnimatedSprite:@"rotate-head" withFrameCount:10 andDelay:kCRASH_ANIMATION_DURATION];
 }

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)flapWings {
    [self.seeker1 runAction:[CCRotateBy actionWithDuration:kVICTORY_DURATION angle:360.0]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// menu
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark menu

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertUpperMenu {
    CCSprite* menuUnselected = [CCSprite spriteWithFile:@"map-menu.png"];
    CCSprite* menuSelected = [CCSprite spriteWithFile:@"map-menu-selected.png"];
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:menuUnselected selectedSprite:menuSelected target:self selector:@selector(mapMenu)];
    CCSprite* progUnselected = [CCSprite spriteWithFile:@"map-prog.png"];
    CCSprite* progSelected = [CCSprite spriteWithFile:@"map-prog-selected.png"];
    CCMenuItemSprite* progItem = [CCMenuItemSprite itemFromNormalSprite:progUnselected selectedSprite:progSelected target:self selector:@selector(mapProg)];
    CCSprite* subsUnselected = [CCSprite spriteWithFile:@"map-subs.png"];
    CCSprite* subsSelected = [CCSprite spriteWithFile:@"map-subs-selected.png"];
    CCMenuItemSprite* subsItem = [CCMenuItemSprite itemFromNormalSprite:subsUnselected selectedSprite:subsSelected target:self selector:@selector(mapSubs)];
    CCSprite* stopUnselected = [CCSprite spriteWithFile:@"map-stop.png"];
    CCSprite* stopSelected = [CCSprite spriteWithFile:@"map-stop-selected.png"];
    CCMenuItemSprite* stopItem = [CCMenuItemSprite itemFromNormalSprite:stopUnselected selectedSprite:stopSelected target:self selector:@selector(mapStop)];
    CCSprite* runUnselected = [CCSprite spriteWithFile:@"map-run.png"];
    CCSprite* runSelected = [CCSprite spriteWithFile:@"map-run-selected.png"];
    CCMenuItemSprite* runItem = [CCMenuItemSprite itemFromNormalSprite:runUnselected selectedSprite:runSelected target:self selector:@selector(mapRun)];
    ProgramNgin* ngin = [ProgramNgin instance];
    if ([ngin programIsLoaded]) {
        if ([ngin programIsHalted] || [ngin programIsRunning]) {
            if ([UserModel level] >= kLEVEL_FOR_SUBROUTINES) {
               self.menu = [CCMenu menuWithItems:menuItem, progItem, subsItem, stopItem, nil];
            } else {
                self.menu = [CCMenu menuWithItems:menuItem, progItem, stopItem, nil];
            }
        } else {
            if ([UserModel level] >= kLEVEL_FOR_SUBROUTINES) {
                self.menu = [CCMenu menuWithItems:menuItem, progItem, subsItem, runItem, nil];
            } else {
                self.menu = [CCMenu menuWithItems:menuItem, progItem, runItem, nil];
            }
        }
    } else {
        if ([UserModel level] >= kLEVEL_FOR_SUBROUTINES) {
            self.menu = [CCMenu menuWithItems:menuItem, progItem, subsItem, nil];
        } else {
            self.menu = [CCMenu menuWithItems:menuItem, progItem, nil];
        }
    }
    [self.menu alignItemsHorizontallyWithPadding:0.0];
    self.menu.position = CGPointMake(160.0f, 400.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertLowerMenu {
    CCSprite* menuImage = [CCSprite spriteWithFile:@"map-levels.png"];
    CCSprite* menuImageSelected = [CCSprite spriteWithFile:@"map-levels.png"];
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:menuImage selectedSprite:menuImageSelected target:self selector:@selector(mapBack)];
    CCMenu* lowerMenu = [CCMenu menuWithItems:menuItem, nil];
    [lowerMenu alignItemsHorizontallyWithPadding:0.0];
    lowerMenu.position = CGPointMake(self.screenCenter.x, 15.0f);
    [self addChild:lowerMenu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapMenu {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapProg {
    [[ViewControllerManager instance] showTerminalView:[[CCDirector sharedDirector] openGLView] launchedFromMap:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapSubs {
    [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineInstructionType];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapStop {
    [[ProgramNgin instance] stopProgram];
    [self resetLevel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapRun {
    [self loadProgram];
    [[ProgramNgin instance] runProgram];
    [self.menu removeFromParentAndCleanup:YES];
    [self insertUpperMenu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapBack {
    [[CCDirector sharedDirector] replaceScene:[MissionsScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// move map on touch
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark move map on touch

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchMoveMapUp {
    self.onTouchMoveDelta = CGPointMake(0.0, 1.5*self.screenCenter.y);
    self.movingMapOnTouch = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchMoveMapDown {
    self.onTouchMoveDelta = CGPointMake(0.0, -1.5*self.screenCenter.y);
    self.movingMapOnTouch = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchMoveMapLeft {
    self.onTouchMoveDelta = CGPointMake(-1.5*self.screenCenter.x, 0.0);
    self.movingMapOnTouch = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchMoveMapRight {
    self.onTouchMoveDelta = CGPointMake(1.5*self.screenCenter.x, 0.0);
    self.movingMapOnTouch = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchMoveMap {
    CGPoint tileMapPosition = self.tileMap.position;
    CGPoint delta = [self onTouchMoveDeltaToPlayingArea];
    CGPoint newTileMapPosition = ccpAdd(tileMapPosition, delta);
    CGFloat duration = [self panDuration:delta];
    if ([self.seeker1 parent]) {
        [self.seeker1 runAction:[CCMoveBy actionWithDuration:duration position:delta]];
    } else if (self.crashSprite) {
        [self.crashSprite runAction:[CCMoveBy actionWithDuration:duration position:delta]];
    }
    [self moveMapTo:newTileMapPosition withDuration:duration];
    self.movingMapOnTouch = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)onTouchMoveDeltaToPlayingArea {
    CGPoint zCenter = self.screenCenter;
    CGSize zTileMapSize = self.tileMapSize;
    CGPoint tileMapPosition = self.tileMap.position;
    CGPoint newTileMapPosition = ccpAdd(tileMapPosition, self.onTouchMoveDelta);
    if (self.mapZoomedOut) {
        zTileMapSize = CGSizeMake(kMAP_ZOOM_FACTOR * zTileMapSize.width, kMAP_ZOOM_FACTOR * zTileMapSize.height);
    }        
    CGFloat xPos = MIN(0.0, newTileMapPosition.x);
    xPos = MAX(xPos, -(zTileMapSize.width - 2.0*zCenter.x - 1.0));
    CGFloat yPos = MIN(0.0, newTileMapPosition.y);
    yPos = MAX(yPos, -(zTileMapSize.height - 2.0*zCenter.y - 1.0));
    CGPoint moveDelta = ccpSub(CGPointMake(xPos, yPos), tileMapPosition);
    return moveDelta;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerOnSeekerPosition {
    CGFloat duration = 0.0;
    CGPoint mapTranslated = CGPointMake(0.0, 0.0);
    CGPoint mapPosition = self.tileMap.position;
    if ([self.seeker1 parent]) {
        CGPoint seekerPosition = [self screenCoordsToTileCoords:self.seeker1.position];
        mapTranslated = [self tileMapTranslatedToPoint:CGPointMake(seekerPosition.x, self.tileMapSize.height - seekerPosition.y)];
        CGPoint delta = ccpSub(mapTranslated, mapPosition);
        duration = [self panDuration:delta];
        [self.seeker1 runAction:[CCMoveBy actionWithDuration:duration position:delta]];
    } else if (self.crashSprite) {
        CGPoint crashPosition = [self screenCoordsToTileCoords:self.crashSprite.position];
        mapTranslated = [self tileMapTranslatedToPoint:CGPointMake(crashPosition.x, self.tileMapSize.height - crashPosition.y)];
        CGPoint delta = ccpSub(mapTranslated, mapPosition);
        duration = [self panDuration:delta];
        [self.crashSprite runAction:[CCMoveBy actionWithDuration:duration position:delta]];
    }
    [self moveMapTo:mapTranslated withDuration:duration];
    self.centeringOnSeekerPosition = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)panDuration:(CGPoint)_delta {
    CGFloat distance = sqrt(pow(_delta.x, 2.0) + pow(_delta.y, 2.0));
    return distance * kMAP_INVERSE_PAN_SPEED;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// zoom map
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark zoom map

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)zoomMap {
    if (self.mapZoomedOut) {
        self.mapZoomedOut = NO;
        [self zoomMapIn];
    } else {
        self.mapZoomedOut = YES;
        [self zoomMapOut];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)zoomMapOut {
    CGPoint seekerScreenCoords = [self zoomInScreenCoords:self.seeker1.position];
    CGPoint seekerTileCoords = [self screenCoordsToTileCoords:seekerScreenCoords];
    CGPoint mapTranslated = [self tileMapTranslatedToPoint:CGPointMake(seekerTileCoords.x, self.tileMapSize.height - seekerTileCoords.y)];
    CGPoint deltaMapTranslated = ccpSub(mapTranslated, self.tileMap.position);
    seekerScreenCoords = ccpAdd(seekerScreenCoords, deltaMapTranslated);
    [self.tileMap runAction:[CCScaleTo actionWithDuration:kMAP_ZOOM_DURATION scale:kMAP_ZOOM_FACTOR]];
    [self.seeker1 runAction:[CCScaleTo actionWithDuration:kMAP_ZOOM_DURATION scale:kMAP_ZOOM_FACTOR]];
    [self.seeker1 runAction:[CCMoveTo actionWithDuration:kMAP_ZOOM_DURATION position:seekerScreenCoords]];
	[self.tileMap runAction:[CCMoveTo actionWithDuration:kMAP_ZOOM_DURATION position:mapTranslated]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)zoomMapIn {
    CGPoint seekerScreenCoords = [self zoomOutScreenCoords:self.seeker1.position];
    CGPoint seekerTileCoords = [self screenCoordsToTileCoords:seekerScreenCoords];
    CGPoint mapTranslated = [self tileMapTranslatedToPoint:CGPointMake(seekerTileCoords.x, self.tileMapSize.height - seekerTileCoords.y)];
    CGPoint deltaMapTranslated = ccpSub(mapTranslated, self.tileMap.position);
    seekerScreenCoords = ccpAdd(seekerScreenCoords, deltaMapTranslated);
    [self.tileMap runAction:[CCScaleTo actionWithDuration:kMAP_ZOOM_DURATION scale:1.0]];
    [self.seeker1 runAction:[CCScaleTo actionWithDuration:kMAP_ZOOM_DURATION scale:1.0]];
    [self.seeker1 runAction:[CCMoveTo actionWithDuration:kMAP_ZOOM_DURATION position:seekerScreenCoords]];
	[self.tileMap runAction:[CCMoveTo actionWithDuration:kMAP_ZOOM_DURATION position:mapTranslated]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)zoomInScreenCoords:(CGPoint)_screenPoint {
    CGPoint tileCoords = ccpSub(_screenPoint, self.tileMap.position);
    tileCoords = CGPointMake(kMAP_ZOOM_FACTOR * tileCoords.x, (self.tileMapSize.height - kMAP_ZOOM_FACTOR * tileCoords.y));
    CGPoint screenCoords = CGPointMake(tileCoords.x, self.tileMapSize.height - tileCoords.y);
    return ccpAdd(screenCoords, self.tileMap.position);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)zoomOutScreenCoords:(CGPoint)_screenPoint {
    CGPoint tileCoords = ccpSub(_screenPoint, self.tileMap.position);
    tileCoords = CGPointMake(tileCoords.x / kMAP_ZOOM_FACTOR, (self.tileMapSize.height - tileCoords.y / kMAP_ZOOM_FACTOR));
    CGPoint screenCoords = CGPointMake(tileCoords.x, self.tileMapSize.height - tileCoords.y);
    return ccpAdd(screenCoords, self.tileMap.position);
}

//===================================================================================================================================
#pragma mark utils

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)acceptTouches:(CGPoint)_touchLocation {
    BOOL accept = NO;
    CGSize statusDisplaySize = self.statusDisplay.contentSize;
    CGFloat touchDelta = 2.0*self.screenCenter.y - _touchLocation.y;
    if (self.canTouch && touchDelta > statusDisplaySize.height) {
        accept = YES;
    }
    return accept;
}
   
//===================================================================================================================================
#pragma mark MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MapScene *layer = [MapScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.isTouchEnabled = YES;
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		self.screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
        self.seekerPath = [NSMutableArray arrayWithCapacity:10];
        self.statusDisplay = [StatusDisplay create];
        self.counter = 0;
        self.crashAnimationCounter = 0;
        self.levelResetSeeker = NO;
        self.levelResetMap = NO;
        self.levelInitSeeker = NO;
        self.levelInitZoom = NO;
        self.levelInitialized = NO;
        self.levelCrash = NO;
        self.levelCompleted = NO;
        self.nextLevel = NO;
        self.movingMapOnTouch = NO;
        self.centeringOnSeekerPosition = NO;
        self.mapZoomedOut = NO;
        self.zoomingMap = NO;
        self.checkLevelCompleted = NO;
        self.canTouch = NO;
        self.endOfMissionCounter = 0;
        self.pinchDetected = NO;
        [self.statusDisplay insert:self];
        [[ProgramNgin instance] deleteProgram];
        [self insertLowerMenu];
        [self initLevel];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    NSInteger mapActions = [self.tileMap numberOfRunningActions];
    NSInteger seekerActions = [self.seeker1 numberOfRunningActions];
    NSInteger crashActions = 0;
    self.counter++;
    if (self.crashSprite) {crashActions = [self.crashSprite numberOfRunningActions];}
	if (mapActions == 0 && seekerActions == 0 && crashActions == 0) {
        ProgramNgin* ngin = [ProgramNgin instance];
        if (self.levelInitSeeker) {
            [self setSeekerStartPosition];
        } else if (self.levelInitZoom) {
            [self intMapZoom];
        } else if (self.levelInitialized) {
            self.canTouch = YES;
            self.levelInitialized = NO;
        } else if (self.levelCrash) {
            [self crashCompleted];
        } else if (self.levelResetMap) {
            [self resetMap];
        } else if (self.levelResetSeeker) {
            [self resetSeekerStartPosition];
        } else if (self.levelCompleted) {
            [self runLevelCompletedAnimation];
        } else if (self.endOfMissionCounter == kEND_OF_LEVEL_COUNT) {
            [[CCDirector sharedDirector] replaceScene: [EndOfLevelScene scene]];
        } else if (self.nextLevel) {
            self.endOfMissionCounter++;
        } else if (self.movingMapOnTouch) {
            [self onTouchMoveMap];
        } else if (self.zoomingMap) {
            self.zoomingMap = NO;
            [self zoomMap];
        } else if (self.centeringOnSeekerPosition) {
            [self centerOnSeekerPosition];
        } else if (self.checkLevelCompleted) {
            [self completeLevel];
        } else if ([ngin programIsRunning]) {
            [self executeSeekerInstruction:dt];
        }
	} else if ((self.counter - self.crashAnimationCounter) == kCRASH_ANIMATION_LENGTH && crashActions == 1) {
        [self crashCompleted];
	} else if ((self.counter - self.victoryAnimationCounter) == kVICTORY_ANIMATION_LENGTH && self.nextLevel) {
        [self runLevelCompletedAnimation];
    }
        
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    NSInteger nTouches = [touches count];
    if (nTouches < 2) {
        CGPoint touchLocation = [TouchUtils locationFromTouches:touches]; 
        if ([self acceptTouches:touchLocation]) {
            self.firstTouch = [TouchUtils locationFromTouches:touches]; 
        }
    } else {
        self.pinchDetected = YES;
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [TouchUtils locationFromTouches:touches]; 
    if ([self acceptTouches:touchLocation]) {
        if (!self.pinchDetected) {
            NSInteger numberOfTaps = [[touches anyObject] tapCount];
            CGPoint touchDelta = ccpSub(touchLocation, self.firstTouch);
            if (abs(touchDelta.y) > 20 || abs(touchDelta.x) > 20) {
                if (abs(touchDelta.y) > abs(touchDelta.x)) {
                    if (touchDelta.y > 0) {
                        [self onTouchMoveMapUp];
                    } else {
                        [self onTouchMoveMapDown];
                    }
                } else {
                    if (touchDelta.x > 0) {
                        [self onTouchMoveMapRight];
                    } else {
                        [self onTouchMoveMapLeft];
                    }
                }
            } else if (numberOfTaps == 1) {
                self.centeringOnSeekerPosition = YES;
            } else if (numberOfTaps == 2) {
                self.zoomingMap = YES;
            }
        } else {
            self.pinchDetected = NO;
        }
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.pinchDetected) {
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) ccTouchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event {
    self.pinchDetected = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetLevel {
    self.levelResetMap = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary*)getTileProperties:(CGPoint)_point forLayer:(CCTMXLayer*)_layer {
    NSDictionary* properties = nil;
    int tileGID = [_layer tileGIDAt:CGPointMake(_point.x, _point.y)];
    if (tileGID != 0) {
        properties = [self.tileMap propertiesForGID:tileGID];
    }
    return properties;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getSeekerTile {
    return [self tileCoordsToTile:[self screenCoordsToTileCoords:self.seeker1.position]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)positionIsInPlayingArea:(CGPoint)_position {
    CGSize tiles = self.tileMap.mapSize; 
    if (_position.x <= kMAP_EDGE_BUFFER || _position.x >= (tiles.width - kMAP_EDGE_BUFFER - 1)) {
        return NO;
    } else if (_position.y <= (kMAP_EDGE_BUFFER + 1) || _position.y >= (tiles.height - kMAP_EDGE_BUFFER - 1)) {
        return NO;
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)nextPositionForDelta:(CGPoint)_delta {
    CGPoint newPosition = ccpAdd([self screenCoordsToTileCoords:self.seeker1.position], CGPointMake(_delta.x, -_delta.y));
    return [self tileCoordsToTile:newPosition];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)nextPosition {
    CGPoint delta = [self moveDeltaTileCoords];
    CGPoint newPosition = ccpAdd([self screenCoordsToTileCoords:self.seeker1.position], CGPointMake(delta.x, -delta.y));
    return [self tileCoordsToTile:newPosition];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)terrainGradient {
    NSInteger currentTerrain = 0;
    NSInteger nextTerrain = 0;
    CGPoint currentSeekerTile = [self getSeekerTile];
    CGPoint nextSeekerTile = [self nextPosition];
    NSDictionary* currentTerrainProperties = [self getTileProperties:currentSeekerTile forLayer:self.terrainLayer];
    NSDictionary* nextTerrainProperties = [self getTileProperties:nextSeekerTile forLayer:self.terrainLayer];
    if (currentTerrainProperties) {
        NSString* currentTerrainID = [currentTerrainProperties valueForKey:@"mapID"];
        currentTerrain = [self mapIDToInteger:currentTerrainID];
    }
    if (nextTerrainProperties) {
        NSString* nextTerrainID = [nextTerrainProperties valueForKey:@"mapID"];
        nextTerrain = [self mapIDToInteger:nextTerrainID];
    }
    NSInteger gradient = nextTerrain - currentTerrain;
    return gradient;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isTerrainClear:(NSInteger)_gradient {
    BOOL isClear = YES;
    if (_gradient < -1 || _gradient > 1) {
        isClear = NO; 
    }
    return isClear;
}

@end
