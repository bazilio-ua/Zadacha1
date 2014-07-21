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
	NSTableView *aTable;
}

@property (assign) IBOutlet NSTableView *aTable;

- (IBAction)listStrings:(id)sender;
- (IBAction)writeStrings:(id)sender;
- (IBAction)addString:(id)sender;
- (IBAction)delString:(id)sender;

@end
