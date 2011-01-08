//
//  InstructionsViewController.m
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "cocos2d.h"
#import "TerminalCellFactory.h"
#import "SubroutineModel.h"
#import "TerminalCell.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kINSTRUCTIONS_LAUNCHER_BACK_TAG         1
#define kINSTRUCTIONS_LAUNCHER_SUBS_TAG         2
#define kINSTRUCTIONS_LAUNCHER_ADD_SUB_TAG      3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController (PrivateAPI)

- (void)updatePrimitiveInstruction:(NSMutableArray*)_instructionSet forTerminal:(TerminalViewController*)_terminalViewController;
- (void)updateDoInstruction:(NSMutableArray*)_instructionSet;
- (void)updateDoUntilPredicate:(NSMutableArray*)_instructionSet;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation InstructionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize instructionsView;
@synthesize subroutineImageView;
@synthesize addSubroutineImageView;
@synthesize instructionType;
@synthesize containerView;
@synthesize instructionsList;
@synthesize selectedInstructionSet;

//===================================================================================================================================
#pragma mark InstructionsViewController PrivateAPI

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updatePrimitiveInstruction:(NSMutableArray*)_instructionSet forTerminal:(TerminalViewController*)_terminalViewController {
    if (_terminalViewController.selectedLine.row < [_terminalViewController.programListing count]) {
        NSInteger row = _terminalViewController.selectedLine.row;
        [_terminalViewController.programListing replaceObjectAtIndex:row withObject:_instructionSet];
    } else {
        [_terminalViewController.programListing addObject:_instructionSet];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateDoInstruction:(NSMutableArray*)_instructionSet {
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:1 withObject:newInstruction];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateDoUntilPredicate:(NSMutableArray*)_instructionSet {
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:2 withObject:newInstruction];
}

//===================================================================================================================================
#pragma mark InstructionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    InstructionsViewController* viewController = 
        [[InstructionsViewController alloc] initWithNibName:@"InstructionsViewController" bundle:nil inView:_containerView];
    return viewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.instructionsList = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.instructionsView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.subroutineImageView.hidden = YES;
    self.addSubroutineImageView.hidden = YES;
    switch (self.instructionType) {
        case PrimitiveInstructionType:
            self.instructionsList = [[ProgramNgin instance] getPrimitiveInstructions];
            if ([UserModel level] >= kLEVEL_FOR_SUBROUTINES) {
                self.subroutineImageView.hidden = NO;
            }
            break;
        case DoTimesInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoInstructions];
            break;
        case DoUntilInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoInstructions];
            break;
        case DoUntilPredicateInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoUntilPredicates];
            break;
        case SubroutineInstructionType:
            self.instructionsList = [SubroutineModel modelsToInstructions:[SubroutineModel findAll]];
            self.addSubroutineImageView.hidden = NO;
            break;            
        default:
            break;
    }
    [self.instructionsView reloadData];
	[super viewWillAppear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//===================================================================================================================================
#pragma mark UIResponder

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    NSInteger touchTag = touch.view.tag;
    switch (touchTag) {
        case kINSTRUCTIONS_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            switch (self.instructionType) {
                case SubroutineInstructionType:
                    [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:PrimitiveInstructionType];
                    break; 
                default:
                    break;
            }
            break;
        case kINSTRUCTIONS_LAUNCHER_SUBS_TAG:
            [self.view removeFromSuperview];
            [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutineInstructionType];
            break;
        case kINSTRUCTIONS_LAUNCHER_ADD_SUB_TAG:
            [[ViewControllerManager instance] showCreateSubroutineView:[[CCDirector sharedDirector] openGLView]];
            break;            
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.instructionsList count];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    return [TerminalCellFactory tableView:tableView listCellForRowAtIndexPath:indexPath forInstructionSet:instructionSet];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    ViewControllerManager* viewControllerManager = [ViewControllerManager instance];
    TerminalViewController* terminalViewController = [viewControllerManager terminalViewController];
    NSString* subroutineName;
    switch (self.instructionType) {
        case PrimitiveInstructionType:
            [self updatePrimitiveInstruction:instructionSet forTerminal:terminalViewController];
            break;
        case DoTimesInstructionType:
            [self updateDoInstruction:instructionSet];
            break;
        case DoUntilInstructionType:
            [self updateDoInstruction:instructionSet];
            break;
        case DoUntilPredicateInstructionType:
            [self updateDoUntilPredicate:instructionSet];            
            break;
        case SubroutineInstructionType:
            subroutineName = [instructionSet objectAtIndex:1];
            [viewControllerManager showSubroutineView:[[CCDirector sharedDirector] openGLView] withName:subroutineName];
            break;            
    }
    [terminalViewController.programView reloadData];
    NSInteger selectedRow = terminalViewController.selectedLine.row;
    if (selectedRow < ([terminalViewController.programListing count] + 1)) {
        NSIndexPath* bottomLine = [NSIndexPath indexPathForRow:(selectedRow + 1) inSection:0];
        [terminalViewController.programView scrollToRowAtIndexPath:bottomLine atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [self.view removeFromSuperview];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSMutableArray* instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    return [TerminalCellFactory tableView:tableView heightForRowWithInstructionSet:instructionSet];
}

//===================================================================================================================================
#pragma mark NSObject

@end
