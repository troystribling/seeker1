//
//  TermMenuView.m
//  seeker1
//
//  Created by Troy Stribling on 12/3/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TermMenuView.h"
#import "UserModel.h"
#import "ProgramModel.h"
#import "cocos2d.h"
#import "MainScene.h"
#import "MapScene.h"
#import "QuadsScene.h"
#import "SeekerSprite.h"
#import "TouchImageView.h"
#import "ProgramNgin.h"
#import "TerminalViewController.h"
#import "ViewControllerManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TermMenuView (PrivateAPI)

- (void)createMainItem:(CGRect)_rect;
- (void)createTermItem:(CGRect)_rect;
- (void)createRunItem:(CGRect)_rect;
- (void)createResetItem:(CGRect)_rect;
- (void)createSiteItem:(CGRect)_rect;
- (void)createEmptyItem:(CGRect)_rect;
- (void)removeMenuItems;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TermMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize mainItem;
@synthesize termItem;
@synthesize runItem;
@synthesize rsetItem;
@synthesize siteItem;
@synthesize emptyItem;
@synthesize firstRect;
@synthesize secondRect;
@synthesize thirdRect;
@synthesize activateRect;
@synthesize menuIsOpen;
@synthesize mapScene;

//===================================================================================================================================
#pragma mark TermMenuView PrivateAPI

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
    self.rsetItem = [TouchImageView createWithFrame:_rect name:@"rset" andDelegate:self];
    self.rsetItem.image = [UIImage imageNamed:@"menu-rset.png"];
    self.rsetItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.rsetItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSiteItem:(CGRect)_rect {
    self.siteItem = [TouchImageView createWithFrame:_rect name:@"site" andDelegate:self];
    self.siteItem.image = [UIImage imageNamed:@"menu-site.png"];
    self.siteItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.siteItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createEmptyItem:(CGRect)_rect {
    self.emptyItem = [[[UIImageView alloc] initWithFrame:_rect] autorelease];
    self.emptyItem.image = [UIImage imageNamed:@"menu-empty.png"];
    self.emptyItem.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.emptyItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeMenuItems {
    [self.runItem removeFromSuperview];
    [self.rsetItem removeFromSuperview];
    [self.mainItem removeFromSuperview];
    [self.termItem removeFromSuperview];
    [self.siteItem removeFromSuperview];
    [self.emptyItem removeFromSuperview];
}

//===================================================================================================================================
#pragma mark TermMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect _frame = CGRectMake(0.5*screenSize.width, 0.0f, 0.5*screenSize.width, 0.25*screenSize.height);
    return [[[TermMenuView alloc] initWithFrame:_frame] autorelease];
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
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.activateRect = CGRectMake(0.75*screenSize.width, 0.88*screenSize.height, 0.21*screenSize.width, 0.1*screenSize.height);
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isInMenuRect:(CGPoint)_point {
    BOOL isInRect = NO;
    CGFloat xDelta = _point.x - self.activateRect.origin.x;
    CGFloat yDelta = _point.y - self.activateRect.origin.y;
    if (xDelta < self.activateRect.size.width && yDelta < self.activateRect.size.height && xDelta > 0 && yDelta > 0) {
        isInRect = YES;
    }
    return isInRect;    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showMenu {
    self.menuIsOpen = YES;
    [[[CCDirector sharedDirector] openGLView] addSubview:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)hideMenu {
    self.menuIsOpen = NO;
    [self removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)mapInitItems {
    [self removeMenuItems];
    [self createMainItem:self.thirdRect];
    [self createTermItem:self.secondRect];
    [self createEmptyItem:self.firstRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)quadsInitItems {
    [self removeMenuItems];
    [self createMainItem:self.thirdRect];
    [self createEmptyItem:self.secondRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)missionsInitItems {
    [self removeMenuItems];
    [self createMainItem:self.thirdRect];
    [self createSiteItem:self.secondRect];
    [self createEmptyItem:self.firstRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addResetItems {
    [self removeMenuItems];
    [self createMainItem:self.thirdRect];
    [self createTermItem:self.secondRect];
    [self createResetItem:self.firstRect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addRunItems {
    [self removeMenuItems];
    [self createMainItem:self.thirdRect];
    [self createTermItem:self.secondRect];
    [self createRunItem:self.firstRect];
}

//===================================================================================================================================
#pragma mark TouchImageViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)_menuItem {
    NSString* itemName = _menuItem.viewName;
    ProgramNgin* ngin = [ProgramNgin instance];
    [self removeFromSuperview];
    if ([itemName isEqualToString:@"term"]) {
        [[ViewControllerManager instance] showTerminalView:[[CCDirector sharedDirector] openGLView] launchedFromMap:YES];
    } else if ([itemName isEqualToString:@"main"]) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    } else if ([itemName isEqualToString:@"site"]) {
        [[CCDirector sharedDirector] replaceScene: [QuadsScene scene]];
    } else if ([itemName isEqualToString:@"run"]) {
        ProgramModel* model = [ProgramModel findByLevel:[UserModel level]];
        [ngin loadProgram:[model codeListingToInstrictions]];
        [ngin runProgram];
    } else if ([itemName isEqualToString:@"rset"]) {
        [ngin stopProgram];
        [self.mapScene resetLevel];
        [self.mapScene addRunTerminalItems];
        [self addRunItems];
    }
}

@end
