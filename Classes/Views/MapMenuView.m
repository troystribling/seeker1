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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapMenuView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize main;
@synthesize terminal;
@synthesize run;

//===================================================================================================================================
#pragma mark MapMenuView PrivateAPI

//===================================================================================================================================
#pragma mark MapMenuView

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect _frame = CGRectMake(0.56*screenSize.width, 0.0f, 0.44*screenSize.width, 0.23*screenSize.height);
    return [[[MapMenuView alloc] initWithFrame:_frame] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)_frame {
    self = [super initWithFrame:_frame];
    if (self) {
        self.image = [UIImage imageNamed:@"terminal-menu.png"];
        CGRect mainRect = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        self.main = [TouchImageView createWithFrame:mainRect name:@"main" andDelegate:self];
        self.terminal = [TouchImageView createWithFrame:terminalRect name:@"terminal" andDelegate:self];
        self.run = [TouchImageView createWithFrame:runRect name:@"run" andDelegate:self];
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
- (void)imageTouched:(TouchImageView*)pubSubImage {
}

@end
