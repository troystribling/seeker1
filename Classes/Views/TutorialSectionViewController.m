    //
//  TutorialSectionViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/30/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TutorialSectionViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTUTORIAL_SECTION_LAUNCHER_BACK_TAG   1
#define kTUTORIAL_SECTION_LAUNCHER_EXIT_TAG   2
#define kTUTORIAL_SECTION_LAUNCHER_NEXT_TAG   3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialSectionViewController (PrivateAPI)

- (void)loadTutorial;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TutorialSectionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize tutorialView;
@synthesize nextView;
@synthesize tutorialList;
@synthesize containerView;
@synthesize selectedTutorial;

//===================================================================================================================================
#pragma mark TutorialSectionViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadTutorial {
    NSString* tutorialName = [self.tutorialList objectAtIndex:self.selectedTutorial];
    self.tutorialView.image = [UIImage imageNamed:tutorialName];
    self.selectedTutorial++; 
    if (self.selectedTutorial == [self.tutorialList count]) {
        self.selectedTutorial = 0;
    }
}

//===================================================================================================================================
#pragma mark TutorialSectionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    TutorialSectionViewController* viewController = 
        [[TutorialSectionViewController alloc] initWithNibName:@"TutorialSectionViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.tutorialList = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.selectedTutorial = 0;
    [self loadTutorial];
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
    self.nextView.hidden = NO;
    switch (touchTag) {
        case kTUTORIAL_SECTION_LAUNCHER_BACK_TAG:
            if (self.selectedTutorial == 1) {
                [self.view removeFromSuperview];
            } else if (self.selectedTutorial == 0) { 
                self.selectedTutorial = [self.tutorialList count] - 2;
                [self loadTutorial];
            } else {
                self.selectedTutorial -= 2;
                [self loadTutorial];
            }
            break;
        case kTUTORIAL_SECTION_LAUNCHER_EXIT_TAG:
            [self.view removeFromSuperview];
            break;
        case kTUTORIAL_SECTION_LAUNCHER_NEXT_TAG:
            [self loadTutorial];
            if (self.selectedTutorial == 0) {
                self.nextView.hidden = YES;
            }
            break;
        default:
            break;
    }
}

@end
