//
//  MapScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapScene.h"
#import "MapMenuView.h"
#import "SeekerSprite.h"
#import "StatusDisplay.h"
#import "ProgramNgin.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

// inialize
- (void)initLevel;
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
- (void)crashNoSensorInBin;
- (void)crashNoSensorAtPosition;
- (void)crashSampleBinFull;
- (void)crashNoSampleAtPosition;
// crash animations
- (void)fadeToRed;
// level completed animations
- (void)runLevelCompletedAnimation;
- (void)levelCompletedAnimation;
// touches
- (CGPoint)locationFromTouch:(UITouch*)touch;
- (CGPoint)locationFromTouches:(NSSet*)touches;
// menu
- (BOOL)isInMenuRect:(CGPoint)_point;
- (void)showMenu;
- (void)terminal;

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
@synthesize menuRect;
@synthesize menu;
@synthesize tileMap;
@synthesize mapLayer;
@synthesize terrainLayer;
@synthesize itemsLayer;
@synthesize objectsLayer;
@synthesize menuIsOpen;
@synthesize crash;
@synthesize levelResetSeeker;
@synthesize levelResetMap;
@synthesize levelInitSeeker;
@synthesize levelCrash;
@synthesize levelCompleted;

//===================================================================================================================================
#pragma mark MapScene PrivateAPI
//-----------------------------------------------------------------------------------------------------------------------------------
// initialize
//-----------------------------------------------------------------------------------------------------------------------------------
#pragma mark initialize

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initLevel {
    self.level = 1;
    self.tileMap = [self initMap];
    CGSize tileMapTiles = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    self.tileMapSize = CGSizeMake(tileMapTiles.width*tileMapTileSize.width, tileMapTiles.height*tileMapTileSize.height);
    [self.seeker1 initParams:self.startSite];
    [self centerTileMapOnStartPoint];
    [self initStatusDisplay];
    [self addChild:self.tileMap z:-1 tag:kMAP];
    self.levelInitSeeker = YES;
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
    } else if (tilePosition.y < 1 + kMAP_EDGE_BUFFER || tilePosition.y > (tiles.height - kMAP_EDGE_BUFFER - 1)) {
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
    if ([self.seeker1 isLevelCompleted]) {
        [ngin stopProgram];
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
            [ngin stopProgram];
            [self crashNoEnergy];
        }
    } else {
        [ngin stopProgram];
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
                [ngin stopProgram];
                [self crashNoSensorInBin];
            }
        } else {
            [ngin stopProgram];
            [self crashNoSensorAtPosition];
        }
    } else {
        [ngin stopProgram];
        [self crashNoSensorAtPosition];
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
            if ([self.seeker1 putSensor]) {
                [self.itemsLayer removeTileAt:seekerTile];
                [self updateSampleCount];
            } else {
                [ngin stopProgram];
                [self crashSampleBinFull];
            }
        } else {        
            [ngin stopProgram];
            [self crashNoSampleAtPosition];
        }
    } else {        
        [ngin stopProgram];
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
- (void)crashNoSensorInBin {
    [self fadeToRed];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)crashNoSensorAtPosition {
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
    [self.seeker1 rotate:360.0];
    self.levelCompleted = NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)levelCompletedAnimation {
    self.levelCompleted = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// touches
//-----------------------------------------------------------------------------------------------------------------------------------

#pragma mark touches
//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView:[touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)locationFromTouches:(NSSet*)touches {
	return [self locationFromTouch:[touches anyObject]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// menu
//-----------------------------------------------------------------------------------------------------------------------------------

#pragma mark menu
//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isInMenuRect:(CGPoint)_point {
    BOOL isInRect = NO;
    CGFloat xDelta = _point.x - self.menuRect.origin.x;
    CGFloat yDelta = _point.y - self.menuRect.origin.y;
    if (xDelta < self.menuRect.size.width && yDelta < self.menuRect.size.height && xDelta > 0 && yDelta > 0) {
        isInRect = YES;
    }
    return isInRect;    
}
 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMenu {
    [[[CCDirector sharedDirector] openGLView] addSubview:self.menu];
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
        self.menuRect = CGRectMake(0.75*screenSize.width, 0.88*screenSize.height, 0.21*screenSize.width, 0.1*screenSize.height);
		self.screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
        self.seeker1 = [SeekerSprite create];
        self.statusDisplay = [StatusDisplay create];
        self.menu = [MapMenuView create];
        self.menu.mapScene = self;
        self.menuIsOpen = NO;
        self.levelResetSeeker = NO;
        self.levelResetMap = NO;
        self.levelInitSeeker = NO;
        self.levelCrash = NO;
        self.levelCompleted = NO;
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay addTerminalText:@"$ term"];
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
        } else if ([ngin runProgram]) {
            [self executeSeekerInstruction:dt];
        }
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchLocation = [self locationFromTouches:touches]; 
    if ([self isInMenuRect:touchLocation]) {
        self.menuIsOpen = YES;
        [self showMenu];
    } else if (self.menuIsOpen) {
        [self.menu removeFromSuperview];
    }

}    

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetLevel {
    self.levelResetMap = YES;
}

@end
