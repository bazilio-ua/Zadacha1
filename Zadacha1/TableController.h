//
//  Controller.h
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableData.h"

void writePlist (void);
NSString *generateRandomString (void);

@interface TableController : NSObjectController
{
//	NSMutableArray *arrayStrings;
	NSTableView *aTable;
}
/*
@property (retain) NSString *path;
@property (retain) NSFileManager *file;
@property (retain) NSMutableDictionary *plist;	*/
//@property (assign) NSMutableArray *arrayStrings;
//@property (retain) NSMutableArray *arrayStrings;
@property (assign) IBOutlet NSTableView *aTable;

//- (void)writePlist;
- (IBAction)listStrings:(id)sender;
- (IBAction)writeStrings:(id)sender;
- (IBAction)addString:(id)sender;
- (IBAction)delString:(id)sender;

@end
