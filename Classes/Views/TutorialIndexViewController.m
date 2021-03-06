//
//  TutorialIndexViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/29/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "cocos2d.h"
#import "CellUtils.h"
#import "TutorialIndexCell.h"
#import "TutorialIndexViewController.h"
#import "UserModel.h"
#import "IntroMap1Scene.h"
#import "AudioManager.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTUTORIAL_INDEX_LAUNCHER_BACK_TAG   1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialIndexViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TutorialIndexViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize tutorialsView;
@synthesize containerView;
@synthesize tutorialsList;

//===================================================================================================================================
#pragma mark TutorialIndexViewController PrivateAPI

//===================================================================================================================================
#pragma mark TutorialIndexViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    TutorialIndexViewController* viewController = 
        [[TutorialIndexViewController alloc] initWithNibName:@"TutorialIndexViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.tutorialsView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.tutorialsList = [NSMutableArray arrayWithObjects:@"1. get started", nil];
    NSInteger level = [UserModel level];
    if (level >= kLEVEL_FOR_SUBROUTINES) {
        [self.tutorialsList addObject: @"2. subroutines"];
    }
    if (level >= kLEVEL_FOR_TIMES) {
        [self.tutorialsList addObject:@"3. times loop"];
    }
    if (level >= kLEVEL_FOR_UNTIL) {
        [self.tutorialsList addObject: @"4. until loop"];
    }
    if (level >= kLEVEL_FOR_BINS) {
        [self.tutorialsList addObject: @"5. rover bins"];
    }
    [self.tutorialsView reloadData];
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
        case kTUTORIAL_INDEX_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            [[AudioManager instance] playEffect:SelectAudioEffectID];
            [[AudioManager instance] playBackgroundMusic:BootAudioBackgroundID];
            break;
        default:
            break;
    }
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tutorialsList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TutorialIndexCell* cell = (TutorialIndexCell*)[CellUtils createCell:[TutorialIndexCell class] forTableView:tableView];
    cell.tutorialLabel.text = [self.tutorialsList objectAtIndex:indexPath.row];
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewControllerManager * viewMgr = [ViewControllerManager instance];
    [[AudioManager instance] playEffect:SelectAudioEffectID];
    [self.view removeFromSuperview];
    switch (indexPath.row) {
        case 0:
            [[CCDirector sharedDirector] replaceScene:[IntroMap1Scene scene]];
            break;
        case 1:
            [viewMgr showTutorialSectionView:[[CCDirector sharedDirector] openGLView] withSectionID:SubroutinesTutorialSectionID];
            break;
        case 2:
            [viewMgr showTutorialSectionView:[[CCDirector sharedDirector] openGLView] withSectionID:TimesLoopTutorialSectionID];
            break;
        case 3:
            [viewMgr showTutorialSectionView:[[CCDirector sharedDirector] openGLView] withSectionID:UntilLoopTutorialSectionID];
            break;
        case 4:
            [viewMgr showTutorialSectionView:[[CCDirector sharedDirector] openGLView] withSectionID:RoverBinsTutorialSectionID];
            break;
        default:
            break;
    }    
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kTERMINAL_DEFAULT_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark NSObject

@end
