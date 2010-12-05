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

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerManager* thisViewControllerManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewControllerManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize terminalViewController;

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
- (TerminalViewController*)showTerminalView:(UIView*)containerView {
    if (self.terminalViewController == nil) {
        self.terminalViewController = [TerminalViewController inView:containerView];
    } 
    [containerView addSubview:self.terminalViewController.view];
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
- (void)rerminalViewWillDisappear {
    [self.terminalViewController viewWillDisappear:NO];
}

@end
