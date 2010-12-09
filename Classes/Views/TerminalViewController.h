//
//  TerminalViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "TerminalLauncherView.h"

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LauncherViewDelegate> {
    IBOutlet UITableView* programView;
    TerminalLauncherView* terminalLauncherView;
    UIView* containerView;
	NSMutableArray* programListing;
    NSString* functionUpdate;
    NSInteger rowUpdated;    
    BOOL editingEnabled;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* programView;
@property (nonatomic, retain) TerminalLauncherView* terminalLauncherView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* programListing;
@property (nonatomic, retain) NSString* functionUpdate;
@property (nonatomic, assign) NSInteger rowUpdated;
@property (nonatomic, assign) BOOL editingEnabled;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
