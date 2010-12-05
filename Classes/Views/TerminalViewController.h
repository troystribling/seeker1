//
//  TerminalViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController : UITableViewController {
    UIView* containerView;
	NSMutableArray* programListing;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* programListing;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
