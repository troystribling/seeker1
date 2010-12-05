//
//  MapMenuView.m
//  seeker1
//
//  Created by Troy Stribling on 12/3/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "MapMenuView.h"
#import "MainScene.h"
#import "TouchImageView.h"
#import "cocos2d.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapMenuView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------

//===================================================================================================================================
#pragma mark MapMenuView PrivateAPI

//===================================================================================================================================
#pragma mark MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect _frame = CGRectMake(0.56*screenSize.width, 0.0f, 0.44*screenSize.width, 0.21*screenSize.height);
    return [[[MapMenuView alloc] initWithFrame:_frame] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame {
    self = [super initWithFrame:_frame];
    if (self) {
        self.image = [UIImage imageNamed:@"terminal-menu.png"];
        self.contentMode = UIViewContentModeScaleToFill;
        self.userInteractionEnabled = YES;
        CGSize itemSize = CGSizeMake(0.71*_frame.size.width,  0.23*_frame.size.height);
        CGFloat yOffset = _frame.size.height - 3.0*itemSize.height - 0.15*_frame.size.height;
        CGFloat xOffset = 0.05*_frame.size.width;
        CGRect mainRect = CGRectMake(xOffset, yOffset, itemSize.width,  itemSize.height);
        TouchImageView* mainItem = [TouchImageView createWithFrame:mainRect name:@"main" andDelegate:self];
        mainItem.image = [UIImage imageNamed:@"menu-main.png"];
        mainItem.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:mainItem];
        CGRect terminalRect = CGRectMake(xOffset, yOffset+itemSize.height, itemSize.width,  itemSize.height);
        TouchImageView* terminalItem = [TouchImageView createWithFrame:terminalRect name:@"terminal" andDelegate:self];
        terminalItem.image = [UIImage imageNamed:@"menu-term.png"];
        terminalItem.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:terminalItem];
        CGRect runRect = CGRectMake(xOffset, yOffset+2.0*itemSize.height, itemSize.width,  itemSize.height);
        TouchImageView* runItem = [TouchImageView createWithFrame:runRect name:@"run" andDelegate:self];
        runItem.image = [UIImage imageNamed:@"menu-run.png"];
        runItem.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:runItem];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//===================================================================================================================================
#pragma mark TouchImageViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)_menuItem {
    NSString* itemName = _menuItem.viewName;
    [self removeFromSuperview];
    if ([itemName isEqualToString:@"term"]) {
    } else if ([itemName isEqualToString:@"main"]) {
        [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
    } else if ([itemName isEqualToString:@"run"]) {
    }
}

@end
