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

//-----------------------------------------------------------------------------------------------------------------------------------
#define kERROR_CODE_HIT_MAP_BOUNDARY        @"A-1654"
#define kERROR_MSG_HIT_MAP_BOUNDARY         @"Map Boundary"
#define kERROR_CODE_NO_ENERGY               @"E-3967"
#define kERROR_MSG_NO_ENERGY                @"Energy Depleted"
#define kERROR_CODE_SPEED_HIGH              @"S-1471"
#define kERROR_MSG_SPEED_HIGH               @"Maximum Speed"
#define kERROR_CODE_SPEED_LOW               @"S-1013"
#define kERROR_MSG_SPEED_LOW                @"Minimum Speed"
#define kERROR_CODE_PROGRAM_CRASH           @"P-1962"
#define kERROR_MSG_PROGRAM_CRASH            @"Program Error"
#define kERROR_CODE_TERRRAIN                @"T-3891"
#define kERROR_MSG_TERRRAIN                 @"Terrain Gradient"
#define kERROR_CODE_SENSOR_BIN_EMPTY        @"B-1951"
#define kERROR_MSG_SENSOR_BIN_EMPTY         @"Sensor Bin Empty"
#define kERROR_CODE_EXPECTED_SENSOR         @"S-1453"
#define kERROR_MSG_EXPECTED_SENSOR          @"Expected Sensor"
#define kERROR_CODE_SAMPLE_BIN_FULL         @"B-1181"
#define kERROR_MSG_SAMPLE_BIN_FULL          @"Sample Bin Full"
#define kERROR_CODE_EXPECTED_SAMPLE         @"S-3571"
#define kERROR_MSG_EXPECTED_SAMPLE          @"Expected Sample"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kMAP_EDGE_BUFFER            0
#define kMAP_INVERSE_PAN_SPEED      0.001
#define kMAP_ZOOM_FACTOR            0.5
#define kMAP_ZOOM_DURATION          1.0
#define kEND_OF_LEVEL_COUNT         50
#define kSEEKER_DELTA_SPEED         5
#define kSEEKER_DELTA_ENERGY        2
#define kSEEKER_DELTA_ENERGY_MIN    1
#define kSEEKER_DELTA_ENERGY_MAX    4

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

