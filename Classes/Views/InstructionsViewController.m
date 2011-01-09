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

- (void)updateTerminalPrimitiveInstruction:(NSMutableArray*)_instructionSet;
- (void)updateSubroutinePrimitiveInstruction:(NSMutableArray*)_instructionSet;
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
- (void)updateTerminalPrimitiveInstruction:(NSMutableArray*)_instructionSet {
    TerminalViewController* terminalViewController = [[ViewControllerManager instance] terminalViewController];
    NSInteger row = terminalViewController.selectedLine.row;
    if (row < [terminalViewController.programListing count]) {
        [terminalViewController.programListing replaceObjectAtIndex:row withObject:_instructionSet];
    } else {
        [terminalViewController.programListing addObject:_instructionSet];
    }
    [[ProgramNgin instance] saveProgram:terminalViewController.programListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSubroutinePrimitiveInstruction:(NSMutableArray*)_instructionSet {
    SubroutineViewController* subroutineViewController = [[ViewControllerManager instance] subroutineViewController];
    NSInteger row = subroutineViewController.selectedLine.row;
    if (row < [subroutineViewController.subroutineListing count]) {
        [subroutineViewController.subroutineListing replaceObjectAtIndex:row withObject:_instructionSet];
    } else {
        [subroutineViewController.subroutineListing addObject:_instructionSet];
    }
    [SubroutineModel insertSubroutine:subroutineViewController.subroutineListing withName:subroutineViewController.subroutineName];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateDoInstruction:(NSMutableArray*)_instructionSet {
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:1 withObject:newInstruction];
    [[ProgramNgin instance] saveProgram:[[ViewControllerManager instance] terminalViewController].programListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateDoUntilPredicate:(NSMutableArray*)_instructionSet {
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:2 withObject:newInstruction];
    [[ProgramNgin instance] saveProgram:[[ViewControllerManager instance] terminalViewController].programListing];
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
        case TerminalPrimitiveInstructionType:
            self.instructionsList = [[ProgramNgin instance] getPrimitiveInstructions];
            if ([UserModel level] >= kLEVEL_FOR_SUBROUTINES) {
                self.subroutineImageView.hidden = NO;
            }
            break;
        case SubroutinePrimitiveInstructionType:
            self.instructionsList = [[ProgramNgin instance] getPrimitiveInstructions];
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
                    [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:TerminalPrimitiveInstructionType];
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
    BOOL canEdit = NO;
    if (self.instructionType == SubroutineInstructionType) {
        canEdit = YES;
    }
    return canEdit;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete && self.instructionType == SubroutineInstructionType) {
        NSMutableArray* instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
        [self.instructionsList removeObjectAtIndex:indexPath.row];
        NSString* subroutineName = [instructionSet objectAtIndex:1]; 
        SubroutineModel* model = [SubroutineModel findByName:subroutineName];
        [model destroy];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
}


//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    ViewControllerManager* viewControllerManager = [ViewControllerManager instance];
    NSString* subroutineName;
    switch (self.instructionType) {
        case TerminalPrimitiveInstructionType:
            [self updateTerminalPrimitiveInstruction:instructionSet];
            [viewControllerManager terminalViewWillAppear];
            break;
        case SubroutinePrimitiveInstructionType:
            [self updateSubroutinePrimitiveInstruction:instructionSet];
            [viewControllerManager subroutineViewWillAppear];
            break;
        case DoTimesInstructionType:
            [self updateDoInstruction:instructionSet];
            [viewControllerManager terminalViewWillAppear];
            break;
        case DoUntilInstructionType:
            [self updateDoInstruction:instructionSet];
            [viewControllerManager terminalViewWillAppear];
            break;
        case DoUntilPredicateInstructionType:
            [self updateDoUntilPredicate:instructionSet];            
            [viewControllerManager terminalViewWillAppear];
            break;
        case SubroutineInstructionType:
            subroutineName = [instructionSet objectAtIndex:1];
            [viewControllerManager showSubroutineView:[[CCDirector sharedDirector] openGLView] withName:subroutineName];
            break;            
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
