//
//  SubroutineViewController.m
//  seeker1
//
//  Created by Troy Stribling on 1/5/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "cocos2d.h"
#import "SubroutineModel.h"
#import "TerminalCell.h"
#import "TerminalCellFactory.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kSUBROUTINE_LAUNCHER_BACK_TAG   1
#define kSUBROUTINE_LAUNCHER_EDIT_TAG   2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SubroutineViewController (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SubroutineViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize subroutineView;
@synthesize editImageView;
@synthesize subroutineNameLabel;
@synthesize containerView;
@synthesize subroutineListing;
@synthesize selectedLine;
@synthesize subroutineName;
@synthesize editingEnabled;

//===================================================================================================================================
#pragma mark SubroutineViewController PrivateAPI

//===================================================================================================================================
#pragma mark SubroutineViewController

//-----------------------------------------------------------------------------------------------------------------------------------
+ (id)inView:(UIView*)_containerView {
    return [[SubroutineViewController alloc] initWithNibName:@"SubroutineViewController" bundle:nil inView:_containerView];
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
    self.subroutineView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    self.subroutineNameLabel.text = [NSString stringWithFormat:@"%@:", self.subroutineName];
    SubroutineModel* model = [SubroutineModel findByName:self.subroutineName];
    if (model) {
        self.subroutineListing = [model codeListingToInstrictions];
    }
    [self.subroutineView reloadData];
    NSInteger selectedRow = self.selectedLine.row;
    if ((selectedRow + 1) == [self.subroutineListing count]) {
        NSIndexPath* bottomLine = [NSIndexPath indexPathForRow:[self.subroutineListing count] inSection:0];
        [self.subroutineView scrollToRowAtIndexPath:bottomLine atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
        case kSUBROUTINE_LAUNCHER_BACK_TAG:
            [self.view removeFromSuperview];
            [SubroutineModel insertSubroutine:self.subroutineListing withName:self.subroutineName];
            break;
        case kSUBROUTINE_LAUNCHER_EDIT_TAG:
            if (self.editingEnabled) {
                self.editingEnabled = NO;
                self.editImageView.image = [UIImage imageNamed:@"terminal-launcher-edit.png"];
                [self.subroutineView setEditing:NO animated:YES];
            } else {
                self.editingEnabled = YES;
                self.editImageView.image = [UIImage imageNamed:@"terminal-launcher-editing.png"];
                [self.subroutineView setEditing:YES animated:YES];
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
    return [self.subroutineListing count] + 1;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.subroutineListing count]) {
        return [TerminalCell tableView:tableView promptCellForRowAtIndexPath:indexPath];
    } else {
        NSMutableArray* instructionSet = [self.subroutineListing objectAtIndex:indexPath.row];
        return [TerminalCellFactory tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:instructionSet];
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linesOfCode = [self.subroutineListing count];
    if (indexPath.row == linesOfCode || linesOfCode == 1) {
        return NO;
    } else {
        return YES;
    }
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.subroutineListing removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
    NSString* lineOfCode = [self.subroutineListing objectAtIndex:fromIndexPath.row];
    [self.subroutineListing removeObjectAtIndex:fromIndexPath.row];
    [self.subroutineListing insertObject:lineOfCode atIndex:toIndexPath.row];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger linesOfCode = [self.subroutineListing count];
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
    [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:SubroutinePrimitiveInstructionType];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == [self.subroutineListing count]) {
        return kTERMINAL_DEFAULT_CELL_HEIGHT;
    } else {
        NSMutableArray* instructionSet = [self.subroutineListing objectAtIndex:indexPath.row];
        return [TerminalCellFactory tableView:tableView heightForRowWithInstructionSet:instructionSet];
    }
}

//===================================================================================================================================
#pragma mark NSObject

@end
