//
//  MapScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapScene.h"
#import "TermMenuView.h"
#import "SeekerSprite.h"
#import "StatusDisplay.h"
#import "ProgramNgin.h"
#import "TouchUtils.h"
#import "UserModel.h"
#import "LevelModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

// inialize
- (void)initLevel;
- (void)initNextLevel;
- (void)setSeekerStartPosition;
- (void)initStatusDisplay;
- (CCTMXTiledMap*)initMap;
- (void)centerTileMapOnStartPoint;
// reset
- (void)resetMap;
- (void)resetSeekerStartPosition;
- (CGPoint)getTile:(CGPoint)_tileCoords;
// coordinate transforms
- (CGPoint)getPointFromObjectPropertiesInScreenCoords:(NSDictionary*)dict;
- (CGPoint)getPointFromObjectPropertiesInTileCoords:(NSDictionary*)dict;
- (CGPoint)screenCoordsToTileCoords:(CGPoint)_point;
- (CGPoint)tileCoordsToTile:(CGPoint)point;
// program instructions
- (BOOL)shouldMoveMap:(CGPoint)_delta;
- (BOOL)moveIsInPlayingArea:(CGPoint)_delta;
- (void)executeSeekerInstruction:(ccTime)dt;
- (NSDictionary*)getTileProperties:(CGPoint)_point forLayer:(CCTMXLayer*)_layer;
- (CGPoint)getSeekerTile;
- (CGFloat)tileUsedEnergy;
- (BOOL)isItemTileType:(NSString*)_itemType;
- (BOOL)isStationTile;
- (void)move;
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration;
- (void)putSensor;
- (void)getSample;
// display parameter updates
- (void)updateEnergy;
- (void)updateSensorCount;
- (void)updateSampleCount;
// seeker crash
- (void)crashHitMapBoundary;
- (void)crashNoEnergy;
- (void)crashSensorBinEmpty;
- (void)crashNoSensorSiteAtPosition;
- (void)crashSensorSiteAtPositionMissed;
- (void)crashSampleBinFull;
- (void)crashNoSampleAtPosition;
- (void)crashSampleAtPositionMissed;
// crash animations
- (void)fadeToRed;
// level completed animations
- (void)runLevelCompletedAnimation;
- (void)levelCompletedAnimation;
// menu
- (void)initTerminalItems;
- (void)addResetTerminalItems;
- (void)addRunTerminalItems;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize seeker1;
@synthesize statusDisplay;
@synthesize screenCenter;
@synthesize tileMapSize;
@synthesize level;
@synthesize startSite;
@synthesize menu;
@synthesize tileMap;
@synthesize mapLayer;
@synthesize terrainLayer;
@synthesize itemsLayer;
@synthesize objectsLayer;
@synthesize crash;
@synthesize levelResetSeeker;
@synthesize levelResetMap;
@synthesize levelInitSeeker;
@synthesize levelCrash;
@synthesize levelCompleted;
@synthesize nextLevel;

