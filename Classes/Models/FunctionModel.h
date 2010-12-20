//
//  FunctionModel.h
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
@interface FunctionModel : NSObject {
    NSInteger pk;
    NSString* codeListing;
    NSString* functionName;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSString* codeListing;
@property (nonatomic, retain) NSString* functionName;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (FunctionModel*)loadFunction:(NSMutableArray*)_function withName:(NSString*)_name;
+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (void)destroyAll;
+ (FunctionModel*)findByName:(NSString*)_name;
+ (NSMutableArray*)findAll;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)insert;
- (void)destroy;
- (void)load;
- (void)update;
- (NSArray*)codeListingToArray;

@end
