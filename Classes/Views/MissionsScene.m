//
//  MissionsScene.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MissionsScene.h"
#import "LevelModel.h"
#import "TouchUtils.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MissionsScene (PrivateAPI)

- (NSInteger)missionToLevel:(NSInteger)_mission;
- (NSInteger)positionToMission:(CGPoint)_position;
- (CGPoint)missionToPosition:(NSInteger)_mission;
- (BOOL)missionIsUnlocked:(NSInteger)_mission;
- (CCSprite*)getMissionSprite:(NSInteger)_mission;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MissionsScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize quadrangle;
@synthesize levelsUnlocked;
@synthesize screenSize;

//===================================================================================================================================
#pragma mark MissionsScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)missionToLevel:(NSInteger)_mission {
    return kMISSIONS_PER_QUAD * self.quadrangle + _mission + 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)positionToMission:(CGPoint)_position {
    NSInteger missionColumn = kMISSIONS_PER_ROW * (self.position.x / self.screenSize.width);
    NSInteger missionRow = (kMISSIONS_PER_QUAD / kMISSIONS_ROWS) * (self.position.y / self.screenSize.height);
    return missionRow + missionColumn;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGPoint)missionToPosition:(NSInteger)_mission {
    NSInteger missionRow = _mission / kMISSIONS_PER_ROW;
    NSInteger missionColumn = _mission - missionRow * kMISSIONS_PER_ROW;
    NSInteger missionWidth = self.screenSize.width / kMISSIONS_PER_ROW;
    NSInteger missionHeight = self.screenSize.height / kMISSIONS_ROWS;
    return CGPointMake(missionRow * missionHeight, missionColumn * missionWidth);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMission:(NSInteger)_mission {
    CCSprite* missionSprite = [self getMissionSprite:_mission];
    missionSprite.position = [self missionToPosition:_mission];
    [self addChild:missionSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)missionIsUnlocked:(NSInteger)_mission {
    NSInteger unlockedMissions = self.levelsUnlocked - kMISSIONS_PER_QUAD*(self.quadrangle - 1);
    if (_mission <= unlockedMissions + 1) {
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
    sprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    return sprite;
}

//===================================================================================================================================
#pragma mark MissionsScene

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadMissions:(NSInteger)_quadrangle {
    self.quadrangle = _quadrangle;
    self.levelsUnlocked =[LevelModel count];
    for (int i = 0; i < kMISSIONS_PER_QUAD; i++) {
        [self loadMission:i];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	MissionsScene *layer = [MissionsScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
		self.screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        [self loadMissions:0];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
	CGPoint touchLocation = [TouchUtils locationFromTouches:touches];
    NSInteger mission = [self positionToMission:touchLocation];
}    

@end
