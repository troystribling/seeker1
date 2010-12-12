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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MapMenuView : UIImageView {
    TouchImageView* runItem;
    TouchImageView* stopItem;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TouchImageView* runItem;
@property (nonatomic, retain) TouchImageView* stopItem;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;
- (void)addStop;
- (void)addRun;

@end
