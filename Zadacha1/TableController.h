//
//  Controller.h
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableData.h"

@interface TableController : NSObjectController

@property (retain) NSMutableDictionary *plist;
//@property (assign) NSMutableArray *arrayStrings;
@property (retain) NSMutableArray *arrayStrings;
@property (assign) IBOutlet NSTableView *aTable;

- (IBAction)listStrings:(id)sender;
- (IBAction)writeStrings:(id)sender;

@end
