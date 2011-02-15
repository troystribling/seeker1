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
- (CGSize)missionSize;
- (CGPoint)missionToPosition:(NSInteger)_mission;
- (BOOL)missionIsUnlocked:(NSInteger)_mission;
- (void)loadMissions;
- (void)loadMission:(NSInteger)_mission;
- (CCSprite*)getMissionSprite:(NSInteger)_mission;
- (void)addMissionLabel:(NSInteger)_mission toSprite:(CCSprite*)_sprite;
- (void)addMissionScore:(NSInteger)_mission toSprite:(CCSprite*)_sprite;

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
    NSInteger missionColumn = _position.x / missionWidth;
    NSInteger missionRow = (self.screenSize.height - displayOffset - _position.y) / missionHeight;
    return kMISSIONS_PER_ROW * missionRow + missionColumn;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGSize)missionSize {
    CGFloat displayOffset = self.statusDisplay.contentSize.height;
    NSInteger missionWidth = self.screenSize.width / kMISSIONS_PER_ROW;
    NSInteger missionHeight = (self.screenSize.height - displayOffset) / kMISSIONS_ROWS;
    return CGSizeMake(missionWidth, missionHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)missionToPosition:(NSInteger)_mission {
    CGFloat displayOffset = self.statusDisplay.contentSize.height;
    NSInteger missionRow = _mission / kMISSIONS_PER_ROW;
    NSInteger missionColumn = _mission - missionRow * kMISSIONS_PER_ROW;
    CGSize missionSize = [self missionSize];
    return CGPointMake(0.5 * missionSize.width + missionColumn * missionSize.width,  
                       self.screenSize.height - missionRow * missionSize.height - displayOffset - 0.5 * missionSize.height);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMissions {
    self.quadrangle = [UserModel quadrangle];
    self.levelsUnlocked =[LevelModel count];
    for (int i = 0; i < kMISSIONS_PER_QUAD; i++) {
        [self loadMission:i];
    }
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
        LevelModel* levelModel = [LevelModel findByLevel:[self missionToLevel:_mission]];
        if (levelModel.completed) {
            sprite = [[[CCSprite alloc] initWithFile:@"mission-complete.png"] autorelease];
        } else {
            sprite = [[[CCSprite alloc] initWithFile:@"mission-incomplete.png"] autorelease];
        }
        [self addMissionLabel:_mission toSprite:sprite];
        [self addMissionScore:_mission toSprite:sprite];
    } else {
        sprite = [[[CCSprite alloc] initWithFile:@"mission-locked.png"] autorelease];
    }
    sprite.anchorPoint = CGPointMake(0.5, 0.5);
    return sprite;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMissionLabel:(NSInteger)_mission toSprite:(CCSprite*)_sprite {
    CCLabel* missionLable = [CCLabel labelWithString:[NSString stringWithFormat:@"%d", _mission + 1] fontName:@"Courier" fontSize:26];
    CGSize missionSize = [self missionSize];
    missionLable.anchorPoint = CGPointMake(0.5, 0.5);
    missionLable.position = CGPointMake(0.285*missionSize.width, 0.31*missionSize.height);
    missionLable.color = ccc3(0,0,0); 
    [_sprite addChild:missionLable];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addMissionScore:(NSInteger)_mission toSprite:(CCSprite*)_sprite {
    LevelModel* levelModel = [LevelModel findByLevel:[self missionToLevel:_mission]];
    if ([levelModel score] > 0) {
        CCLabel* missionScore = [CCLabel labelWithString:[NSString stringWithFormat:@"%d", [levelModel score]] fontName:@"Courier" fontSize:16];
        CGSize missionSize = [self missionSize];
        missionScore.anchorPoint = CGPointMake(0.5, 0.5);
        missionScore.position = CGPointMake(0.29*missionSize.width, -0.06*missionSize.height);
        missionScore.color = ccc3(103,243,27); 
        [_sprite addChild:missionScore];
    }
}

//===================================================================================================================================
#pragma mark MissionsScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MissionsScene* layer = [MissionsScene node];
	[scene addChild:layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
		self.screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        self.statusDisplay = [StatusDisplay create];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"~> main"];
        [self.statusDisplay addTerminalText:@"~> site"];
        [self.statusDisplay addTerminalText:@"~>"];
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
        [[CCDirector sharedDirector] replaceScene:[MapScene scene]];
    }
}    

@end
