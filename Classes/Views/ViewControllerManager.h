//
//  ViewControllerManager.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "InstructionsViewController.h"
#import "TerminalViewController.h"
#import "DoTimesEditViewController.h"
#import "CreateSubroutineViewController.h"
#import "SubroutineViewController.h"
#import "RepositoryViewController.h"
#import "TutorialIndexViewController.h"
#import "TutorialSectionViewController.h"
#import "TutorialIntroductionViewController.h"
#import "StatsViewController.h"
#import "SettingsViewController.h"
 
//-----------------------------------------------------------------------------------------------------------------------------------
@class DoTimesTerminalCell;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
    InstructionsViewController* instructionsViewController;
    DoTimesEditViewController* doTimesEditViewController;
    CreateSubroutineViewController* createSubroutineViewController;
    SubroutineViewController* subroutineViewController;
    RepositoryViewController* repositoryViewController;
    TutorialIndexViewController* tutorialIndexViewController;
    TutorialSectionViewController* tutorialSectionViewController;
    TutorialIntroductionViewController *tutorialIntroductionViewController;
    StatsViewController* statsViewController;
    SettingsViewController* settingsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;
@property (nonatomic, retain) InstructionsViewController* instructionsViewController;
@property (nonatomic, retain) DoTimesEditViewController* doTimesEditViewController;
@property (nonatomic, retain) CreateSubroutineViewController* createSubroutineViewController;
@property (nonatomic, retain) SubroutineViewController* subroutineViewController;
@property (nonatomic, retain) RepositoryViewController* repositoryViewController;
@property (nonatomic, retain) TutorialIndexViewController* tutorialIndexViewController;
@property (nonatomic, retain) TutorialSectionViewController* tutorialSectionViewController;
@property (nonatomic, retain) TutorialIntroductionViewController *tutorialIntroductionViewController;
@property (nonatomic, retain) StatsViewController* statsViewController;
@property (nonatomic, retain) SettingsViewController* settingsViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)_containerView launchedFromMap:(BOOL)_launchedFromMap;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)terminalViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType;
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType andInstructionSet:(NSMutableArray*)_instructionSet;
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView forSubroutine:(NSString*)_selectedSubroutineName;
- (void)removeInstructionsView;
- (void)instructionsViewWillAppear;
- (void)instructionsViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (DoTimesEditViewController*)showDoTimesEditView:(UIView*)_containerView forTerminalCell:(DoTimesTerminalCell*)_terminalCell;
- (void)removeDoTimesEditView;
- (void)doTimesEditViewWillAppear;
- (void)doTimesEditViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (CreateSubroutineViewController*)showCreateSubroutineView:(UIView*)_containerView;
- (void)removeCreateSubroutineView;
- (void)createSubroutineViewWillAppear;
- (void)createSubroutineViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (SubroutineViewController*)showSubroutineView:(UIView*)_containerView withName:(NSString*)_subroutineName;
- (void)removeSubroutineView;
- (void)subroutineViewWillAppear;
- (void)subroutineViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (RepositoryViewController*)showRepositoryView:(UIView*)_containerView;
- (void)removeRepositoryView;
- (void)repositoryViewWillAppear;
- (void)repositoryViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TutorialIndexViewController*)showTutorialIndexView:(UIView*)_containerView;
- (void)removeTutorialIndexView;
- (void)tutorialIndexViewWillAppear;
- (void)tutorialIndexViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TutorialSectionViewController*)showTutorialSectionView:(UIView*)_containerView withSectionID:(TutorialSectionID)_sectionID;
- (void)removeTutorialSectionView;
- (void)tutorialSectionViewWillAppear;
- (void)tutorialSectionViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TutorialIntroductionViewController*)showTutorialIntroductionView:(UIView*)_containerView withSectionID:(TutorialSectionID)_sectionID;
- (void)removeTutorialIntroductionView;
- (void)tutorialIntroductionViewWillAppear;
- (void)tutorialIntroductionViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (StatsViewController*)showStatsView:(UIView*)_containerView;
- (void)removeStatsView;
- (void)statsViewWillAppear;
- (void)statsViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (SettingsViewController*)showSettingsView:(UIView*)_containerView;
- (void)removeSettingsView;
- (void)settingsViewWillAppear;
- (void)settingsViewWillDisappear;

@end
