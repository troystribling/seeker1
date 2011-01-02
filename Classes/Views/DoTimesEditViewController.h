//
//  DoTimesEditViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/1/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
@class DoTimesTerminalCell;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DoTimesEditViewController : UIViewController  {
    IBOutlet UITextField* numberTextField;
    UIView* containerView;
    DoTimesTerminalCell* terminalCell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) DoTimesTerminalCell* terminalCell;
@property (nonatomic, retain) UITextField* numberTextField;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView forTerminalCell:(DoTimesTerminalCell*)_terminalCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
