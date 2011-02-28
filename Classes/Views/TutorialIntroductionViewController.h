//
//  TutorialIntroductionViewController.h
//  seeker1
//
//  Created by Troy Stribling on 2/24/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialIntroductionViewController : UIViewController {
    IBOutlet UIImageView* selectedFeature;
    UIView* containerView;
    NSArray* featureList;
    TutorialSectionID sectionID;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIImageView* selectedFeature;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSArray* featureList;
@property (nonatomic, assign) TutorialSectionID sectionID;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)setTutorialIntroduction:(TutorialSectionID)_sectionID;

@end
