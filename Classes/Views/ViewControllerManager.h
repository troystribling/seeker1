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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
    InstructionsViewController* functionsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;
@property (nonatomic, retain) InstructionsViewController* functionsViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)containerView;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)terminalViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (InstructionsViewController*)showInstructionsView:(TerminalViewController*)containerView;
- (void)removeInstructionsView;
- (void)instructionsViewWillAppear;
- (void)instructionsViewWillDisappear;

@end
