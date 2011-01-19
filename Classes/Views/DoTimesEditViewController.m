    //
//  DoTimesEditViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/1/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "DoTimesEditViewController.h"
#import "DoTimesTerminalCell.h"
#import "ViewControllerManager.h"
#import "SubroutineModel.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kDOTIMES_LAUNCHER_BACK_TAG          1
#define kDOTIMES_LAUNCHER_DONE_TAG          2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesEditViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DoTimesEditViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize numberTextField;
@synthesize containerView;
@synthesize terminalCell;

//===================================================================================================================================
#pragma mark DoTimesEditViewController PrivateAPI

//===================================================================================================================================
#pragma mark DoTimesEditViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    DoTimesEditViewController* viewController = [[DoTimesEditViewController alloc] initWithNibName:@"DoTimesEditViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self.numberTextField becomeFirstResponder]; 
    self.numberTextField.text = @"";
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    NSInteger touchTag = touch.view.tag;
    NSInteger numberVal;
    switch (touchTag) {
        case kDOTIMES_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            break;
        case kDOTIMES_LAUNCHER_DONE_TAG:
            numberVal = [self.numberTextField.text intValue];
            [self.terminalCell.instructionSet replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:numberVal]];
            [self.view removeFromSuperview];
            ViewControllerManager* viewControllerManager = [ViewControllerManager instance];
            if (self.terminalCell.parentType == TerminalTerminalCellParentType) {
                TerminalViewController* terminalViewController = [viewControllerManager terminalViewController];
                [[ProgramNgin instance] saveProgram:terminalViewController.programListing];
                [viewControllerManager terminalViewWillAppear];
            } else {
                SubroutineViewController* subroutineViewController = [viewControllerManager subroutineViewController];
                [SubroutineModel insertSubroutine:subroutineViewController.subroutineListing withName:subroutineViewController.subroutineName];
                [viewControllerManager subroutineViewWillAppear];
            }
            break;
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

@end
