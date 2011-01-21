//
//  CodeModel.h
//  seeker1
//
//  Created by Troy Stribling on 1/20/11.
//  Copyright 2011 imaginary products. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>

//-----------------------------------------------------------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CodeModel : NSObject {

}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (NSString*)instructionsToCodeListing:(NSMutableArray*)_instructionSets;
+ (NSMutableArray*)codeListingToInstructions:(NSString*)_listing;
+ (NSMutableArray*)codeListingToDoInstructions:(NSArray*)_instructionSetStrings;


@end
