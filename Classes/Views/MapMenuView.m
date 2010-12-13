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
#import "TouchImageView.h"
#import "ProgramNgin.h"
#import "ViewControllerManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapMenuView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize runItem;
@synthesize stopItem;

//===================================================================================================================================
#pragma mark MapMenuView PrivateAPI

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
        CGRect mainRect = CGRectMake(xOffset, yOffset+itemSize.height, itemSize.width,  itemSize.height);
        TouchImageView* mainItem = [TouchImageView createWithFrame:mainRect name:@"main" andDelegate:self];
        mainItem.image = [UIImage imageNamed:@"menu-main.png"];
        mainItem.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:mainItem];
        CGRect terminalRect = CGRectMake(xOffset, yOffset+2.0*itemSize.height, itemSize.width,  itemSize.height);
        TouchImageView* terminalItem = [TouchImageView createWithFrame:terminalRect name:@"term" andDelegate:self];
        terminalItem.image = [UIImage imageNamed:@"menu-term.png"];
        terminalItem.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:terminalItem];
        CGRect programControlRect = CGRectMake(xOffset, yOffset, itemSize.width,  itemSize.height);
        self.runItem = [TouchImageView createWithFrame:programControlRect name:@"run" andDelegate:self];
        self.runItem.image = [UIImage imageNamed:@"menu-run.png"];
        self.runItem.contentMode = UIViewContentModeScaleToFill;
        self.stopItem = [TouchImageView createWithFrame:programControlRect name:@"stop" andDelegate:self];
        self.stopItem.image = [UIImage imageNamed:@"menu-stop.png"];
        self.stopItem.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addStop {
    [self.runItem removeFromSuperview];
    [self addSubview:self.stopItem];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)addRun {
    [self.stopItem removeFromSuperview];
    [self addSubview:self.runItem];
}

//===================================================================================================================================
#pragma mark TouchImageViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)_menuItem {
    NSString* itemName = _menuItem.viewName;
    [self removeFromSuperview];
    if ([itemName isEqualToString:@"term"]) {
        [[ViewControllerManager instance] showTerminalView:[[CCDirector sharedDirector] openGLView]];
    } else if ([itemName isEqualToString:@"main"]) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    } else if ([itemName isEqualToString:@"run"]) {
        [[ProgramNgin instance] runProgram];
    } else if ([itemName isEqualToString:@"stop"]) {
        [[ProgramNgin instance] stopProgram];
    }
}

@end
