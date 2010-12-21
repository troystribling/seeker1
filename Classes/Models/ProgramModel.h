//
//  ProgramModel.h
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ProgramModel : NSObject {
    NSInteger pk;
    NSInteger level;
    NSString* codeListing;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, retain) NSString* codeListing;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)insertProgram:(NSMutableArray*)_program forLevel:(NSInteger)_level;
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (ProgramModel*)findByLevel:(NSInteger)_level;
+ (NSMutableArray*)findAll;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSArray*)codeListingToArray;

@end
