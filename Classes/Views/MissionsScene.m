//
//  MissionsScene.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MissionsScene.h"
#import "StatusDisplay.h"
#import "LevelModel.h"
#import "UserModel.h"
#import "TouchUtils.h"
#import "MapScene.h"
#import "TermMenuView.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MissionsScene (PrivateAPI)

- (NSInteger)missionToLevel:(NSInteger)_mission;
- (NSInteger)positionToMission:(CGPoint)_position;
- (CGPoint)missionToPosition:(NSInteger)_mission;
- (BOOL)missionIsUnlocked:(NSInteger)_mission;
- (CCSprite*)getMissionSprite:(NSInteger)_mission;
- (void)loadMissions;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MissionsScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize quadrangle;
@synthesize levelsUnlocked;
@synthesize screenSize;
@synthesize menu;

//===================================================================================================================================
#pragma mark MissionsScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)missionToLevel:(NSInteger)_mission {
    return kMISSIONS_PER_QUAD * self.quadrangle + _mission + 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)positionToMission:(CGPoint)_position {
    CGFloat displayOffset = self.statusDisplay.contentSize.height;
    NSInteger missionWidth = self.screenSize.width / kMISSIONS_PER_ROW;
    NSInteger missionHeight = (self.screenSize.height - displayOffset) / kMISSIONS_ROWS;
    NSInteger missionColumn = (_position.x - 0.5 * missionWidth ) / missionWidth;
    NSInteger missionRow = (self.screenSize.height - displayOffset - 0.5 * missionHeight - _position.y) / missionHeight;
    return missionRow + missionColumn;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)missionToPosition:(NSInteger)_mission {
    CGFloat displayOffset = self.statusDisplay.contentSize.height;
    NSInteger missionRow = _mission / kMISSIONS_PER_ROW;
    NSInteger missionColumn = _mission - missionRow * kMISSIONS_PER_ROW;
    NSInteger missionWidth = self.screenSize.width / kMISSIONS_PER_ROW;
    NSInteger missionHeight = (self.screenSize.height - displayOffset) / kMISSIONS_ROWS;
    return CGPointMake(0.5 * missionWidth + missionColumn * missionWidth,  
                       self.screenSize.height - missionRow * missionHeight - displayOffset - 0.5 * missionHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMission:(NSInteger)_mission {
    CCSprite* missionSprite = [self getMissionSprite:_mission];
    missionSprite.position = [self missionToPosition:_mission];
    [self addChild:missionSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)missionIsUnlocked:(NSInteger)_mission {
    NSInteger unlockedMissions = self.levelsUnlocked - kMISSIONS_PER_QUAD * self.quadrangle;
    if (_mission < unlockedMissions) {
        return YES;
    } else {
        return NO;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CCSprite*)getMissionSprite:(NSInteger)_mission {
    CCSprite* sprite = nil;
    if ([self missionIsUnlocked:_mission]) {
        sprite = [[[CCSprite alloc] initWithFile:@"mission-unlocked.png"] autorelease];
    } else {
        sprite = [[[CCSprite alloc] initWithFile:@"mission-locked.png"] autorelease];
    }
    sprite.anchorPoint = CGPointMake(0.5, 0.5);
    return sprite;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMissions {
    self.quadrangle = [UserModel quadrangle];
    self.levelsUnlocked =[LevelModel count];
    for (int i = 0; i < kMISSIONS_PER_QUAD; i++) {
        [self loadMission:i];
    }
}

//===================================================================================================================================
#pragma mark MissionsScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MissionsScene* layer = [MissionsScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
		self.screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        self.statusDisplay = [StatusDisplay create];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay addTerminalText:@"$ site"];
        [self.statusDisplay addTerminalText:@"$"];
        [self.statusDisplay test];
        self.menu = [TermMenuView create];
        [self.menu missionsInitItems];
        [self loadMissions];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
	CGPoint touchLocation = [TouchUtils locationFromTouches:touches];
    NSInteger mission = [self positionToMission:touchLocation];
    if ([self.menu isInMenuRect:touchLocation]) {
        [self.menu showMenu];
    } else if (self.menu.menuIsOpen) {
        [self.menu hideMenu];
    } else if ([self missionIsUnlocked:mission]) {
        NSInteger level = [self missionToLevel:mission];
        [UserModel setLevel:level];
        [[CCDirector sharedDirector] replaceScene: [MapScene scene]];
    }
}    

@end
