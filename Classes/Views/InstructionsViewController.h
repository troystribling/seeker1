//
//  InstructionsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagInstructionType {
    PrimitiveInstructionType,
    DoTimesInstructionType,
    DoWhileInstructionType,
    DoWhilePredicateInstructionType,
    DoUntilInstructionType,
    DoUntilPredicateInstructionType,
} InstructionType;

//-----------------------------------------------------------------------------------------------------------------------------------
@class TerminalViewController;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* instructionsView;
    UIView* containerView;
	NSMutableArray* instructionsList;
    InstructionType instructionType;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* instructionsView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* instructionsList;
@property (nonatomic, assign) InstructionType instructionType;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
