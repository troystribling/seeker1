//
//  InstructionsViewController.h
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "UserModel.h"

//-----------------------------------------------------------------------------------------------------------------------------------
typedef enum tagInstructionType {
    TerminalPrimitiveInstructionType,
    SubroutinePrimitiveInstructionType,
    TerminalDoTimesInstructionType,
    SubroutineDoTimesInstructionType,
    TerminalDoUntilInstructionType,
    SubroutineDoUntilInstructionType,
    TerminalDoUntilPredicateInstructionType,
    SubroutineDoUntilPredicateInstructionType,
    SubroutineInstructionType,
} InstructionType;

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* instructionsView;
    IBOutlet UIImageView* addSubroutineImageView;
    UIView* containerView;
	NSMutableArray* instructionsList;
    NSMutableArray* subroutinesList;
    NSString* selectedSubroutineName;
    InstructionType instructionType;
	NSMutableArray* selectedInstructionSet;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, retain) UITableView* instructionsView;
@property (nonatomic, retain) UIImageView* addSubroutineImageView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) NSMutableArray* instructionsList;
@property (nonatomic, retain) NSMutableArray* subroutinesList;
@property (nonatomic, retain) NSString* selectedSubroutineName;
@property (nonatomic, assign) InstructionType instructionType;
@property (nonatomic, retain) NSMutableArray* selectedInstructionSet;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
