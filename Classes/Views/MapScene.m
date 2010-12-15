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

- (void)setSeekerStartPosition;
- (void)resetSeekerStartPosition;
- (void)initStatusDisplay;
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict;
- (CGPoint)screenCoordsToTileCoords:(CGPoint)_point;
- (CGPoint)tileCoordsToTile:(CGPoint)point;
- (void)centerTileMapOnStartPoint;
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration;
- (BOOL)shouldMoveMap:(CGPoint)_delta;
- (BOOL)moveIsInPlayingArea:(CGPoint)_delta;
- (void)executeSeekerInstruction:(ccTime)dt;
- (NSDictionary*)getTileProperties:(CGPoint)_point forLayer:(CCTMXLayer*)_layer;
- (CGPoint)getSeekerTile;
- (void)putSensor;
- (void)getSample;
- (CGPoint)locationFromTouch:(UITouch*)touch;
- (CGPoint)locationFromTouches:(NSSet*)touches;
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
@synthesize levelReset;
@synthesize levelUninitiailized;

//===================================================================================================================================
#pragma mark MapScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMapLevel:(NSInteger)_level {
    self.level = _level;
    NSString* mapName = [NSString stringWithFormat:@"map-%d.tmx", _level];
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    self.mapLayer = [self.tileMap layerNamed:@"map"];
    self.terrainLayer = [self.tileMap layerNamed:@"terrain"];
    self.itemsLayer = [self.tileMap layerNamed:@"items"];
    self.objectsLayer = [self.tileMap objectGroupNamed:@"objects"];
    CGSize tileMapTiles = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    self.tileMapSize = CGSizeMake(tileMapTiles.width*tileMapTileSize.width, tileMapTiles.height*tileMapTileSize.height);
    self.startSite = [self.objectsLayer objectNamed:@"startSite"];
    [self.seeker1 initParams:self.startSite];
    [self centerTileMapOnStartPoint];
    [self initStatusDisplay];
    [self addChild:self.tileMap z:-1 tag:kMAP];
    self.levelUninitiailized = YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initStatusDisplay {
    [self.statusDisplay setDigits:self.seeker1.energyTotal forDisplay:EnergyDisplayType];
    [self.statusDisplay setDigits:self.seeker1.speed forDisplay:SpeedDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sensorSites forDisplay:SampleDisplayType];
    [self.statusDisplay setDigits:self.seeker1.sampleSites forDisplay:SensorDisplayType];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSeekerStartPosition {
    CGPoint startPoint = [self getPointFromObjectProperties:self.startSite];
    NSString* bearing = [self.startSite valueForKey:@"bearing"];
    [self.seeker1 setToStartPoint:startPoint withBearing:bearing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)resetSeekerStartPosition {
    CGPoint startPoint = [self getPointFromObjectProperties:self.startSite];
    NSString* bearing = [self.startSite valueForKey:@"bearing"];
    [self.seeker1 resetToStartPoint:startPoint withBearing:bearing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict {
	CGFloat x = [[dict valueForKey:@"x"] floatValue];
    CGFloat y = [[dict valueForKey:@"y"] floatValue];
    CGPoint mapPos = self.tileMap.position;
	return CGPointMake(x + mapPos.x, y + mapPos.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)tileCoordsToTile:(CGPoint)_point {
	CGFloat tileWidth = self.tileMap.tileSize.width;
	CGFloat tileHeight = self.tileMap.tileSize.height;	
	return CGPointMake(_point.x/tileWidth, _point.y/tileHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)screenCoordsToTileCoords:(CGPoint)_screenPoint {
    CGPoint tileMapPos = self.tileMap.position;
    CGPoint screenCoords = ccpSub(_screenPoint, tileMapPos);
	return CGPointMake(screenCoords.x, tileMapSize.height - screenCoords.y);
}

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
    ProgramNgin* ngin = [ProgramNgin instance];
    NSString* instruction = nil;
    if ((instruction = [ngin nextInstruction])) {
        if ([instruction isEqualToString:@"move"]) {
            CGPoint delta = [self.seeker1 positionDeltaAlongBearing:self.tileMap.tileSize];
            if ([self moveIsInPlayingArea:delta]) {
                if ([self shouldMoveMap:delta]) {
                    CGPoint mapPosition = ccpAdd(CGPointMake(-delta.x, -delta.y), self.tileMap.position);
                    [self moveMapTo:mapPosition withDuration:1.0];
                } else {
                    [self.seeker1 moveBy:self.tileMap.tileSize];
                }
            } else {
                [ngin stopProgram];
            }
        } else if ([instruction isEqualToString:@"turn left"]) {
            [self.seeker1 turnLeft];
        } else if ([instruction isEqualToString:@"put sensor"]) {
            [self putSensor];
        } else if ([instruction isEqualToString:@"get sample"]) {
            [self getSample];
        }
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
- (void)putSensor {
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* properties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if (properties) {
        NSString* itemID = [properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sensorSite"]) {   
            [self.itemsLayer removeTileAt:seekerTile];
            [self.itemsLayer setTileGID:kMAP_SENSOR_GID at:seekerTile];
        } else {
        }
    } else {
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getSample {
    CGPoint seekerTile = [self getSeekerTile];
    NSDictionary* properties = [self getTileProperties:seekerTile forLayer:self.itemsLayer];
    if (properties) {
        NSString* itemID = [properties valueForKey:@"itemID"];
        if ([itemID isEqualToString:@"sample"]) {        
            [self.itemsLayer removeTileAt:seekerTile];
        } else {        
        }
    } else {        
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveMapTo:(CGPoint)_point withDuration:(CGFloat)_duration {
	CCAction* move = [CCMoveTo actionWithDuration:_duration position:_point];
	[tileMap stopAllActions];
	[tileMap runAction:move];
}

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

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerTileMapOnStartPoint {
    CGPoint startPoint = [self getPointFromObjectProperties:self.startSite];
    CGPoint tileMapPos = self.tileMap.position;
    CGPoint currentCenter = ccpAdd(tileMapPos, self.screenCenter);
    CGPoint delta = ccpSub(startPoint, currentCenter);
    CGFloat edgeX = self.tileMapSize.width - startPoint.x;
    CGFloat edgeY = self.tileMapSize.height - startPoint.y;
    if ((startPoint.x < self.screenCenter.x) && (delta.x < 0)) {
        delta.x = -tileMapPos.x;
    } else if ((edgeX < self.screenCenter.x) && (delta.x > 0)) {
        delta.x = self.tileMapSize.width - tileMapPos.x - 2.0*self.screenCenter.x;
    } 
    if ((startPoint.y < self.screenCenter.y) && (delta.y < 0)) {
        delta.y = -tileMapPos.y;
    } else if ((edgeY < self.screenCenter.y) && (delta.y > 0)) {
        delta.y = self.tileMapSize.height - tileMapPos.y - 2.0*self.screenCenter.y;
    }  
    [self moveMapTo:CGPointMake(-delta.x, -delta.y) withDuration:1.0];
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
        self.levelReset = NO;
        self.levelUninitiailized = NO;
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay addTerminalText:@"$ term"];
        [self loadMapLevel:1];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
	if ([self.tileMap numberOfRunningActions] == 0 && [self.seeker1 numberOfRunningActions] == 0) {
        ProgramNgin* ngin = [ProgramNgin instance];
        if (self.levelUninitiailized) {
            [self setSeekerStartPosition];
            [self addChild:self.seeker1];
            self.levelUninitiailized = NO;
        } else if (self.levelReset) {
            [self resetSeekerStartPosition];
            [self addChild:self.seeker1];
            self.levelReset = NO;
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
    [self.seeker1 removeFromParentAndCleanup:YES];
    [self centerTileMapOnStartPoint];
    self.levelReset = YES;
}

@end
