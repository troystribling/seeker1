//
//  InstructionsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "InstructionsLauncherView.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class TerminalViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LauncherViewDelegate> {
    IBOutlet UITableView* instructionsView;
    UIView* containerView;
	NSMutableArray* instructionsList;
    TerminalViewController* terminalViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* instructionsView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* instructionsList;
@property (nonatomic, retain) TerminalViewController* terminalViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inTerminalViewController:(TerminalViewController*)_terminalViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
