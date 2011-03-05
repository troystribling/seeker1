//
//  SettingsViewController.m
//  seeker1
//
//  Created by Troy Stribling on 3/3/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "SettingsViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kSETTINGS_LAUNCHER_BACK_TAG     1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SettingsViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SettingsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize speedSlider;
@synthesize soundSwitch;
@synthesize resetLevelsButton;
@synthesize enableLevelsButton;
@synthesize containerView;

//===================================================================================================================================
#pragma mark SettingsViewController PrivateAPI

//===================================================================================================================================
#pragma mark SettingsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    SettingsViewController* viewController = 
        [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        UIImage* stetchLeftTrack = [[UIImage imageNamed:@"slider-left.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        UIImage* stetchRightTrack = [[UIImage imageNamed:@"slider-right.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        [self.speedSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [self.speedSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)speedValueChanged:(UISlider*)sender {  
    CGFloat speedValue = [sender value];
    CGFloat newSpeed = kSEEKER_MIN_SPEED_SETTING + kSEEKER_DELTA_SPEED_SETTING * speedValue; 
}  

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)soundValueChanged:(UISwitch*)sender {  
}  

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)resetButtonPushed:(UIButton*)sender {  
}  

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)enableButtonPushed:(UIButton*)sender {  
}  

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    NSInteger touchTag = touch.view.tag;
    switch (touchTag) {
        case kSETTINGS_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
