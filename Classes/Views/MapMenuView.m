//
//  MapMenuView.m
//  seeker1
//
//  Created by Troy Stribling on 12/3/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapMenuView.h"
#import "cocos2d.h"
#import "MainScene.h"
#import "MapScene.h"
#import "SeekerSprite.h"
#import "TouchImageView.h"
#import "ProgramNgin.h"
#import "TerminalViewController.h"
#import "ViewControllerManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapMenuView (PrivateAPI)

- (void)createMainItem:(CGRect)_rect;
- (void)createTermItem:(CGRect)_rect;
- (void)createRunItem:(CGRect)_rect;
- (void)createResetItem:(CGRect)_rect;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize mainItem;
@synthesize termItem;
@synthesize runItem;
@synthesize resetItem;
@synthesize mapScene;
@synthesize firstRect;
@synthesize secondRect;
@synthesize thirdRect;

//===================================================================================================================================
#pragma mark MapMenuView PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createMainItem:(CGRect)_rect {
    self.mainItem = [TouchImageView createWithFrame:_rect name:@"main" andDelegate:self];
    self.mainItem.image = [UIImage imageNamed:@"menu-main.png"];
    self.mainItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.mainItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createTermItem:(CGRect)_rect {
    self.termItem = [TouchImageView createWithFrame:_rect name:@"term" andDelegate:self];
    self.termItem.image = [UIImage imageNamed:@"menu-term.png"];
    self.termItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.termItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createRunItem:(CGRect)_rect {
    self.runItem = [TouchImageView createWithFrame:_rect name:@"run" andDelegate:self];
    self.runItem.image = [UIImage imageNamed:@"menu-run.png"];
    self.runItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.runItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createResetItem:(CGRect)_rect {
    self.resetItem = [TouchImageView createWithFrame:_rect name:@"reset" andDelegate:self];
    self.resetItem.image = [UIImage imageNamed:@"menu-reset.png"];
    self.resetItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.resetItem];
}

//===================================================================================================================================
#pragma mark MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect _frame = CGRectMake(0.5*screenSize.width, 0.0f, 0.5*screenSize.width, 0.25*screenSize.height);
    return [[[MapMenuView alloc] initWithFrame:_frame] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame {
    self = [super initWithFrame:_frame];
    if (self) {
        self.image = [UIImage imageNamed:@"terminal-menu.png"];
        self.contentMode = UIViewContentModeScaleToFill;
        self.userInteractionEnabled = YES;
        CGSize itemSize = CGSizeMake(0.76*_frame.size.width,  0.24*_frame.size.height);
        CGFloat yOffset = _frame.size.height - 3.0*itemSize.height - 0.13*_frame.size.height;
        CGFloat xOffset = 0.05*_frame.size.width;
        self.firstRect = CGRectMake(xOffset, yOffset+2.0*itemSize.height, itemSize.width,  itemSize.height);
        self.secondRect = CGRectMake(xOffset, yOffset+itemSize.height, itemSize.width,  itemSize.height);
        self.thirdRect = CGRectMake(xOffset, yOffset, itemSize.width,  itemSize.height);
        [self initItems];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initItems {
    [self.runItem removeFromSuperview];
    [self.mainItem removeFromSuperview];
    [self.termItem removeFromSuperview];
    [self createTermItem:self.secondRect];
    [self createMainItem:self.thirdRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addResetItems {
    [self.runItem removeFromSuperview];
    [self.mainItem removeFromSuperview];
    [self.termItem removeFromSuperview];
    [self createResetItem:self.firstRect];
    [self createTermItem:self.secondRect];
    [self createMainItem:self.thirdRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addRunItems {
    [self.resetItem removeFromSuperview];
    [self.mainItem removeFromSuperview];
    [self.termItem removeFromSuperview];
    [self createRunItem:self.firstRect];
    [self createTermItem:self.secondRect];
    [self createMainItem:self.thirdRect];
}

//===================================================================================================================================
#pragma mark TouchImageViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)_menuItem {
    NSString* itemName = _menuItem.viewName;
    [self removeFromSuperview];
    if ([itemName isEqualToString:@"term"]) {
        TerminalViewController* viewController = [[ViewControllerManager instance] showTerminalView:[[CCDirector sharedDirector] openGLView]];
        viewController.mapScene = self.mapScene;
    } else if ([itemName isEqualToString:@"main"]) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    } else if ([itemName isEqualToString:@"run"]) {
        [[ProgramNgin instance] runProgram];
        [self.mapScene addResetTerminalItems];
        [self addResetItems];
    } else if ([itemName isEqualToString:@"reset"]) {
        [[ProgramNgin instance] stopProgram];
        [self.mapScene resetLevel];
        [self.mapScene addRunTerminalItems];
        [self addRunItems];
    }
}

@end
