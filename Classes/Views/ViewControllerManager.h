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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager : NSObject {
    TerminalViewController* terminalViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) TerminalViewController* terminalViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerManager*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (TerminalViewController*)showTerminalView:(UIView*)containerView;
- (void)removeTerminalView;
- (void)terminalViewWillAppear;
- (void)rerminalViewWillDisappear;


@end
