//
//  InstructionsViewController.m
//  seeker1
//
//  Created by Troy Stribling on 12/7/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "InstructionsViewController.h"
#import "TerminalViewController.h"
#import "TerminalCellFactory.h"
#import "CellUtils.h"
#import "TerminalCell.h"
#import "ProgramNgin.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kINSTRUCTIONS_LAUNCHER_BACK_TAG     1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface InstructionsViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation InstructionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize instructionsView;
@synthesize containerView;
@synthesize instructionsList;
@synthesize terminalViewController;

//===================================================================================================================================
#pragma mark InstructionsViewController PrivateAPI

//===================================================================================================================================
#pragma mark InstructionsViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inTerminalViewController:(TerminalViewController*)_terminalViewController {
    InstructionsViewController* viewController = 
        [[InstructionsViewController alloc] initWithNibName:@"InstructionsViewController" bundle:nil inView:_terminalViewController.containerView];
    viewController.terminalViewController = _terminalViewController;
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
    self.instructionsList = [[ProgramNgin instance] getPrimativeInstructions];
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
    NSString* instructions = [self.instructionsList objectAtIndex:indexPath.row];
    if (self.terminalViewController.selectedLine.row < [self.terminalViewController.programListing count]) {
        [self.terminalViewController.programListing replaceObjectAtIndex:self.terminalViewController.selectedLine.row withObject:instructions];
    } else {
        [self.terminalViewController.programListing addObject:instructions];
    }
    [self.terminalViewController.programView reloadData];
    NSIndexPath* bottomLine = [NSIndexPath indexPathForRow:(self.terminalViewController.selectedLine.row + 1) inSection:0];
    [self.terminalViewController.programView scrollToRowAtIndexPath:bottomLine atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
