//
//  TutorialIntroductionViewController.h
//  seeker1
//
//  Created by Troy Stribling on 2/24/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tutorialIntroductionID {
    GetStartedTutorialIntroductionID,
    SubroutinesTutorialIntroductionID,
    TimesLoopTutorialIntroductionID,
    UntilLoopTutorialIntroductionID,
    RoverBinsTutorialIntroductionID
} TutorialIntroductionID;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialIntroductionViewController : UIViewController {
    IBOutlet UILabel* featureLabel;
    IBOutlet UILabel* descriptionLabel;
    UIView* containerView;
    NSArray* featureList;
    NSArray* selectedFeatureList;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UILabel* featureLabel;
@property (nonatomic, retain) UILabel* descriptionLabel;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSArray* featureList;
@property (nonatomic, retain) NSArray* selectedFeatureList;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)setTutorialIntroduction:(TutorialIntroductionID)_introductionID;

@end
