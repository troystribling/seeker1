//
//  ViewControllerManager.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "TerminalViewController.h"
#import "InstructionsViewController.h"
#import "DoTimesEditViewController.h"
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
    [self.terminalViewController viewWillAppear:NO];
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
- (void)terminalViewSaveProgram {
    [[ProgramNgin instance] saveProgram:self.terminalViewController.programListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// InstructionsViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(TerminalViewController*)_terminalViewController {
    if (self.instructionsViewController == nil) {
        self.instructionsViewController = [InstructionsViewController inTerminalViewController:_terminalViewController];
    } 
    [_terminalViewController.containerView addSubview:self.instructionsViewController.view];
    [self.instructionsViewController viewWillAppear:NO];
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
        self.doTimesEditViewController = [DoTimesEditViewController inView:_containerView forTerminalCell:_terminalCell];
    } 
    [_containerView addSubview:self.doTimesEditViewController.view];
    [self.doTimesEditViewController viewWillAppear:NO];
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

@end