//===================================================================================================================================
#pragma mark MapScene PrivateAPI
//-----------------------------------------------------------------------------------------------------------------------------------
// initialize
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark initialize

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initLevel {
//#define kDEBUG_LEVEL 2
#ifdef kDEBUG_LEVEL   
    self.level = kDEBUG_LEVEL;
#else    
    self.level = [UserModel level];
    [LevelModel insertForLevel:self.level];
#endif    
    self.tileMap = [self initMap];
    CGSize tileMapTiles = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    self.tileMapSize = CGSizeMake(tileMapTiles.width*tileMapTileSize.width, tileMapTiles.height*tileMapTileSize.height);
    [self centerTileMapOnStartPoint];
    [self initTerminalItems];
    [self.menu mapInitItems];
    [self addChild:self.tileMap z:-1 tag:kMAP];
    self.levelInitSeeker = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initNextLevel {
    self.nextLevel = NO;
#ifndef kDEBUG_LEVEL    
    [UserModel nextLevel];
#endif    
    [self.tileMap removeFromParentAndCleanup:YES];
    [self.seeker1 removeFromParentAndCleanup:YES];
    [[ProgramNgin instance] deleteProgram];
    [self initLevel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CCTMXTiledMap*)initMap {
    NSString* mapName = [NSString stringWithFormat:@"map-%d.tmx", self.level];
    CCTMXTiledMap* map = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    self.mapLayer = [map layerNamed:@"map"];
    self.terrainLayer = [map layerNamed:@"terrain"];
    self.itemsLayer = [map layerNamed:@"items"];
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
    [self addChild:self.seeker1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initStatusDisplay {
    [self.statusDisplay setDigits:self.seeker1.energyTotal forDisplay:EnergyDisplayType];
    [self.statusDisplay setDigits:self.seeker1.speed forDisplay:SpeedDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sensorSites forDisplay:SensorDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sampleSites forDisplay:SampleDisplayType];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerTileMapOnStartPoint {
    CGPoint startPoint = [self getPointFromObjectPropertiesInTileCoords:self.startSite];
    CGPoint mapTranslation = ccpSub(self.screenCenter, startPoint);
    if (startPoint.x < self.screenCenter.x) {
        mapTranslation.x = 0.0;
    } else if ((self.tileMapSize.width - startPoint.x) < self.screenCenter.x) {
        mapTranslation.x = self.tileMapSize.width - 2.0*self.screenCenter.x;
    } 
    if (startPoint.y < self.screenCenter.y) {
        mapTranslation.y = 0.0;
    } else if ((self.tileMapSize.height - startPoint.y) < self.screenCenter.y) {
        mapTranslation.y = self.tileMapSize.height - 2.0*self.screenCenter.y;
    }  
    [self moveMapTo:CGPointMake(mapTranslation.x, mapTranslation.y) withDuration:1.0];
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
- (CGPoint)getTile:(CGPoint)_tileCoords {
    CGPoint tile = [self tileCoordsToTile:_tileCoords];
    return CGPointMake((int)tile.x, (int)tile.y);
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
    CGPoint tileMapPos = self.tileMap.position;
    CGPoint screenCoords = ccpSub(_screenPoint, tileMapPos);
	return CGPointMake(screenCoords.x, tileMapSize.height - screenCoords.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileCoordsToTile:(CGPoint)_point {
	CGFloat tileWidth = self.tileMap.tileSize.width;
	CGFloat tileHeight = self.tileMap.tileSize.height;	
	return CGPointMake(_point.x/tileWidth, _point.y/tileHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
// program instructions
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark program instructions

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldMoveMap:(CGPoint)_delta {
    CGPoint newPosition = ccpAdd([self screenCoordsToTileCoords:self.seeker1.position], CGPointMake(_delta.x, -_delta.y));
    CGPoint seekerScreen = self.seeker1.position;
    if (self.seeker1.bearing == WestSeekerBearing) {        
        if (newPosition.x < self.screenCenter.x) {
            return NO;
        } else if ((self.screenCenter.x - seekerScreen.x) < 0) {
            return NO;
        }
    } else if (self.seeker1.bearing == EastSeekerBearing) {
        if ((self.tileMapSize.width - newPosition.x) < self.screenCenter.x) {
            return NO;
        } else if ((self.screenCenter.x - seekerScreen.x) > 0) {
            return NO;
        }
    } else if (self.seeker1.bearing == NorthSeekerBearing) {
        if (newPosition.y < self.screenCenter.y) {
            return NO;
        } else if ((self.screenCenter.y - seekerScreen.y) > 0) {
            return NO;
        }
    } else if (self.seeker1.bearing == SouthSeekerBearing) {
        if ((self.tileMapSize.height - newPosition.y) < self.screenCenter.y) {
            return NO;
        } else if ((self.screenCenter.y - seekerScreen.y) < 0) {
            return NO;
        }
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)moveIsInPlayingArea:(CGPoint)_delta {
    CGPoint newPosition = ccpAdd([self screenCoordsToTileCoords:self.seeker1.position], CGPointMake(_delta.x, -_delta.y));
    CGPoint tilePosition = [self tileCoordsToTile:newPosition];
    CGSize tiles = self.tileMap.mapSize; 
    if (tilePosition.x < kMAP_EDGE_BUFFER || tilePosition.x > (tiles.width - kMAP_EDGE_BUFFER)) {
        return NO;
    } else if (tilePosition.y < (kMAP_EDGE_BUFFER + 1) || tilePosition.y > (tiles.height - kMAP_EDGE_BUFFER)) {
        return NO;
    }
    return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)executeSeekerInstruction:(ccTime)dt {
    NSString* instruction = nil;
    ProgramNgin* ngin = [ProgramNgin instance];
    if ((instruction = [ngin nextInstruction])) {
        if ([instruction isEqualToString:@"move"]) {
            [self move];
        } else if ([instruction isEqualToString:@"turn left"]) {
            [self.seeker1 turnLeft];
        } else if ([instruction isEqualToString:@"put sensor"]) {
            [self putSensor];
        } else if ([instruction isEqualToString:@"get sample"]) {
            [self getSample];
        }
    }
    if ([self isStationTile]) {
        [self.seeker1 emptySampleBin];
        [self.seeker1 loadSensorBin];
    }
    if ([self.seeker1 isLevelCompleted]) {
        [[ProgramNgin instance] stopProgram];
        [LevelModel completeLevel:self.level withScore:100];
        [self levelCompletedAnimation];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSDictionary*)getTileProperties:(CGPoint)_point forLayer:(CCTMXLayer*)_layer {
    NSDictionary* properties = nil;
    int tileGID = [self.itemsLayer tileGIDAt:CGPointMake(_point.x, _point.y)];
    if (tileGID != 0) {
        properties = [self.tileMap propertiesForGID:tileGID];
    }
    return properties;
}
  
//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getSeekerTile {
    CGPoint seekerTile = [self tileCoordsToTile:[self screenCoordsToTileCoords:seeker1.position]];
    return CGPointMake((int)seekerTile.x, (int)seekerTile.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tileUsedEnergy {
    CGFloat usedEnergy = 1.0;
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* mapProperties = [self getTileProperties:seekerTile forLayer:self.terrainLayer];
    if (mapProperties) {
        NSString* mapID = [mapProperties valueForKey:@"mapID"];
        if ([mapID isEqualToString:@"level-1"]) {
            usedEnergy = -1.0;
        } else if ([mapID isEqualToString:@"level-2"]) {
            usedEnergy = 0.8;
        } else if ([mapID isEqualToString:@"level-3"]) {
            usedEnergy = 0.6;
        } else if ([mapID isEqualToString:@"level-4"]) {
            usedEnergy = 0.4;
        } else if ([mapID isEqualToString:@"level-5"]) {
            usedEnergy = 0.2;
        }
    } 
    return usedEnergy;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isItemTileType:(NSString*)_itemType {
    BOOL status = NO;
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* itemProperties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if (itemProperties) {
        NSString* itemID = [itemProperties valueForKey:@"itemID"];
        if ([itemID isEqualToString:_itemType]) {
            status = YES;
        }            
    }
    return status;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isStationTile {
    return [self isItemTileType:@"station"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)move {
    ProgramNgin* ngin = [ProgramNgin instance];
    CGPoint delta = [self.seeker1 positionDeltaAlongBearing:self.tileMap.tileSize];
    if ([self moveIsInPlayingArea:delta]) {
        CGFloat usedEnergy = [self tileUsedEnergy];
        if ([self.seeker1 useEnergy:usedEnergy]) {
            [self updateEnergy];
            if ([self shouldMoveMap:delta]) {
                CGPoint mapPosition = ccpAdd(CGPointMake(-delta.x, -delta.y), self.tileMap.position);
                [self moveMapTo:mapPosition withDuration:1.0];
            } else {
                [self.seeker1 moveBy:self.tileMap.tileSize];
            }
        } else {
            [ngin haltProgram];
            [self crashNoEnergy];
        }
    } else {
        [ngin haltProgram];
        [self crashHitMapBoundary];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration {
	[tileMap stopAllActions];
	[tileMap runAction:[CCMoveTo actionWithDuration:_duration position:_point]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)putSensor {
    ProgramNgin* ngin = [ProgramNgin instance];
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* properties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if (properties) {
        NSString* itemID = [properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sensorSite"]) {   
            if ([self.seeker1 putSensor]) {
                [self.itemsLayer removeTileAt:seekerTile];
                [self.itemsLayer setTileGID:kMAP_SENSOR_GID at:seekerTile];
                [self updateSensorCount];
            } else {
                [ngin haltProgram];
                [self crashSensorBinEmpty];
            }
        } else {
            [ngin haltProgram];
            [self crashNoSensorSiteAtPosition];
        }
    } else {
        [ngin haltProgram];
        [self crashNoSensorSiteAtPosition];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getSample {
    ProgramNgin* ngin = [ProgramNgin instance];
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* properties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if (properties) {
        NSString* itemID = [properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sample"]) {        
            if ([self.seeker1 getSample]) {
                [self.itemsLayer removeTileAt:seekerTile];
                [self updateSampleCount];
            } else {
                [ngin haltProgram];
                [self crashSampleBinFull];
            }
        } else {        
            [ngin haltProgram];
            [self crashNoSampleAtPosition];
        }
    } else {        
        [ngin haltProgram];
        [self crashNoSampleAtPosition];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
// display parameter updates
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark display parameter updates

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateEnergy {
    [self.statusDisplay setDigits:(int)(self.seeker1.energy + 0.001) forDisplay:EnergyDisplayType]; 
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
// seeker crashes
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark seeker crashes

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashCompleted {
    self.levelCrash = NO;
    [self.seeker1 removeFromParentAndCleanup:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashHitMapBoundary {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoEnergy {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSensorBinEmpty {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSensorSiteAtPosition {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSensorSiteAtPositionMissed {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSampleBinFull {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSampleAtPosition {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashSampleAtPositionMissed {
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
    self.crash.opacity = 0;
    self.crash.position = self.seeker1.position;
	[self.crash runAction:[CCFadeIn actionWithDuration:1.0]];
    [self addChild:self.crash];
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
- (void)initTerminalItems {
    [self.statusDisplay addTerminalText:@"$ main"];
    [self.statusDisplay addTerminalText:@"$ term"];
    [self.statusDisplay addTerminalText:@"$"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addResetTerminalItems {
    [self.statusDisplay addTerminalText:@"$ main"];
    [self.statusDisplay addTerminalText:@"$ term"];
    [self.statusDisplay addTerminalText:@"$ reset"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addRunTerminalItems {
    [self.statusDisplay addTerminalText:@"$ main"];
    [self.statusDisplay addTerminalText:@"$ term"];
    [self.statusDisplay addTerminalText:@"$ run"];
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
        self.statusDisplay = [StatusDisplay create];
        self.menu = [TermMenuView create];
        self.menu.mapScene = self;
        self.levelResetSeeker = NO;
        self.levelResetMap = NO;
        self.levelInitSeeker = NO;
        self.levelCrash = NO;
        self.levelCompleted = NO;
        self.nextLevel = NO;
        [self.statusDisplay insert:self];
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
        } else if (self.levelResetMap) {
            [self resetMap];
        } else if (self.levelResetSeeker) {
            [self resetSeekerStartPosition];
        } else if (self.levelCrash) {
            [self crashCompleted];
        } else if (self.levelCompleted) {
            [self runLevelCompletedAnimation];
        } else if (self.nextLevel) {
            [self initNextLevel];
        } else if ([ngin programIsRunning]) {
            [self executeSeekerInstruction:dt];
        }
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchLocation = [TouchUtils locationFromTouches:touches]; 
    if ([self.menu isInMenuRect:touchLocation]) {
        [self.menu showMenu];
    } else if (self.menu.menuIsOpen) {
        [self.menu hideMenu];
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetLevel {
    self.levelResetMap = YES;
}

@end
