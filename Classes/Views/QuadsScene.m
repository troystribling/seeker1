//
//  QuadsScene.m
//  seeker1
//
//  Created by Troy Stribling on 12/23/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "QuadsScene.h"
#import "StatusDisplay.h"
#import "TouchUtils.h"
#import "LevelModel.h"
#import "MissionsScene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kQUAD_IMAGE_YDELTA  75.0f

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QuadsScene (PrivateAPI)

- (void)initQuads;
- (BOOL)displayedQuadIsUnlocked;
- (void)fowardQuads;
- (void)backwardQuads;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QuadsScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize tharsisSprite;
@synthesize memnoniaSprite;
@synthesize elysiumSprite;
@synthesize displayedQuad;
@synthesize screenCenter;
@synthesize firstTouch;

//===================================================================================================================================
#pragma mark QuadsScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initQuads {
    
    NSInteger levelsUnlocked = [LevelModel count];
    NSInteger quadsUnlocked = levelsUnlocked / kMISSIONS_PER_QUAD;
    
    self.displayedQuad = TharsisQuadType;
    self.tharsisSprite.position = self.screenCenter;
    [self addChild:self.tharsisSprite];

    if (quadsUnlocked >= 1) {
        self.memnoniaSprite = [[[CCSprite alloc] initWithFile:@"memnonia.png"] autorelease];
    } else {
        self.memnoniaSprite = [[[CCSprite alloc] initWithFile:@"memnonia-locked.png"] autorelease];
    }
    if (quadsUnlocked >= 2) {
        self.tharsisSprite = [[[CCSprite alloc] initWithFile:@"tharsis.png"] autorelease];
    } else {
        self.tharsisSprite = [[[CCSprite alloc] initWithFile:@"tharsis-locked.png"] autorelease];
    }    
    self.memnoniaSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.tharsisSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    CGSize tharsisSize = self.tharsisSprite.contentSize;
    CGPoint nextPosition = CGPointMake(self.screenCenter.x, self.screenCenter.y - tharsisSize.height - kQUAD_IMAGE_YDELTA);
    self.memnoniaSprite.position = nextPosition;
    [self addChild:self.memnoniaSprite];

    CGSize memnoniaSize = self.memnoniaSprite.contentSize;
    nextPosition = CGPointMake(self.screenCenter.x, self.screenCenter.y - tharsisSize.height - memnoniaSize.height - 2*kQUAD_IMAGE_YDELTA);
    self.elysiumSprite.position = nextPosition;
    [self addChild:self.elysiumSprite];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)displayedQuadIsUnlocked {
    NSInteger levelsUnlocked = [LevelModel count];
    NSInteger quadsUnlocked = levelsUnlocked / kMISSIONS_PER_QUAD;
    if (self.displayedQuad <= quadsUnlocked) {
        return YES;
    } else {
        return NO;
    }

}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)fowardQuads {
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)backwardQuads {
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
        self.elysiumSprite = [[[CCSprite alloc] initWithFile:@"elysium.png"] autorelease];
        self.elysiumSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.statusDisplay = [StatusDisplay create];
        [self.statusDisplay insert:self];
        [self.statusDisplay addTerminalText:@"$ main"];
        [self.statusDisplay test];
        [self initQuads];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
	self.firstTouch = [TouchUtils locationFromTouches:touches]; 
}    

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
	CGPoint touchLocation = [TouchUtils locationFromTouches:touches];
    CGPoint touchDelta = ccpSub(self.firstTouch, touchLocation);
    if (touchDelta.y == 0) {
        if ([self displayedQuadIsUnlocked]) {
            [[CCDirector sharedDirector] replaceScene: [MissionsScene scene]];
        }
    } else if (touchDelta.y > 0) {
        [self backwardQuads];
    } else {
        [self fowardQuads];
    }
}    

@end
