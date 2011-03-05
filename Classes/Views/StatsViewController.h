//
//  StatsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 3/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StatsViewController : UIViewController {
    IBOutlet UILabel* totalScoreLabel;
    IBOutlet UILabel* totalLevelsLabel;
    IBOutlet UILabel* totalCodeScoreLabel;
    IBOutlet UILabel* progressLabel;
    IBOutlet UILabel* performanceLabel;
    IBOutlet UILabel* expertiseLabel;
    UIView* containerView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* totalScoreLabel;
@property (nonatomic, retain) UILabel* totalLevelsLabel;
@property (nonatomic, retain) UILabel* totalCodeScoreLabel;
@property (nonatomic, retain) UILabel* progressLabel;
@property (nonatomic, retain) UILabel* performanceLabel;
@property (nonatomic, retain) UILabel* expertiseLabel;
@property (nonatomic, retain) UIView* containerView;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
