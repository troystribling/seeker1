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
@class FunctionsViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
    FunctionsViewController* functionsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;
@property (nonatomic, retain) FunctionsViewController* functionsViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)containerView;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)terminalViewWillDisappear;

//-----------------------------------------------------------------------------------------------------------------------------------
- (FunctionsViewController*)showFunctionsView:(TerminalViewController*)containerView;
- (void)removeFunctionsView;
- (void)functionsViewWillAppear;
- (void)functionsViewWillDisappear;

@end
