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
    TouchImageView* missItem;
    CGRect firstRect;
    CGRect secondRect;
    CGRect thirdRect;
    MapScene* mapScene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TouchImageView* runItem;
@property (nonatomic, retain) TouchImageView* resetItem;
@property (nonatomic, retain) TouchImageView* mainItem;
@property (nonatomic, retain) TouchImageView* termItem;
@property (nonatomic, retain) TouchImageView* missItem;
@property (nonatomic, retain) MapScene* mapScene;
@property (nonatomic, assign) CGRect firstRect;
@property (nonatomic, assign) CGRect secondRect;
@property (nonatomic, assign) CGRect thirdRect;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)mapInitItems;
- (void)quadsInitItems;
- (void)missionsInitItems;
- (void)addResetItems;
- (void)addRunItems;

@end
