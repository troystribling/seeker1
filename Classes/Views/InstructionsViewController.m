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
#define kINSTRUCTIONS_LAUNCHER_ADD_SUB_TAG      3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController (PrivateAPI)

- (void)updateTerminalPrimitiveInstruction:(NSMutableArray*)_instructionSet;
- (void)updateSubroutinePrimitiveInstruction:(NSMutableArray*)_instructionSet;
- (void)updateTerminalDoInstruction:(NSMutableArray*)_instructionSet;
- (void)updateSubroutineDoInstruction:(NSMutableArray*)_instructionSet;
- (void)updateTerminalDoUntilPredicate:(NSMutableArray*)_instructionSet;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation InstructionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize instructionsView;
@synthesize addSubroutineImageView;
@synthesize instructionType;
@synthesize containerView;
@synthesize instructionsList;
@synthesize subroutinesList;
@synthesize selectedSubroutineName;
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
- (void)updateTerminalDoInstruction:(NSMutableArray*)_instructionSet {
    [self.selectedInstructionSet replaceObjectAtIndex:1 withObject:_instructionSet];
    [[ProgramNgin instance] saveProgram:[[ViewControllerManager instance] terminalViewController].programListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSubroutineDoInstruction:(NSMutableArray*)_instructionSet {
    SubroutineViewController* subroutineViewController = [[ViewControllerManager instance] subroutineViewController];
    [self.selectedInstructionSet replaceObjectAtIndex:1 withObject:_instructionSet];
    [SubroutineModel insertSubroutine:subroutineViewController.subroutineListing withName:subroutineViewController.subroutineName];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateTerminalDoUntilPredicate:(NSMutableArray*)_instructionSet {
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:2 withObject:newInstruction];
    [[ProgramNgin instance] saveProgram:[[ViewControllerManager instance] terminalViewController].programListing];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSubroutineDoUntilPredicate:(NSMutableArray*)_instructionSet {
    SubroutineViewController* subroutineViewController = [[ViewControllerManager instance] subroutineViewController];
    NSNumber* newInstruction = [_instructionSet objectAtIndex:0];
    [self.selectedInstructionSet replaceObjectAtIndex:2 withObject:newInstruction];
    [SubroutineModel insertSubroutine:subroutineViewController.subroutineListing withName:subroutineViewController.subroutineName];
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
        self.subroutinesList = [NSMutableArray arrayWithCapacity:10];
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
    self.addSubroutineImageView.hidden = YES;
    [self.subroutinesList removeAllObjects];
    NSInteger level = [UserModel level];
    switch (self.instructionType) {
        case TerminalPrimitiveInstructionType:
            self.instructionsList = [[ProgramNgin instance] getPrimitiveInstructions];
            if (level >= kLEVEL_FOR_SUBROUTINES) {
                self.subroutinesList = [SubroutineModel modelsToInstructions:[SubroutineModel findAll] forLevel:level];
            }
            break;
        case SubroutinePrimitiveInstructionType:
            self.instructionsList = [[ProgramNgin instance] getPrimitiveInstructions];
            self.subroutinesList = [SubroutineModel modelsToInstructions:[SubroutineModel findAllByName:self.selectedSubroutineName] forLevel:level];
            break;
        case TerminalDoTimesInstructionType:
        case SubroutineDoTimesInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoInstructions];
            self.subroutinesList = [SubroutineModel modelsToInstructions:[SubroutineModel findAll] forLevel:level];
            break;
        case TerminalDoUntilInstructionType:
        case SubroutineDoUntilInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoInstructions];
            self.subroutinesList = [SubroutineModel modelsToInstructions:[SubroutineModel findAll] forLevel:level];
            break;
        case TerminalDoUntilPredicateInstructionType:
        case SubroutineDoUntilPredicateInstructionType:
            self.instructionsList = [[ProgramNgin instance] getDoUntilPredicates];
            break;
        case SubroutineInstructionType:
            self.instructionsList = [SubroutineModel modelsToInstructions:[SubroutineModel findAll] forLevel:level];
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
            break;
        case kINSTRUCTIONS_LAUNCHER_ADD_SUB_TAG:
            [self.view removeFromSuperview];
            [[ViewControllerManager instance] showCreateSubroutineView:[[CCDirector sharedDirector] openGLView]];
            break;            
        default:
            break;
    }
}

//===================================================================================================================================
#pragma mark UITableViewDataSource

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 1;
    if ([self.subroutinesList count] > 0) {
        sectionCount = 2;
    }
    return sectionCount;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.instructionsList count];
    } else {
        return [self.subroutinesList count];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray* instructionSet = nil;
    if (indexPath.section == 0) {
        instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    } else {
        instructionSet = [self.subroutinesList objectAtIndex:indexPath.row];
    }
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
    NSMutableArray* instructionSet = nil;
    if (indexPath.section == 0) {
        instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    } else {
        instructionSet = [self.subroutinesList objectAtIndex:indexPath.row];
    }
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
        case TerminalDoTimesInstructionType:
            [self updateTerminalDoInstruction:instructionSet];
            [viewControllerManager terminalViewWillAppear];
            break;
        case SubroutineDoTimesInstructionType:
            [self updateSubroutineDoInstruction:instructionSet];
            [viewControllerManager subroutineViewWillAppear];
            break;
        case TerminalDoUntilInstructionType:
            [self updateTerminalDoInstruction:instructionSet];
            [viewControllerManager terminalViewWillAppear];
            break;
        case SubroutineDoUntilInstructionType:
            [self updateSubroutineDoInstruction:instructionSet];
            [viewControllerManager subroutineViewWillAppear];
            break;
        case TerminalDoUntilPredicateInstructionType:
            [self updateTerminalDoUntilPredicate:instructionSet];            
            [viewControllerManager terminalViewWillAppear];
            break;
        case SubroutineDoUntilPredicateInstructionType:
            [self updateSubroutineDoUntilPredicate:instructionSet];            
            [viewControllerManager subroutineViewWillAppear];
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
    NSMutableArray* instructionSet;
    if (indexPath.section == 0) {
        instructionSet = [self.instructionsList objectAtIndex:indexPath.row];
    } else {
        instructionSet = [self.subroutinesList objectAtIndex:indexPath.row];
    }
    return [TerminalCellFactory tableView:tableView heightForRowWithInstructionSet:instructionSet];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {  
    UIView* headerView = [[[UIView alloc] init] autorelease];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UILabel* header = [[[UILabel alloc] initWithFrame:CGRectMake(0.0625 * screenRect.size.width, 0.0, 0.9375 * screenRect.size.width, 
                                                                 kTERMINAL_DEFAULT_CELL_HEIGHT)] autorelease];
    header.textColor = [UIColor colorWithRed:1.0 green:0.843 blue:0.0 alpha:1.0];
    header.backgroundColor = [UIColor blackColor];
    header.font = [UIFont fontWithName:@"Courier" size:22.0];
    if (section == 0) {
        header.text = @"primitives"; 
    } else {
        header.text = @"subroutines";
    }
    [headerView addSubview:header];
    return headerView; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.subroutinesList count] > 0) {
        return kTERMINAL_DEFAULT_CELL_HEIGHT;
    } else {
        return 0;
    }

}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

//===================================================================================================================================
#pragma mark NSObject

@end
