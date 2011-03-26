//
//  QuadsScene.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "QuadsScene.h"
#import "MainScene.h"
#import "NavigationDisplay.h"
#import "TouchUtils.h"
#import "LevelModel.h"
#import "UserModel.h"
#import "MissionsScene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kQUAD_IMAGE_YDELTA          80.0f
#define kQUAD_IMAGE_XDELTA          -7.5f
#define kMISSIONS_COMPLETED_DELTA   120.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene (PrivateAPI)

- (void)initQuads;
- (BOOL)displayedQuadIsUnlocked;
- (void)fowardQuadsToDisplayedQuad;
- (void)fowardQuads;
- (void)backwardQuads;
- (void)shiftQuadsForward;
- (void)shiftQuadsBackward;
- (void)moveQuadsBy:(CGFloat)_delta withDuration:(CGFloat)_duration;
- (void)stopRunningQuads;
- (NSInteger)percentComplete:(NSInteger)_quad;
- (NSInteger)totalScore:(NSInteger)_quad;
- (void)addQuadStats:(NSInteger)_quad toSprite:(CCSprite*)_sprite;
- (void)addTitle;
- (void)backNavigation;
- (NSInteger)quadsUnlockedCount;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QuadsScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize navigationDisplay;
@synthesize tharsisSprite;
@synthesize memnoniaSprite;
@synthesize elysiumSprite;
@synthesize titleSprite;
@synthesize displayedQuad;
@synthesize screenCenter;
@synthesize firstTouch;
@synthesize setTitle;
@synthesize runningActions;

