//
//  FunctionsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "FunctionsLauncherView.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@class TerminalViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FunctionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LauncherViewDelegate> {
    IBOutlet UITableView* functionsView;
    UIView* containerView;
	NSMutableArray* functionList;
    TerminalViewController* terminalViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* functionsView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* functionList;
@property (nonatomic, retain) TerminalViewController* terminalViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inTerminalViewController:(TerminalViewController*)_terminalViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
