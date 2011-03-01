//
//  TerminalViewController.m
//  seeker
//
//  Created by Troy Stribling on 12/5/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "ViewControllerManager.h"
#import "ProgramNgin.h"
#import "ProgramModel.h"
#import "MapScene.h"
#import "UploadScene.h"
#import "InstructionsViewController.h"
#import "ViewControllerManager.h"
#import "TerminalCellFactory.h"
#import "TerminalCell.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#define kTERMINAL_LAUNCHER_BACK_TAG     1
#define kTERMINAL_LAUNCHER_RUN_TAG      2
#define kTERMINAL_LAUNCHER_EDIT_TAG     3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TerminalViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TerminalViewController

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize programView;
@synthesize editImageView;
@synthesize runImageView;
@synthesize opacitySlider;
@synthesize opacityImage;
@synthesize opacityLabel;
@synthesize containerView;
@synthesize programListing;
@synthesize functionUpdate;
@synthesize selectedLine;
@synthesize launchedFromMap;
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
        self.selectedLine = [NSIndexPath indexPathForRow:0 inSection:0];
        self.editingEnabled = NO;
        self.opacityLabel.font = [UIFont fontWithName:kGLOBAL_FONT size:kGLOBAL_FONT_SIZE];
        UIImage* stetchLeftTrack = [[UIImage imageNamed:@"slider-left.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        UIImage* stetchRightTrack = [[UIImage imageNamed:@"slider-right.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        [self.opacitySlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [self.opacitySlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (IBAction)opacityValueChanged:(UISlider*)sender {  
    CGFloat alphaValue = [sender value];
    self.view.alpha = kALPHA_MIN + kALPHA_DELTA * alphaValue; 
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
    ProgramModel* model = [ProgramModel findByLevel:[UserModel level]];
    ProgramNgin* ngin = [ProgramNgin instance];
    if (model) {
        self.programListing = [model codeListingToInstrictions];
    } else {
        self.programListing = [NSMutableArray arrayWithArray:[ProgramNgin instance].program];
    }
    if ([ngin programIsHalted] || [ngin programIsRunning]) {
       self.runImageView.hidden = YES;
    } else {
        self.runImageView.hidden = NO;
    }
    if (self.launchedFromMap) {
        if (self.view.alpha > kALPHA_MAX) {
            self.view.alpha = kALPHA_MAX;
            self.opacitySlider.value = 1.0;
        }
        self.programView.frame = CGRectMake(0.0, 105.0, 320.0, 375.0);
        self.opacityImage.hidden = NO;
        self.opacitySlider.hidden = NO;
        self.opacityLabel.hidden = NO;
    } else {
        self.view.alpha = 1.0;
        self.programView.frame = CGRectMake(0.0, 65.0, 320.0, 415.0);
        self.opacityImage.hidden = YES;
        self.opacitySlider.hidden = YES;
        self.opacityLabel.hidden = YES;
    }
    [self.programView reloadData];
    NSInteger selectedRow = self.selectedLine.row;
    if ((selectedRow + 1) == [self.programListing count]) {
        NSIndexPath* bottomLine = [NSIndexPath indexPathForRow:[self.programListing count] inSection:0];
        [self.programView scrollToRowAtIndexPath:bottomLine atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    ProgramNgin* ngin = [ProgramNgin instance];
    switch (touchTag) {
        case kTERMINAL_LAUNCHER_BACK_TAG:
            if (!self.launchedFromMap) {
                [[ViewControllerManager instance] showRepositoryView:[[CCDirector sharedDirector] openGLView]];
            }
            [self.view removeFromSuperview];
            [ngin saveProgram:self.programListing];
            break;
        case kTERMINAL_LAUNCHER_RUN_TAG:
            [ngin saveProgram:self.programListing];
            [[CCDirector sharedDirector] replaceScene: [UploadScene scene]];
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
        return [TerminalCellFactory tableView:tableView terminalCellForRowAtIndexPath:indexPath forInstructionSet:instructionSet andParentType:TerminalTerminalCellParentType];
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
    [[ViewControllerManager instance] showInstructionsView:[[CCDirector sharedDirector] openGLView] withInstructionType:TerminalPrimitiveInstructionType];
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

