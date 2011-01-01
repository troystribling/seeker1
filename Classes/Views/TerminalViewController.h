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
@class TouchImageView;
@class MapScene;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LauncherViewDelegate, UITextFieldDelegate> {
    IBOutlet UITableView* programView;
    TerminalLauncherView* terminalLauncherView;
    MapScene* mapScene;
    UIView* containerView;
	NSMutableArray* programListing;
    NSString* functionUpdate;
    NSIndexPath* selectedLine;    
    BOOL editingEnabled;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* programView;
@property (nonatomic, retain) TerminalLauncherView* terminalLauncherView;
@property (nonatomic, retain) MapScene* mapScene;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* programListing;
@property (nonatomic, retain) NSString* functionUpdate;
@property (nonatomic, assign) NSIndexPath* selectedLine;
@property (nonatomic, assign) BOOL editingEnabled;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
