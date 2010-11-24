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
- (CGRect)getRectFromObjectProperties:(NSDictionary*)dict;
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize seeker1;
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
    self.seeker1 = [SeekerSprite create];
    NSString* orientation = [startObject valueForKey:@"orientation"];
    [self.seeker1 setToStartPoint:startPoint withOrientation:orientation];
    [self addChild:self.seeker1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGRect)getRectFromObjectProperties:(NSDictionary*)dict {
	float x, y, width, height;
	x = [[dict valueForKey:@"x"] floatValue] + self.tileMap.position.x;
	y = [[dict valueForKey:@"y"] floatValue] + self.tileMap.position.y;
	width = [[dict valueForKey:@"width"] floatValue];
	height = [[dict valueForKey:@"height"] floatValue];
	return CGRectMake(x, y, width, height);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict {
	float x, y;
	x = [[dict valueForKey:@"x"] floatValue] + self.tileMap.position.x;
	y = [[dict valueForKey:@"y"] floatValue] + self.tileMap.position.y;
	return CGPointMake(x, y);
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
	if( (self=[super init] )) {
        [self loadMapLevel:1];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
}

@end
