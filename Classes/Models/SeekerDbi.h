//
//  SeekerDbi.h
//  seeker1
//
//  Created by Troy Stribling on 12/19/10.
//  Copyright 2010 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <sqlite3.h>

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SeekerDbi : NSObject {
	sqlite3* sqlDb;
	NSString* dbFilePath;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (assign) sqlite3* sqlDb;
@property (retain) NSString* dbFilePath;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (SeekerDbi*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)copyDbFile;
- (void)close;
- (BOOL)open;
- (void)updateWithStatement:(NSString*)statement;
- (NSInteger)selectIntExpression:(NSString*)statement;
- (NSString*)selectTextColumn:(NSString*)statement;
- (NSArray*)selectAllTextColumn:(NSString*)statement;
- (void)selectForModel:(id)model withStatement:(NSString*)statement andOutputTo:(id)result;
- (void)selectAllForModel:(id)model withStatement:(NSString*)statement andOutputTo:(NSMutableArray*)results;
- (void)logError:(NSString*)statement;

@end

//===================================================================================================================================
#pragma mark -

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSObject (SeekerDbiDelegate)

+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output;
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output;

@end
