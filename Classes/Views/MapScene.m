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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapScene (PrivateAPI)

- (void)loadMapLevel:(NSInteger)_level;
- (void)unloadCurrentMapLevel;
- (void)setSeekerStartPosition;
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict;
- (CGPoint)toTileCoords:(CGPoint)point;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize seeker1;
@synthesize screenCenter;
@synthesize level;
@synthesize tileMap;
@synthesize gameDisplay;
@synthesize terrain;
@synthesize items;
@synthesize pathObjects;

//===================================================================================================================================
#pragma mark MapScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMapLevel:(NSInteger)_level {
    self.level = _level;
    NSString* mapName = [NSString stringWithFormat:@"map-%d.tmx", _level];
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    self.gameDisplay = [self.tileMap layerNamed:@"game-display"];
    self.terrain = [self.tileMap layerNamed:@"terrain"];
    self.items = [self.tileMap layerNamed:@"items"];
    self.pathObjects = [self.tileMap objectGroupNamed:@"path-objects"];
    [self setSeekerStartPosition];
    [self addChild:self.tileMap z:-1 tag:kMAP];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)unloadCurrentMapLevel {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSeekerStartPosition {
    NSDictionary* startObject = [self.pathObjects objectNamed:@"start"];
    CGPoint startPoint = [self getPointFromObjectProperties:startObject];
    CGPoint tilePos = [self toTileCoordsPoint:startPoint];
    self.seeker1 = [SeekerSprite create];
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
	float halfMapWidth = tileMap.mapSize.width * 0.5f;
	float mapHeight = tileMap.mapSize.height;
	float tileWidth = tileMap.tileSize.width;
	float tileHeight = tileMap.tileSize.height;	
	return CGPointMake(_point.x/tileWidth, mapHeight-_point.y/tileHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)

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
	if( (self=[super init] )) {
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		self.screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self loadMapLevel:1];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
}

@end