//===================================================================================================================================
#pragma mark QuadsScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initQuads {    
    NSInteger quadsUnlocked = [self quadsUnlockedCount];
    CGFloat quadShiftDelta = self.tharsisSprite.contentSize.height + kQUAD_IMAGE_YDELTA;
    
    self.displayedQuad = [UserModel quadrangle];
    self.tharsisSprite.position = CGPointMake(self.screenCenter.x + kQUAD_IMAGE_XDELTA, self.screenCenter.y);
    [self addChild:self.tharsisSprite z:-1];

    if (quadsUnlocked >= 1) {
        self.memnoniaSprite = [[[CCSprite alloc] initWithFile:@"memnonia.png"] autorelease];
        [self addQuadStats:MemnoniaQuadType toSprite:self.memnoniaSprite];
    } else {
        self.memnoniaSprite = [[[CCSprite alloc] initWithFile:@"memnonia-locked.png"] autorelease];
    }
    if (quadsUnlocked >= 2) {
        self.elysiumSprite = [[[CCSprite alloc] initWithFile:@"elysium.png"] autorelease];
        [self addQuadStats:ElysiumQuadType toSprite:self.elysiumSprite];
    } else {
        self.elysiumSprite = [[[CCSprite alloc] initWithFile:@"elysium-locked.png"] autorelease];
    }    
    self.memnoniaSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.tharsisSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    CGPoint nextPosition = CGPointMake(self.screenCenter.x + kQUAD_IMAGE_XDELTA, self.screenCenter.y - quadShiftDelta);
    self.memnoniaSprite.position = nextPosition;
    [self addChild:self.memnoniaSprite z:-1];

    nextPosition = CGPointMake(self.screenCenter.x + kQUAD_IMAGE_XDELTA, self.screenCenter.y - 2 * quadShiftDelta);
    self.elysiumSprite.position = nextPosition;
    [self addChild:self.elysiumSprite z:-1];
    
    [self fowardQuadsToDisplayedQuad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)displayedQuadIsUnlocked {
    NSInteger quadsUnlocked = [self quadsUnlockedCount];
    if (self.displayedQuad <= quadsUnlocked) {
        return YES;
    } else {
        return NO;
    }

}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fowardQuadsToDisplayedQuad {
    if (self.displayedQuad > 0) {
        CGFloat quadShiftDelta = self.displayedQuad * (self.tharsisSprite.contentSize.height + kQUAD_IMAGE_YDELTA);
        [self moveQuadsBy:quadShiftDelta withDuration:self.displayedQuad*0.2];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fowardQuads {
    switch (self.displayedQuad) {
        case TharsisQuadType:
            self.displayedQuad  = MemnoniaQuadType;
            [self shiftQuadsForward];
            break;
        case MemnoniaQuadType:
            self.displayedQuad  = ElysiumQuadType;
            [self shiftQuadsForward];
            break;
        case ElysiumQuadType:
            break;
        default:
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)backwardQuads {
    switch (self.displayedQuad) {
        case TharsisQuadType:
            break;
        case MemnoniaQuadType:
            self.displayedQuad  = TharsisQuadType;
            [self shiftQuadsBackward];
            break;
        case ElysiumQuadType:
            self.displayedQuad  = MemnoniaQuadType;
            [self shiftQuadsBackward];
            break;
        default:
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)shiftQuadsForward {
    CGFloat quadShiftDelta = self.tharsisSprite.contentSize.height + kQUAD_IMAGE_YDELTA;
    [self moveQuadsBy:quadShiftDelta withDuration:0.2];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)shiftQuadsBackward {
    CGFloat quadShiftDelta = -(self.tharsisSprite.contentSize.height + kQUAD_IMAGE_YDELTA);
    [self moveQuadsBy:quadShiftDelta withDuration:0.2];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)moveQuadsBy:(CGFloat)_delta withDuration:(CGFloat)_duration {
    [self stopRunningQuads];
    
    CGPoint tharsisPosition = self.tharsisSprite.position;
    CGPoint tharsisNextPosition = CGPointMake(tharsisPosition.x, tharsisPosition.y + _delta);
	[self.tharsisSprite runAction:[CCMoveTo actionWithDuration:_duration position:tharsisNextPosition]];
    
    CGPoint memnoniaPosition = self.memnoniaSprite.position;
    CGPoint memnoniaNextPosition = CGPointMake(memnoniaPosition.x, memnoniaPosition.y + _delta);
	[self.memnoniaSprite runAction:[CCMoveTo actionWithDuration:_duration position:memnoniaNextPosition]];
    
    CGPoint elysiumPosition = self.elysiumSprite.position;
    CGPoint elysiumNextPosition = CGPointMake(elysiumPosition.x, elysiumPosition.y + _delta);
	[self.elysiumSprite runAction:[CCMoveTo actionWithDuration:_duration position:elysiumNextPosition]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)stopRunningQuads {
    [self.tharsisSprite stopAllActions];
    [self.memnoniaSprite stopAllActions];
    [self.elysiumSprite stopAllActions];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)percentComplete:(NSInteger)_quad {
    NSInteger completedLevels = [LevelModel completedLevelsByQudrangle:_quad];
    return 100.0*((float)completedLevels/(float)kMISSIONS_PER_QUAD);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)totalScore:(NSInteger)_quad {
    NSInteger score = [LevelModel totalScoreByQudrangle:_quad];
    return score;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addQuadStats:(NSInteger)_quad toSprite:(CCSprite*)_sprite {
    NSInteger perComp = [self percentComplete:_quad];
    NSInteger score = [self totalScore:_quad];
    CGSize spriteSize = _sprite.contentSize;

    CCSprite* perCompSprite = [CCSprite spriteWithFile:@"missions-completed.png"];
    perCompSprite.anchorPoint = CGPointMake(0.0, 0.0);
    perCompSprite.position = CGPointMake(0.115*spriteSize.width, -0.07*spriteSize.height);
    CCLabelTTF* perCompLable = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d%%", perComp] fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_MISSION];
    perCompLable.anchorPoint = CGPointMake(0.0, 0.0);
    perCompLable.position = CGPointMake(0.115*spriteSize.width + kMISSIONS_COMPLETED_DELTA, -0.075*spriteSize.height);
    perCompLable.color = kCCLABEL_FONT_COLOR; 
    [_sprite addChild:perCompLable];
    [_sprite addChild:perCompSprite];

    CCSprite* scoreSprite = [CCSprite spriteWithFile:@"missions-total-score.png"];
    scoreSprite.anchorPoint = CGPointMake(0.0, 0.0);
    scoreSprite.position = CGPointMake(0.115*spriteSize.width, -0.135*spriteSize.height);
    CCLabelTTF* scoreLable = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score] fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE_MISSION];
    scoreLable.anchorPoint = CGPointMake(0.0, 0.0);
    scoreLable.position = CGPointMake(0.115*spriteSize.width + kMISSIONS_COMPLETED_DELTA, -0.135*spriteSize.height);
    scoreLable.color = kCCLABEL_FONT_COLOR; 
    [_sprite addChild:scoreLable];
    [_sprite addChild:scoreSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addTitle {
    NSInteger levelsUnlocked = [LevelModel count];
    NSInteger quadsUnlocked = levelsUnlocked / kMISSIONS_PER_QUAD;
    if (quadsUnlocked >= self.displayedQuad) {
        self.titleSprite = [CCSprite spriteWithFile:@"select-site.png"];
    } else {
        self.titleSprite = [CCSprite spriteWithFile:@"site-locked.png"];
    }
    self.titleSprite.position = CGPointMake(self.screenCenter.x, 390.0f);
    self.titleSprite.anchorPoint = CGPointMake(0.5, 0.5);
    [self addChild:self.titleSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)backNavigation {
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)quadsUnlockedCount {
    NSInteger levelsUnlocked = [LevelModel count];
    return (levelsUnlocked -1) / kMISSIONS_PER_QUAD;
}

//===================================================================================================================================
#pragma mark QuadsScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	QuadsScene *layer = [QuadsScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if( (self=[super init] )) {
        self.isTouchEnabled = YES;
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		self.screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
        self.tharsisSprite = [[[CCSprite alloc] initWithFile:@"tharsis.png"] autorelease];
        self.tharsisSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
        CCSprite* backgroundGrid = [CCSprite spriteWithFile:@"quads-background.png"];
        backgroundGrid.anchorPoint = CGPointMake(0.0, 0.0);
        backgroundGrid.position = CGPointMake(0.0, 0.0);
        [self addChild:backgroundGrid z:-10];
        [self addQuadStats:TharsisQuadType toSprite:self.tharsisSprite];
        [self initQuads];
        [self addTitle];
        self.setTitle = NO;
        self.runningActions = 0;
        [self schedule:@selector(nextFrame:)];
        self.navigationDisplay = [NavigationDisplay createWithTarget:self andSelector:@selector(backNavigation)];
        [self.navigationDisplay insert:self];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.runningActions = [self.tharsisSprite numberOfRunningActions];
    self.runningActions += [self.elysiumSprite numberOfRunningActions];
    self.runningActions += [self.memnoniaSprite numberOfRunningActions];
	if (self.runningActions == 0) {
        if (self.setTitle) {
            [self addTitle];
            self.setTitle = NO;
        } 
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.runningActions == 0) {
        self.firstTouch = [TouchUtils locationFromTouches:touches]; 
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    if (self.runningActions == 0) {
        CGPoint touchLocation = [TouchUtils locationFromTouches:touches];
        CGPoint touchDelta = ccpSub(touchLocation, self.firstTouch);
        if (abs(touchDelta.y) < 30) {
            if ([self displayedQuadIsUnlocked]) {
                [UserModel setQuadrangle:self.displayedQuad];
                [[CCDirector sharedDirector] replaceScene:[MissionsScene scene]];
            }
        } else if (touchDelta.y < 0) {
            [self.titleSprite removeFromParentAndCleanup:YES];
            [self backwardQuads];
            self.setTitle = YES;
        } else {
            [self.titleSprite removeFromParentAndCleanup:YES];
            [self fowardQuads];
            self.setTitle = YES;
        }
    }
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
}

@end
