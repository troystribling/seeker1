//
//  ViewControllerManager.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class TerminalViewController;
@class InstructionsViewController;
@class DoTimesEditViewController;
@class DoTimesTerminalCell;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
    InstructionsViewController* instructionsViewController;
    DoTimesEditViewController* doTimesEditViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;
@property (nonatomic, retain) InstructionsViewController* instructionsViewController;
@property (nonatomic, retain) DoTimesEditViewController* doTimesEditViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)_containerView;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)terminalViewWillDisappear;
- (void)terminalViewSaveProgram;

//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(TerminalViewController*)_terminalViewController;
- (void)removeInstructionsView;
- (void)instructionsViewWillAppear;
- (void)instructionsViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (DoTimesEditViewController*)showDoTimesEditView:(UIView*)containerView forTerminalCell:(DoTimesTerminalCell*)_terminalCell;
- (void)removeDoTimesEditView;
- (void)doTimesEditViewWillAppear;
- (void)doTimesEditViewWillDisappear;

@end
