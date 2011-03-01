//
//  BootScene.m
//  seeker1
//
//  Created by Troy Stribling on 11/14/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "BootScene.h"
#import "ViewControllerManager.h"
#import "StatusDisplay.h"
#import "MainScene.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kSTARTUP_TICKS  400
#define kBOOT_TICK_1    20
#define kBOOT_TICK_2    40
#define kBOOT_TICK_3    60
#define kBOOT_TICK_4    80
#define kBOOT_TICK_5    100
#define kBOOT_TICK_6    120
#define kBOOT_TICK_7    130
#define kBOOT_TICK_8    140
#define kBOOT_TICK_9    150
#define kBOOT_TICK_10   160
#define kBOOT_TICK_11   170
#define kBOOT_TICK_12   210
#define kBOOT_TICK_13   250
#define kBOOT_TOP_YPOS  370.0
#define kBOOT_DELTA     40.0
#define kBOOT_LOGO_YPOS 20.0
#define kBOOT_XPOS      20.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BootScene (PrivateAPI)

- (void)insertBootingLabel;
- (void)insertProductLabel;
- (void)insertPOST:(NSString*)_post;
- (void)insertConsole:(NSString*)_console;
- (void)insertConnection:(NSString*)_connection;
- (void)showGetStartedIntroduction;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BootScene

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize statusDisplay;
@synthesize bootingLabel;
@synthesize productLabel;
@synthesize post;
@synthesize console;
@synthesize connection;
@synthesize counter;

//===================================================================================================================================
#pragma mark BootScene PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertBootingLabel {
    self.bootingLabel = [CCLabel labelWithString:@"Booting" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    self.bootingLabel.position = CGPointMake(kBOOT_XPOS, kBOOT_TOP_YPOS);
    self.bootingLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.bootingLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:self.bootingLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertProductLabel {
    self.productLabel = [CCLabel labelWithString:@"imaginaryProducts.com" fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    self.productLabel.position = CGPointMake(kBOOT_XPOS, kBOOT_LOGO_YPOS);
    self.productLabel.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.productLabel.color = kCCLABEL_FONT_COLOR;
    [self addChild:self.productLabel];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertPOST:(NSString*)_post {
    self.post = [CCLabel labelWithString:_post fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    self.post.position = CGPointMake(kBOOT_XPOS, kBOOT_TOP_YPOS);
    self.post.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.post.color = kCCLABEL_FONT_COLOR;
    [self addChild:self.post];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConsole:(NSString*)_console {
    self.console = [CCLabel labelWithString:_console fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    self.console.position = CGPointMake(kBOOT_XPOS, kBOOT_TOP_YPOS - kBOOT_DELTA);
    self.console.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.console.color = kCCLABEL_FONT_COLOR;
    [self addChild:self.console];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insertConnection:(NSString*)_connection {
    self.connection = [CCLabel labelWithString:_connection fontName:kGLOBAL_FONT fontSize:kGLOBAL_FONT_SIZE];
    self.connection.position = CGPointMake(kBOOT_XPOS, kBOOT_TOP_YPOS - 2.0 * kBOOT_DELTA);
    self.connection.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.connection.color = kCCLABEL_FONT_COLOR;
    [self addChild:self.connection];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showGetStartedIntroduction {
    if (![UserModel wasTutorialShown:GettingStartedTutorialSectionID]) {
        [[ViewControllerManager instance] showTutorialIntroductionView:[[CCDirector sharedDirector] openGLView] withSectionID:GettingStartedTutorialSectionID];
        [UserModel tutorialWasShown:GettingStartedTutorialSectionID];
    }
}

//===================================================================================================================================
#pragma mark BootScene

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)scene {
	CCScene *scene = [CCScene node];
	BootScene *layer = [BootScene node];
	[scene addChild: layer];
	return scene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	if((self=[super init])) {
        self.counter = 0;
        self.isTouchEnabled = YES;
        self.statusDisplay = [StatusDisplay createWithFile:@"empty-display.png"];
        [self.statusDisplay insert:self];
        [self insertBootingLabel];
        [self insertProductLabel];
        [self schedule:@selector(nextFrame:)];
    }
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void) nextFrame:(ccTime)dt {
    self.counter++;
    if (self.counter > kSTARTUP_TICKS) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
        [self showGetStartedIntroduction];
    } else if (self.counter == kBOOT_TICK_1) {
        [self.bootingLabel setString:@"Booting."];
    } else if (self.counter == kBOOT_TICK_2) {
        [self.bootingLabel setString:@"Booting.."];
    } else if (self.counter == kBOOT_TICK_3) {
        [self.bootingLabel setString:@"Booting..."];
    } else if (self.counter == kBOOT_TICK_4) {
        [self.bootingLabel setString:@"Booting...."];
    } else if (self.counter == kBOOT_TICK_5) {
        [self.bootingLabel setString:@"Booting....."];
    } else if (self.counter == kBOOT_TICK_6) {
        [self.bootingLabel removeFromParentAndCleanup:YES];
        [self.statusDisplay setTest:LevelDisplayType];
        [self insertPOST:@"POST    [start]"];
    } else if (self.counter == kBOOT_TICK_7) {
        [self.statusDisplay setTest:SpeedDisplayType];
    } else if (self.counter == kBOOT_TICK_8) {
        [self.statusDisplay setTest:EnergyDisplayType];
    } else if (self.counter == kBOOT_TICK_9) {
        [self.statusDisplay setTest:SensorDisplayType];
    } else if (self.counter == kBOOT_TICK_10) {
        [self.statusDisplay setTest:SampleDisplayType];
    } else if (self.counter == kBOOT_TICK_11) {
        [self.statusDisplay clear];
        [self.post removeFromParentAndCleanup:YES];
        [self insertPOST:@"POST    [OK]"];
        [self insertConsole:@"console [start]"];
    } else if (self.counter == kBOOT_TICK_12) {
        [self.statusDisplay test];
        [self.console removeFromParentAndCleanup:YES];
        [self insertConsole:@"console [started]"];
        [self insertConnection:@"connecting"];
    } else if (self.counter == kBOOT_TICK_13) {
        [self.statusDisplay clear];
        [self.connection removeFromParentAndCleanup:YES];
        [self insertConnection:@"connected"];
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    [self showGetStartedIntroduction];
}    

@end
