//
//  TermMenuView.h
//  seeker1
//
//  Created by Troy Stribling on 12/3/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TouchImageView;
@class MapScene;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TermMenuView : UIImageView {
    TouchImageView* runItem;
    TouchImageView* resetItem;
    TouchImageView* mainItem;
    TouchImageView* termItem;
    TouchImageView* siteItem;
    UIImageView* emptyItem;
    CGRect firstRect;
    CGRect secondRect;
    CGRect thirdRect;
    CGRect activateRect;
    BOOL menuIsOpen;
    MapScene* mapScene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TouchImageView* runItem;
@property (nonatomic, retain) TouchImageView* resetItem;
@property (nonatomic, retain) TouchImageView* mainItem;
@property (nonatomic, retain) TouchImageView* termItem;
@property (nonatomic, retain) TouchImageView* siteItem;
@property (nonatomic, retain) UIImageView* emptyItem;
@property (nonatomic, retain) MapScene* mapScene;
@property (nonatomic, assign) CGRect firstRect;
@property (nonatomic, assign) CGRect secondRect;
@property (nonatomic, assign) CGRect thirdRect;
@property (nonatomic, assign) CGRect activateRect;
@property (nonatomic, assign) BOOL menuIsOpen;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (BOOL)isInMenuRect:(CGPoint)_point;
- (void)showMenu;
- (void)hideMenu;
- (void)mapInitItems;
- (void)quadsInitItems;
- (void)missionsInitItems;
- (void)addResetItems;
- (void)addRunItems;

@end
