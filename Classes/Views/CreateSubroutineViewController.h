//
//  CreateSubroutineViewController.h
//  seeker1
//
//  Created by Troy Stribling on 1/5/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CreateSubroutineViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField* nameTextField;
    UIView* containerView;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) UITextField* nameTextField;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
