//
//  TerminalViewController.m
//  seeker
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TerminalViewController.h"
#import "MapScene.h"
#import "TermMenuView.h"
#import "InstructionsViewController.h"
#import "ViewControllerManager.h"
#import "ProgramNgin.h"
#import "TerminalCellFactory.h"
#import "TerminalCell.h"
#import "TouchImageView.h"
#import "CellUtils.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTERMINAL_LAUNCHER_BACK_TAG     1
#define kTERMINAL_LAUNCHER_RUN_TAG      2
#define kTERMINAL_LAUNCHER_EDIT_TAG     3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController (PrivateAPI)

- (void)keyboardWillShow:(NSNotification*)note;
- (void)keyboardWillHide:(NSNotification*)note;
- (void)doneButtonPressed:(NSNotification*)note;
- (UIView*)findKeyboard;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize programView;
@synthesize editImageView;
@synthesize runImageView;
@synthesize mapScene;
@synthesize containerView;
@synthesize programListing;
@synthesize functionUpdate;
@synthesize selectedLine;
@synthesize editingEnabled;

//===================================================================================================================================
#pragma mark TerminalViewController PrivateAPI

//===================================================================================================================================
#pragma mark TerminalViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    return [[TerminalViewController alloc] initWithNibName:@"TerminalViewController" bundle:nil inView:_containerView];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.editingEnabled = NO;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.programView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.programListing = [NSMutableArray arrayWithArray:[ProgramNgin instance].program];
    if ([[ProgramNgin instance] programIsHalted] || [[ProgramNgin instance] programIsRunning]) {
       self.runImageView.hidden = YES;
    } else {
        self.runImageView.hidden = NO;
    }
    [self.programView reloadData];
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
        case kTERMINAL_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            [[ProgramNgin instance] saveProgram:self.programListing];
            break;
        case kTERMINAL_LAUNCHER_RUN_TAG:
            [[ProgramNgin instance] loadProgram:self.programListing];
            [self.mapScene addResetTerminalItems];
            [self.mapScene.menu addResetItems];
            [self.view removeFromSuperview];
            break;
        case kTERMINAL_LAUNCHER_EDIT_TAG:
            if (self.editingEnabled) {
                self.editingEnabled = NO;
                self.editImageView.image = [UIImage imageNamed:@"terminal-launcher-edit.png"];
                [self.programView setEditing:NO animated:YES];
            } else {
                self.editingEnabled = YES;
                self.editImageView.image = [UIImage imageNamed:@"terminal-launcher-editing.png"];
                [self.programView setEditing:YES animated:YES];
            }
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
    return [self.programListing count] + 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.programListing count]) {
        return [TerminalCell tableView:tableView promptCellForRowAtIndexPath:indexPath];
    } else {
        NSMutableArray* instructionSet = [self.programListing objectAtIndex:indexPath.row];
        return [TerminalCellFactory tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:instructionSet];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linesOfCode = [self.programListing count];
    if (indexPath.row == linesOfCode || linesOfCode == 1) {
        return NO;
    } else {
        return YES;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.programListing removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
    NSString* lineOfCode = [self.programListing objectAtIndex:fromIndexPath.row];
    [self.programListing removeObjectAtIndex:fromIndexPath.row];
    [self.programListing insertObject:lineOfCode atIndex:toIndexPath.row];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linesOfCode = [self.programListing count];
    if (indexPath.row == linesOfCode || linesOfCode == 1) {
        return NO;
    } else {
        return YES;
    }
}

//===================================================================================================================================
#pragma mark UITableViewDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedLine = indexPath;
    [[ViewControllerManager instance] showInstructionsView:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == [self.programListing count]) {
        return kTERMINAL_DEFAULT_CELL_HEIGHT;
    } else {
        NSMutableArray* instructionSet = [self.programListing objectAtIndex:indexPath.row];
        return [TerminalCellFactory tableView:tableView heightForRowWithInstructionSet:instructionSet];
    }
}

//===================================================================================================================================
#pragma mark NSObject

@end