// inialize
- (void)initLevel;
- (void)setSeekerStartPosition;
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
// program instructions
- (BOOL)shouldMoveMap:(CGPoint)_delta;
- (BOOL)moveIsInPlayingAreaForDelta:(CGPoint)_delta;
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
- (void)fadeToRed;
// level completed animations
- (void)runLevelCompletedAnimation;
- (void)levelCompletedAnimation;
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
- (void)onTouchZoomMap;
- (void)onTouchZoomMapIn;
- (void)onTouchZoomMapOut;
- (CGPoint)zoomInScreenCoords:(CGPoint)_screenPoint;
- (CGPoint)zoomOutScreenCoords:(CGPoint)_screenPoint;
// utils
- (BOOL)acceptTouches:(CGPoint)_touchLocation;

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
@synthesize crash;
@synthesize menu;
@synthesize levelResetSeeker;
@synthesize levelResetMap;
@synthesize levelInitSeeker;
@synthesize levelInitialized;
@synthesize levelCrash;
@synthesize levelCompleted;
@synthesize nextLevel;
@synthesize movingMapOnTouch;
@synthesize centeringOnSeekerPosition;
@synthesize zoomMap;
@synthesize mapZoomedIn;
@synthesize canTouch;

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
    self.levelInitialized = YES;
    [self addChild:self.seeker1 z:0];
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
    [self moveMapTo:mapTranslated withDuration:1.0];
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
    if (self.crash){
        [self.crash removeFromParentAndCleanup:YES];
        self.crash = nil;
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
    if (self.mapZoomedIn) {
        tileCoords = CGPointMake(tileCoords.x / kMAP_ZOOM_FACTOR, tileCoords.y / kMAP_ZOOM_FACTOR);
    }
	return CGPointMake(tileCoords.x, self.tileMapSize.height - tileCoords.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileCoordsToScreenCoords:(CGPoint)_tilePoint {
    CGPoint glCoords = CGPointMake(_tilePoint.x, self.tileMapSize.height - _tilePoint.y);
    if (self.mapZoomedIn) {
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
    if (self.mapZoomedIn) {
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
// program instructions
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark program instructions

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldMoveMap:(CGPoint)_delta {
    CGSize tileMapTileSize = self.tileMapSize;
    if (self.mapZoomedIn) {
        tileMapTileSize = CGSizeMake(kMAP_ZOOM_FACTOR * tileMapTileSize.width, kMAP_ZOOM_FACTOR * tileMapTileSize.height);
    }        
    CGPoint newMapPosition = ccpAdd(CGPointMake(-_delta.x, -_delta.y), self.tileMap.position);
    CGPoint newSeekerTilePosition = ccpAdd([self screenCoordsToTileCoords:self.seeker1.position], CGPointMake(_delta.x, -_delta.y));
    CGPoint newSeekerScreenPosition = [self tileCoordsToScreenCoords:newSeekerTilePosition];
    CGPoint center = self.screenCenter;
    if (self.seeker1.bearing == WestSeekerBearing) {
         if (newMapPosition.x > 0) {
             return NO;
         } else if ((newMapPosition.x + tileMapTileSize.width) < 0) {
             return NO;
         } else if ((newSeekerTilePosition.x - center.x) <= 0) {
             return NO;
         } else if ((center.x - newSeekerScreenPosition.x) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == EastSeekerBearing) {
         if (newMapPosition.x > 0) {
             return NO;
         } else if ((newMapPosition.x + tileMapTileSize.width) < 0) {
             return NO;
         } else if ((tileMapTileSize.width - newSeekerTilePosition.x - center.x) <= 0) {
             return NO;
         } else if ((newSeekerScreenPosition.x - center.x) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == NorthSeekerBearing) {
         if (newMapPosition.y > 0) {
             return NO;
         } else if ((newMapPosition.y + tileMapTileSize.height) < 0) {
             return NO;
         } else if ((newSeekerTilePosition.y - center.y) <= 0) {
             return NO;
         } else if ((newSeekerScreenPosition.y - center.y) <= 0) {
             return NO;
         }
     } else if (self.seeker1.bearing == SouthSeekerBearing) {
         if (newMapPosition.y > 0) {
             return NO;
         } else if ((newMapPosition.y + tileMapTileSize.height) < 0) {
             return NO;
         } else if ((tileMapTileSize.height - newSeekerTilePosition.y - center.y) <= 0) {
             return NO;
         } else if ((center.y - newSeekerScreenPosition.y) <= 0) {
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
    } else {
        [self halt];
        [self crashProgram];
    }
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
                        [self moveMapTo:mapPosition withDuration:1.0];
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
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoEnergy {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_NO_ENERGY andMessage:kERROR_MSG_NO_ENERGY];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSpeedHigh {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SPEED_HIGH andMessage:kERROR_MSG_SPEED_HIGH];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSpeedLow {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SPEED_LOW andMessage:kERROR_MSG_SPEED_LOW];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashProgram {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_PROGRAM_CRASH andMessage:kERROR_MSG_PROGRAM_CRASH];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashTerrain {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_TERRRAIN andMessage:kERROR_MSG_TERRRAIN];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSensorBinEmpty {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SENSOR_BIN_EMPTY andMessage:kERROR_MSG_SENSOR_BIN_EMPTY];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSensorSiteAtPosition {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_EXPECTED_SENSOR andMessage:kERROR_MSG_EXPECTED_SENSOR];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSampleBinFull {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_SAMPLE_BIN_FULL andMessage:kERROR_MSG_SAMPLE_BIN_FULL];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSampleAtPosition {
    [LevelModel setLevel:self.level errorCode:kERROR_CODE_EXPECTED_SAMPLE andMessage:kERROR_MSG_EXPECTED_SAMPLE];
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// crash animations
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark crash animations

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fadeToRed {
    NSString* seekerName = [NSString stringWithFormat:@"red-seeker-1-%@.png", [self.seeker1 bearingToString]];
    self.crash = [[[CCSprite alloc] initWithFile:seekerName] autorelease]; 
    if (self.mapZoomedIn) {
        self.crash.scale = kMAP_ZOOM_FACTOR;
    } else {
        self.crash.scale = 1.0;
    }
    self.crash.opacity = 0.0;
    self.crash.position = self.seeker1.position;
    [self addChild:self.crash];
	[self.crash runAction:[CCFadeIn actionWithDuration:1.0]];
    self.levelCrash = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// level completed animations
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark level completed animations

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)runLevelCompletedAnimation {
    self.levelCompleted = NO;
    [self.seeker1 rotate:360.0];
    self.nextLevel = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)levelCompletedAnimation {
    self.levelCompleted = YES;
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
    self.menu.position = CGPointMake(160.0f, 395.0f);
    [self addChild:menu];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertLowerMenu {
    CCSprite* menuImage = [CCSprite spriteWithFile:@"map-back.png"];
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:menuImage selectedSprite:menuImage target:self selector:@selector(mapBack)];
    CCMenu* lowerMenu = [CCMenu menuWithItems:menuItem, nil];
    [lowerMenu alignItemsHorizontallyWithPadding:0.0];
    lowerMenu.position = CGPointMake(63.0f, 20.0f);
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
    } else if (self.crash) {
        [self.crash runAction:[CCMoveBy actionWithDuration:duration position:delta]];
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
    if (self.mapZoomedIn) {
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
    } else if (self.crash) {
        CGPoint crashPosition = [self screenCoordsToTileCoords:self.crash.position];
        mapTranslated = [self tileMapTranslatedToPoint:CGPointMake(crashPosition.x, self.tileMapSize.height - crashPosition.y)];
        CGPoint delta = ccpSub(mapTranslated, mapPosition);
        duration = [self panDuration:delta];
        [self.crash runAction:[CCMoveBy actionWithDuration:duration position:delta]];
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
- (void)onTouchZoomMap {
    self.zoomMap = NO;
    if (self.mapZoomedIn) {
        self.mapZoomedIn = NO;
        [self onTouchZoomMapOut];
    } else {
        self.mapZoomedIn = YES;
        [self onTouchZoomMapIn];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onTouchZoomMapIn {
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
- (void)onTouchZoomMapOut {
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
        self.levelResetSeeker = NO;
        self.levelResetMap = NO;
        self.levelInitSeeker = NO;
        self.levelInitialized = NO;
        self.levelCrash = NO;
        self.levelCompleted = NO;
        self.nextLevel = NO;
        self.movingMapOnTouch = NO;
        self.centeringOnSeekerPosition = NO;
        self.mapZoomedIn = NO;
        self.zoomMap = NO;
        self.canTouch = NO;
        self.endOfMissionCounter = 0;
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
    if (self.crash) {crashActions = [self.crash numberOfRunningActions];}
	if (mapActions == 0 && seekerActions == 0 && crashActions == 0) {
        ProgramNgin* ngin = [ProgramNgin instance];
        if (self.levelInitSeeker) {
            [self setSeekerStartPosition];
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
        } else if (self.zoomMap) {
            [self onTouchZoomMap];
        } else if (self.centeringOnSeekerPosition) {
            [self centerOnSeekerPosition];
        } else if ([ngin programIsRunning]) {
            [self executeSeekerInstruction:dt];
        }
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [TouchUtils locationFromTouches:touches]; 
    if ([self acceptTouches:touchLocation]) {
        self.firstTouch = [TouchUtils locationFromTouches:touches]; 
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [TouchUtils locationFromTouches:touches]; 
    if ([self acceptTouches:touchLocation]) {
        NSInteger numberOfTouches = [[touches anyObject] tapCount];
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
        } else if (numberOfTouches == 1) {
            self.centeringOnSeekerPosition = YES;
        } else if (numberOfTouches == 2) {
            self.zoomMap = YES;
        }
    }
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
- (CGPoint)moveDeltaTileCoords {
    CGSize moveSize = self.tileMap.tileSize;
    return [self.seeker1 positionDeltaAlongBearing:moveSize];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)moveDeltaScreenCoords:(CGPoint)_delta {
    if (self.mapZoomedIn) {
        _delta = CGPointMake(kMAP_ZOOM_FACTOR * _delta.x, kMAP_ZOOM_FACTOR * _delta.y);
    }    
    return _delta;
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
