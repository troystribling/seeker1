//
//  MapMenuView.h
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
@interface MapMenuView : UIImageView {
    TouchImageView* runItem;
    TouchImageView* stopItem;
    MapScene* mapScene;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TouchImageView* runItem;
@property (nonatomic, retain) TouchImageView* stopItem;
@property (nonatomic, retain) MapScene* mapScene;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)addStop;
- (void)addRun;

@end
