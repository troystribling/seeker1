//
//  TutorialSectionViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/30/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "AudioManager.h"
#import "UserModel.h"
#import "cocos2d.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTUTORIAL_SECTION_LAUNCHER_BACK_TAG   1
#define kTUTORIAL_SECTION_LAUNCHER_EXIT_TAG   2
#define kTUTORIAL_SECTION_LAUNCHER_NEXT_TAG   3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialSectionViewController (PrivateAPI)

- (void)loadTutorial;
- (void)nextTutorial;
- (void)previousTutorial;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TutorialSectionViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize tutorialView;
@synthesize nextView;
@synthesize sectionList;
@synthesize tutorialList;
@synthesize containerView;
@synthesize selectedTutorial;

//===================================================================================================================================
#pragma mark TutorialSectionViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)loadTutorial {
    NSString* tutorialName = [self.tutorialList objectAtIndex:self.selectedTutorial];
    self.tutorialView.image = [UIImage imageNamed:tutorialName];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)nextTutorial {
    self.selectedTutorial++; 
    if (self.selectedTutorial == [self.tutorialList count]) {
        self.selectedTutorial = 0;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)previousTutorial {
    self.selectedTutorial--; 
    if (self.selectedTutorial == -1) {
        self.selectedTutorial = [self.tutorialList count] - 1;
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
+ (void)nextLevel {   
    TutorialSectionID sectionID = GettingStartedTutorialSectionID;
    switch ([UserModel level]) {
        case kLEVEL_FOR_SUBROUTINES:
            sectionID = SubroutinesTutorialSectionID;
            break;
        case kLEVEL_FOR_TIMES:
            sectionID = TimesLoopTutorialSectionID;
            break;
        case kLEVEL_FOR_UNTIL:
            sectionID = UntilLoopTutorialSectionID;
            break;
        case kLEVEL_FOR_BINS:
            sectionID = RoverBinsTutorialSectionID;
            break;
        default:
            break;
    }
    if (sectionID != GettingStartedTutorialSectionID) {
        [[ViewControllerManager instance] showTutorialIntroductionView:[[CCDirector sharedDirector] openGLView] withSectionID:sectionID];
        [UserModel tutorialWasShown:sectionID];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.sectionList = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"subroutines.png", @"list-subroutines.png", 
                                                                @"create-edit-subroutines.png", @"subroutine-names.png", nil],
                                                             [NSArray arrayWithObjects:@"times-loop.png", nil],
                                                             [NSArray arrayWithObjects:@"until-loop.png", @"predicates.png", nil],
                                                             [NSArray arrayWithObjects:@"rover-bins.png", nil], nil];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setTutorialSection:(TutorialSectionID)_sectionID {
    self.tutorialList = [self.sectionList objectAtIndex:_sectionID - 1];
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
    if ([self.tutorialList count] > 1) {
        self.nextView.hidden = NO;
    } else {
        self.nextView.hidden = YES;
    }
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
        case kTUTORIAL_SECTION_LAUNCHER_BACK_TAG:
            if (self.selectedTutorial == 0) {
                [self.view removeFromSuperview];
            } else {
                self.nextView.hidden = NO;
                [self previousTutorial];
                [self loadTutorial];
            }
            [[AudioManager instance] playEffect:SelectAudioEffectID];
            break;
        case kTUTORIAL_SECTION_LAUNCHER_EXIT_TAG:
            [[AudioManager instance] playEffect:SelectAudioEffectID];
            [self.view removeFromSuperview];
            break;
        case kTUTORIAL_SECTION_LAUNCHER_NEXT_TAG:
            [self nextTutorial];
            [self loadTutorial];
            [[AudioManager instance] playEffect:SelectAudioEffectID];
            if (self.selectedTutorial == ([self.tutorialList count] - 1)) {
                self.nextView.hidden = YES;
            } 
            break;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
}

@end
