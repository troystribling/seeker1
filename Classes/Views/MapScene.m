//
//  MapScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright imaginary products 2010. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapScene.h"
#import "SeekerSprite.h"
#import "StatusDisplay.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

- (void)loadMapLevel:(NSInteger)_level;
- (void)unloadCurrentMapLevel;
- (void)setSeekerStartPosition;
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict;
- (CGPoint)toTileCoords:(CGPoint)point;
- (void)centerTileMapOnPoint:(CGPoint)_point;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize seeker1;
@synthesize statusDisplay;
@synthesize screenCenter;
@synthesize level;
@synthesize tileMap;
@synthesize mapLayer;
@synthesize terrainLayer;
@synthesize itemsLayer;
@synthesize objectsLayer;

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
    NSDictionary* startObject = [self.objectsLayer objectNamed:@"start"];
    CGPoint startPoint = [self getPointFromObjectProperties:startObject];
    [self centerTileMapOnPoint:startPoint];
    [self addChild:self.tileMap z:-1 tag:kMAP];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)unloadCurrentMapLevel {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSeekerStartPosition {
    NSDictionary* startObject = [self.objectsLayer objectNamed:@"start"];
    CGPoint startPoint = [self getPointFromObjectProperties:startObject];
    NSString* orientation = [startObject valueForKey:@"orientation"];
    [self.seeker1 setToStartPoint:startPoint withOrientation:orientation];
    [self addChild:self.seeker1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict {
	float x = [[dict valueForKey:@"x"] floatValue];
    float y = [[dict valueForKey:@"y"] floatValue];
    CGPoint mapPos = self.tileMap.position;
	return CGPointMake(x + mapPos.x, y + mapPos.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)toTileCoords:(CGPoint)_point {
	float mapHeight = self.tileMap.mapSize.height;
	float tileWidth = self.tileMap.tileSize.width;
	float tileHeight = self.tileMap.tileSize.height;	
	return CGPointMake(_point.x/tileWidth, mapHeight-_point.y/tileHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerTileMapOnPoint:(CGPoint)_point {
    CGPoint tileMapPos = self.tileMap.position;
    CGPoint currentCenter = ccpAdd(tileMapPos, self.screenCenter);
    CGPoint delta = ccpSub(_point, currentCenter);
    CGSize tileMapSize = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    float edgeX = tileMapSize.width*tileMapTileSize.width - _point.x;
    float edgeY = tileMapSize.height*tileMapTileSize.height - _point.y;
    if ((_point.x < self.screenCenter.x) && (delta.x < 0)) {
        delta.x = -tileMapPos.x;
    } else if ((edgeX < self.screenCenter.x) && (delta.x > 0)) {
        delta.x = self.tileMap.mapSize.width*tileMapTileSize.width - tileMapPos.x - 2.0*self.screenCenter.x;
    } 
    if ((_point.y < self.screenCenter.y) && (delta.y < 0)) {
        delta.y = -tileMapPos.y;
    } else if ((edgeY < self.screenCenter.y) && (delta.y > 0)) {
        delta.y = self.tileMap.mapSize.height*tileMapTileSize.height - tileMapPos.y - 2.0*self.screenCenter.y;
    } 
	CCAction* move = [CCMoveTo actionWithDuration:1.0f position:CGPointMake(-delta.x, -delta.y)];
	[tileMap stopAllActions];
	[tileMap runAction:move];
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
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		self.screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        self.seeker1 = [SeekerSprite create];
        self.statusDisplay = [StatusDisplay createWithFile:@"map-display.png"];
        [self.statusDisplay insert:self];
        [self loadMapLevel:1];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
	if ([self.tileMap numberOfRunningActions] == 0) {
        if (self.seeker1.isUninitiailized) {
            [self setSeekerStartPosition];
        }
	}
}

@end
