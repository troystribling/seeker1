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
#import "FunctionsViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerManager* thisViewControllerManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewControllerManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewControllerManager

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize terminalViewController;
@synthesize functionsViewController;

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
- (void)terminalViewWillDisappear {
    [self.terminalViewController viewWillDisappear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
// FunctionsViewController
//-----------------------------------------------------------------------------------------------------------------------------------
- (FunctionsViewController*)showFunctionsView:(TerminalViewController*)_terminalViewController {
    if (self.functionsViewController == nil) {
        self.functionsViewController = [FunctionsViewController inTerminalViewController:_terminalViewController];
    } 
    [_terminalViewController.containerView addSubview:self.functionsViewController.view];
    [self.functionsViewController viewWillAppear:NO];
    return self.functionsViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)removeFunctionsView {
    if (self.functionsViewController) {
        [self.functionsViewController viewWillDisappear:NO];
        [self.functionsViewController.view removeFromSuperview];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)functionsViewWillAppear {
    [self.functionsViewController viewWillAppear:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)functionsViewWillDisappear {
    [self.functionsViewController viewWillDisappear:NO];
}

@end
