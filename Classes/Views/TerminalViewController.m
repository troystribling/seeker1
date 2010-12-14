//
//  TerminalViewController.m
//  seeker1
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "TerminalViewController.h"
#import "MapScene.h"
#import "MapMenuView.h"
#import "FunctionsViewController.h"
#import "ViewControllerManager.h"
#import "ProgramNgin.h"
#import "TerminalCell.h"
#import "TouchImageView.h"
#import "CellUtils.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize programView;
@synthesize terminalLauncherView;
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
        self.programListing = [NSMutableArray arrayWithCapacity:10];
        self.editingEnabled = NO;
    }
    return self;
}

//===================================================================================================================================
#pragma mark UIViewController

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.terminalLauncherView = [TerminalLauncherView inView:self.view andDelegate:self];
    self.programView.separatorColor = [UIColor blackColor];
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
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
#pragma mark LauncherViewDelegate 

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)viewTouchedNamed:(NSString*)name {
    if ([name isEqualToString:@"back"]) {
        [self.view removeFromSuperview];
    } else if ([name isEqualToString:@"edit"]) {
        if (self.editingEnabled) {
            self.editingEnabled = NO;
            self.terminalLauncherView.editItem.image = [UIImage imageNamed:@"terminal-launcher-edit.png"];
            [self.programView setEditing:NO animated:YES];
        } else {
            self.editingEnabled = YES;
            self.terminalLauncherView.editItem.image = [UIImage imageNamed:@"terminal-launcher-editing.png"];
            [self.programView setEditing:YES animated:YES];
        }
    } else if ([name isEqualToString:@"run"]) {
        [[ProgramNgin instance] loadProgram:self.programListing];
        [self.mapScene addResetTerminalItems];
        [self.mapScene.menu addReset];
        [self.view removeFromSuperview];
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
    TerminalCell* cell = (TerminalCell*)[CellUtils createCell:[TerminalCell class] forTableView:tableView];
    if (indexPath.row == [self.programListing count]) {
        cell.lineLabel.text = @"$";
    } else {
        cell.lineLabel.text = [NSString stringWithFormat:@"$ %@", [self.programListing objectAtIndex:indexPath.row]];
    }
    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.programListing count]) {
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
    if (indexPath.row == [self.programListing count]) {
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
    [[ViewControllerManager instance] showFunctionsView:self];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return kTERMINAL_LINE_CELL_HEIGHT;
}

//===================================================================================================================================
#pragma mark NSObject

@end

