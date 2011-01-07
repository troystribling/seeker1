//
//  ViewControllerManager.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerManager* thisViewControllerManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewControllerManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize terminalViewController;
@synthesize instructionsViewController;
@synthesize doTimesEditViewController;
@synthesize createSubroutineViewController;
@synthesize subroutineViewController;

//===================================================================================================================================
#pragma mark ViewControllerManager PrivateApi

//===================================================================================================================================
#pragma mark ViewControllerManager

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance {	
    @synchronized(self) {
        if (thisViewControllerManager == nil) {
            thisViewControllerManager = [[self alloc] init]; 
        }
    }
    return thisViewControllerManager;
}

//-----------------------------------------------------------------------------------------------------------------------------------
// TerminalViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)_containerView {
    if (self.terminalViewController == nil) {
        self.terminalViewController = [TerminalViewController inView:_containerView];
    } 
    [_containerView addSubview:self.terminalViewController.view];
    return self.terminalViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeTerminalView {
    if (self.terminalViewController) {
        [self.terminalViewController viewWillDisappear:NO];
        [self.terminalViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)terminalViewWillAppear {
    [self.terminalViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)terminalViewWillDisappear {
    [self.terminalViewController viewWillDisappear:NO];
}


//-----------------------------------------------------------------------------------------------------------------------------------
// InstructionsViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType {
    if (self.instructionsViewController == nil) {
        self.instructionsViewController = [InstructionsViewController inView:_containerView];
    } 
    self.instructionsViewController.instructionType = _instructionType;
    [_containerView addSubview:self.instructionsViewController.view];
    return self.instructionsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(UIView*)_containerView withInstructionType:(InstructionType)_instructionType andInstructionSet:(NSMutableArray*)_instructionSet {
    if (self.instructionsViewController == nil) {
        self.instructionsViewController = [InstructionsViewController inView:_containerView];
    } 
    self.instructionsViewController.instructionType = _instructionType;
    self.instructionsViewController.selectedInstructionSet = _instructionSet;
    [_containerView addSubview:self.instructionsViewController.view];
    return self.instructionsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeInstructionsView {
    if (self.instructionsViewController) {
        [self.instructionsViewController viewWillDisappear:NO];
        [self.instructionsViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)instructionsViewWillAppear {
    [self.instructionsViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)instructionsViewWillDisappear {
    [self.instructionsViewController viewWillDisappear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// DoTimesEditViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (DoTimesEditViewController*)showDoTimesEditView:(UIView*)_containerView forTerminalCell:(DoTimesTerminalCell*)_terminalCell {
    if (self.doTimesEditViewController == nil) {
        self.doTimesEditViewController = [DoTimesEditViewController inView:_containerView];
    } 
    self.doTimesEditViewController.terminalCell = _terminalCell;
    [_containerView addSubview:self.doTimesEditViewController.view];
    return self.doTimesEditViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeDoTimesEditView {
    if (self.doTimesEditViewController) {
        [self.doTimesEditViewController viewWillDisappear:NO];
        [self.doTimesEditViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)doTimesEditViewWillAppear {
    [self.doTimesEditViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)doTimesEditViewWillDisappear {
    [self.doTimesEditViewController viewWillDisappear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// CreateSubroutineViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (CreateSubroutineViewController*)showCreateSubroutineView:(UIView*)_containerView {
    if (self.createSubroutineViewController == nil) {
        self.createSubroutineViewController = [CreateSubroutineViewController inView:_containerView];
    } 
    [_containerView addSubview:self.createSubroutineViewController.view];
    return self.createSubroutineViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeCreateSubroutineView {
    if (self.createSubroutineViewController) {
        [self.createSubroutineViewController viewWillDisappear:NO];
        [self.createSubroutineViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSubroutineViewWillAppear {
    [self.createSubroutineViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)createSubroutineViewWillDisappear {
    [self.createSubroutineViewController viewWillDisappear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// SubroutineViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (SubroutineViewController*)showSubroutineView:(UIView*)_containerView withName:(NSString*)_subroutineName {
    if (self.subroutineViewController == nil) {
        self.subroutineViewController = [SubroutineViewController inView:_containerView];
    } 
    self.subroutineViewController.subroutineName = _subroutineName;
    [_containerView addSubview:self.subroutineViewController.view];
    return self.subroutineViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeSubroutineView {
    if (self.subroutineViewController) {
        [self.subroutineViewController viewWillDisappear:NO];
        [self.subroutineViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)subroutineViewWillAppear {
    [self.subroutineViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)subroutineViewWillDisappear {
    [self.subroutineViewController viewWillDisappear:NO];
}

@end
