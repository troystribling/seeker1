//
//  RespositoryViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/20/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface RespositoryViewController : UIViewController {
    IBOutlet UITableView* repositoryView;
    UIView* containerView;
	NSMutableArray* programsList;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* repositoryView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* programsList;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
