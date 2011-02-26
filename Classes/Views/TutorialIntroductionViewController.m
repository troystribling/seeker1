//
//  TutorialIntroductionViewController.m
//  seeker1
//
//  Created by Troy Stribling on 2/24/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kFEATURE_UNLOCK_LAUNCHER_DONE_TAG       1
#define kFEATURE_UNLOCK_LAUNCHER_TUTORIAL_TAG   2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialIntroductionViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TutorialIntroductionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize featureLabel;
@synthesize descriptionLabel;
@synthesize containerView;
@synthesize featureList;
@synthesize selectedFeatureList;

//===================================================================================================================================
#pragma mark TutorialIntroductionViewController PrivateAPI

//===================================================================================================================================
#pragma mark TutorialSectionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    TutorialIntroductionViewController* viewController = 
        [[TutorialIntroductionViewController alloc] initWithNibName:@"TutorialIntroductionViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.featureList = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"get started", 
                                                                @"with a brief introduction", 
                                                                [NSNumber numberWithInt:GettingStartedTutorialSectionID], nil],
                                                            [NSArray arrayWithObjects:@"subroutines unlocked", 
                                                                @"with subroutines code can be reused and programs shortened", 
                                                                [NSNumber numberWithInt:SubroutinesTutorialSectionID], nil],
                                                            [NSArray arrayWithObjects:@"times loop unlocked", 
                                                                @"with a times loop instructions and subroutines can be executed multiple times", 
                                                                [NSNumber numberWithInt:TimesLoopTutorialSectionID], nil],
                                                            [NSArray arrayWithObjects:@"until loop unlocked", 
                                                                @"with an until loop instructions and subroutines can be executed until a condition is satisfied", 
                                                                [NSNumber numberWithInt:UntilLoopTutorialSectionID], nil],
                                                            [NSArray arrayWithObjects:@"rover bin predicates unlocked", 
                                                                @"with the rover bin predicates instructions and subroutines can be executed until the sample bin is full or the sensor bin is empty", 
                                                                [NSNumber numberWithInt:RoverBinsTutorialSectionID], nil], nil];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTutorialIntroduction:(TutorialIntroductionID)_introductionID {
    self.selectedFeatureList = [self.featureList objectAtIndex:_introductionID];
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.featureLabel.text = [self.selectedFeatureList objectAtIndex:0];
    self.descriptionLabel.text = [self.selectedFeatureList objectAtIndex:1];
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
        case kFEATURE_UNLOCK_LAUNCHER_DONE_TAG:
            break;
        case kFEATURE_UNLOCK_LAUNCHER_TUTORIAL_TAG:
            ;TutorialSectionID sectionID = [[self.selectedFeatureList objectAtIndex:2] intValue];
            [[ViewControllerManager instance] showTutorialSectionView:[[CCDirector sharedDirector] openGLView] withSectionID:sectionID];
            break;
        default:
            break;
    }
    [self.view removeFromSuperview];
}

@end
