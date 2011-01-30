//
//  TutorialIndexViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/29/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TutorialIndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* tutorialsView;
    UIView* containerView;
	NSMutableArray* tutorialsList;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* tutorialsView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* tutorialsList;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
