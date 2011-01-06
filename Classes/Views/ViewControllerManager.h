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

//-----------------------------------------------------------------------------------------------------------------------------------
@class DoTimesTerminalCell;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
    InstructionsViewController* instructionsViewController;
    DoTimesEditViewController* doTimesEditViewController;
    CreateSubroutineViewController* createSubroutineViewController;
    SubroutineViewController* subroutineViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;
@property (nonatomic, retain) InstructionsViewController* instructionsViewController;
@property (nonatomic, retain) DoTimesEditViewController* doTimesEditViewController;
@property (nonatomic, retain) CreateSubroutineViewController* createSubroutineViewController;
@property (nonatomic, retain) SubroutineViewController* subroutineViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)_containerView;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)terminalViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType;
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType andInstructionSet:(NSMutableArray*)_instructionSet;
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
- (CreateSubroutineViewController*)showSubroutineView:(UIView*)_containerView;
- (void)removeSubroutineView;
- (void)subroutineViewWillAppear;
- (void)subroutineViewWillDisappear;

@end
