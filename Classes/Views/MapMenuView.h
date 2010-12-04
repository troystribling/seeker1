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
    TouchImageView* main;
    TouchImageView* terminal;
    TouchImageView* run;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) TouchImageView* main;
@property (nonatomic, assign) TouchImageView* terminal;
@property (nonatomic, assign) TouchImageView* run;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)create;

@end
