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

- (void)loadMapLevel:(NSInteger)_level;
- (void)getSensorSites;
- (void)getSampleSites;
- (void)unloadCurrentMapLevel;
- (void)setSeekerStartPosition;
- (void)initStatusDisplay;
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict;
- (CGPoint)toTileCoords:(CGPoint)point;
- (void)centerTileMapOnPoint:(CGPoint)_point;
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
@synthesize level;
@synthesize energyLevel;
@synthesize energyCurrent;
@synthesize speed;
@synthesize startSite;
@synthesize sensorSites;
@synthesize sensorPool;
@synthesize sampleSites;
@synthesize menuRect;
@synthesize menu;
@synthesize tileMap;
@synthesize mapLayer;
@synthesize terrainLayer;
@synthesize itemsLayer;
@synthesize objectsLayer;
@synthesize menuIsOpen;

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
    [self getSampleSites];
    [self getSensorSites];
    self.startSite = [self.objectsLayer objectNamed:@"startSite"];
    CGPoint startPoint = [self getPointFromObjectProperties:self.startSite];
    [self centerTileMapOnPoint:startPoint];
    [self initStatusDisplay];
    [self addChild:self.tileMap z:-1 tag:kMAP];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)unloadCurrentMapLevel {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getSensorSites {
    for (NSMutableDictionary* obj in self.objectsLayer.objects) {
        NSString* objName = [obj valueForKey:@"name"];
        if ([objName isEqualToString:@"sensorSite"]) {
            [self.sensorSites addObject:obj];
        }
    }
    self.sensorPool = [self.sensorSites count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)getSampleSites {
    for (NSMutableDictionary* obj in self.objectsLayer.objects) {
        NSString* objName = [obj valueForKey:@"name"];
        if ([objName isEqualToString:@"sampleSite"]) {
            [self.sampleSites addObject:obj];
        }
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initStatusDisplay {
    self.energyLevel = [[self.startSite valueForKey:@"energy"] intValue];
    [self.statusDisplay setDigits:self.energyLevel forDisplay:EnergyDisplayType];
    [self.statusDisplay setDigits:self.speed forDisplay:SpeedDisplayType];
    [self.statusDisplay setDigits:[self.sampleSites count] forDisplay:SampleDisplayType];
    [self.statusDisplay setDigits:[self.sensorSites count] forDisplay:SensorDisplayType];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setSeekerStartPosition {
    CGPoint startPoint = [self getPointFromObjectProperties:self.startSite];
    NSString* bearing = [self.startSite valueForKey:@"bearing"];
    self.sensorPool = [self.seeker1 loadSensors:self.sensorPool];
    [self.seeker1 setToStartPoint:startPoint withBearing:bearing];
    [self addChild:self.seeker1];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)getPointFromObjectProperties:(NSDictionary*)dict {
	CGFloat x = [[dict valueForKey:@"x"] floatValue];
    CGFloat y = [[dict valueForKey:@"y"] floatValue];
    CGPoint mapPos = self.tileMap.position;
	return CGPointMake(x + mapPos.x, y + mapPos.y);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)toTileCoords:(CGPoint)_point {
	CGFloat mapHeight = self.tileMap.mapSize.height;
	CGFloat tileWidth = self.tileMap.tileSize.width;
	CGFloat tileHeight = self.tileMap.tileSize.height;	
	return CGPointMake(_point.x/tileWidth, mapHeight-_point.y/tileHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)centerTileMapOnPoint:(CGPoint)_point {
    CGPoint tileMapPos = self.tileMap.position;
    CGPoint currentCenter = ccpAdd(tileMapPos, self.screenCenter);
    CGPoint delta = ccpSub(_point, currentCenter);
    CGSize tileMapSize = self.tileMap.mapSize;
    CGSize tileMapTileSize = self.tileMap.tileSize;
    CGFloat edgeX = tileMapSize.width*tileMapTileSize.width - _point.x;
    CGFloat edgeY = tileMapSize.height*tileMapTileSize.height - _point.y;
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
        self.sensorSites = [NSMutableArray arrayWithCapacity:10];
        self.sampleSites = [NSMutableArray arrayWithCapacity:10];
        self.speed = 0;
        self.menu = [MapMenuView create];
        self.menuIsOpen = NO;
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay addTerminalText:@"$ term"];
        [self.statusDisplay addTerminalText:@"$ run"];
        [self loadMapLevel:1];
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    ProgramNgin* ngin = [ProgramNgin instance];
	if ([self.tileMap numberOfRunningActions] == 0) {
        if (self.seeker1.isUninitiailized) {
            [self setSeekerStartPosition];
        }
        if ([[ProgramNgin instance] runProgram] && [self.seeker1 numberOfRunningActions] == 0) {
            NSString* instruction = nil;
            if ((instruction = [ngin nextInstruction])) {
                if ([instruction isEqualToString:@"move"]) {
                } else if ([instruction isEqualToString:@"turn left"]) {
                } else if ([instruction isEqualToString:@"put sensor"]) {
                } else if ([instruction isEqualToString:@"get sample"]) {
                }
            }
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
- (void)terminal {
}

@end
