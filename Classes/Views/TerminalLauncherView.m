//
//  TerminalLauncherView.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TerminalLauncherView.h"
#import "ProgramNgin.h"
#import "TouchImageView.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class MapScene;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalLauncherView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalLauncherView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize editItem;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view andDelegate:(id<LauncherViewDelegate>)_delegate {
    return [[TerminalLauncherView alloc] initInView:_view andDelegate:_delegate];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initInView:(UIView*)_view andDelegate:(id<LauncherViewDelegate>)_delegate {
    CGFloat viewWidth =  _view.frame.size.width;
    CGFloat viewHeight = 0.14*_view.frame.size.height;
    CGRect viewFrame = CGRectMake(0.0, 0.0, viewWidth, viewHeight);
    if ((self = [self initWithFrame:viewFrame image:@"terminal-launcher.png" andDelegate:_delegate])) {
        self.containedView = _view;
        CGRect backRect = CGRectMake(0.0, 0.15*viewHeight, 0.39*viewWidth, 0.61*viewHeight);
        TouchImageView* backItem = [TouchImageView createWithFrame:backRect name:@"back" andDelegate:self];
        backItem.image = [UIImage imageNamed:@"terminal-launcher-back.png"];
        [self addSubview:backItem];
        if (![[ProgramNgin instance] programIsHalted] && ![[ProgramNgin instance] programIsRunning]) {
            CGRect runRect = CGRectMake(0.375*viewWidth, 0.15*viewHeight, 0.25*viewWidth, 0.61*viewHeight);
            TouchImageView* runItem = [TouchImageView createWithFrame:runRect name:@"run" andDelegate:self];
            runItem.image = [UIImage imageNamed:@"terminal-launcher-run.png"];
            [self addSubview:runItem];
        }
        CGRect editRect = CGRectMake(0.69*viewWidth, 0.15*viewHeight, 0.31*viewWidth, 0.61*viewHeight);
        self.editItem = [TouchImageView createWithFrame:editRect name:@"edit" andDelegate:self];
        self.editItem.image = [UIImage imageNamed:@"terminal-launcher-edit.png"];
        [self addSubview:editItem];
        [_view addSubview:self];
    }
    return self;
}

//===================================================================================================================================
#pragma mark TouchImageViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)imageTouched:(TouchImageView*)_touchedView {
    [self.delegate viewTouchedNamed:_touchedView.viewName];
}

@end
