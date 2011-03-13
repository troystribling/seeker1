//
//  SettingsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 3/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SettingsViewController : UIViewController {
    IBOutlet UISlider* speedSlider;
    IBOutlet UIButton* audioButton;
    IBOutlet UIButton* resetLevelsButton;
    IBOutlet UIButton* enableLevelsButton;
    UIView* containerView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UISlider* speedSlider;
@property (nonatomic, retain) UIButton* audioButton;
@property (nonatomic, retain) UIButton* resetLevelsButton;
@property (nonatomic, retain) UIButton* enableLevelsButton;
@property (nonatomic, retain) UIView* containerView;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (IBAction)speedValueChanged:(id)sender; 
- (IBAction)audioButtonPushed:(id)sender; 
- (IBAction)resetButtonPushed:(id)sender; 
- (IBAction)enableButtonPushed:(id)sender; 

@end
