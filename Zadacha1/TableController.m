//
//  Controller.m
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"

@implementation TableController

@synthesize plist;
@synthesize arrayStrings;
@synthesize aTable;

#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"

- (IBAction)listStrings:(id)sender
{
	NSLog(@"List Strings to console");
	for (TableData *data in arrayStrings) 
	{
		NSLog(@"string %@", data.string);
	}
}

- (IBAction)writeStrings:(id)sender
{
	NSLog(@"Write Strings to File");
}

- (void)awakeFromNib
{
	NSString *path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
	NSFileManager *file = [NSFileManager defaultManager];
	
	if ([file fileExistsAtPath:path])
	{
		// read the file content, if exist
		// to NSDictionary
		plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		
		NSLog(@"NORMAL start: read existed plist file for array of strings %@", plist);
	}
	else
	{
		// create new file with random-generated string
		// and fill NSDictionary array
		NSString *letters  = @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"; // latin alphabet with numbers
		NSMutableArray *array = [[NSMutableArray alloc] init];
		srandom((unsigned)time(NULL)); // seed the random number generator
//		int i, j;
//		int num, len; // number of strings in array and lenght of string
		int num = ((int)random() % 10) + 1; // [1..10] ten strings in array is enough?
		for (int i = 0; i < num; i++) 
		{
			int len = ((int)random() % 100) + 1; // [1..100] hundred letters in string is enough?
			NSMutableString *string = [NSMutableString stringWithCapacity:len];
			for (int j = 0; j < len; j++)
			{
				unsigned long r = arc4random() % [letters length];
				unichar c = [letters characterAtIndex:r];
				[string appendFormat:@"%C", c];
			}
			// add the new string object to the array
			[array addObject:string];
		}
		
		plist = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, @"ArrayKey", @"Some string", @"StringKey", nil];
		[plist writeToFile:path atomically:NO];
		
		NSLog(@"FIRST start: created a new plist file with array of random-generated strings %@", plist);
		
		// done with array
		[array release];
	}
	
	// init our arrayStrings
	arrayStrings = [[NSMutableArray alloc] init];
/*	this init is leaked
	NSMutableArray *table = [[NSMutableArray alloc] init];
	table = [plist objectForKey:@"ArrayKey"];	*/
	NSMutableArray *table = [[NSMutableArray alloc] initWithArray:[plist objectForKey:@"ArrayKey"]];
	NSLog(@"Table loaded from plist %@", table);
	
	int idx = 0;
	// Note this loop. Here we are using Obj-C's mechanism for enumerating over the members of a collection
	for (NSMutableString *str in table) 
	{
		// Display its contents
		NSLog(@"at index: %d, string: %@", idx++ /* increase index */, str);
		// Adding strings from table to our array
//		[arrayStrings addObject:[[TableData alloc] init]]; // empty
//		[arrayStrings insertObject:[[TableData alloc] init] atIndex:[arrayStrings count]]; // empty
//		[arrayStrings addObject:[[TableData alloc] initWithString:str]]; // @"random-add"
//		[arrayStrings insertObject:[[TableData alloc] initWithString:str] atIndex:[arrayStrings count]]; // @"random-insert"
		
		TableData *data = [[TableData alloc] initWithString:str];
		[arrayStrings addObject:data];
		[data release]; // done with data
	}
	
	NSLog(@"arrayStrings loaded %@", arrayStrings);
	
	[table release]; // done with table
	
	[aTable registerForDraggedTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType]];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	if (aTableView == aTable) 
	{
		return [arrayStrings count];
	}
	return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if (aTableView == aTable) 
	{
		TableData *data = [arrayStrings objectAtIndex:rowIndex];
		return data.string;
	}
	return NULL;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if (aTableView == aTable) 
	{
		TableData *data = [arrayStrings objectAtIndex:rowIndex];
		data.string = (NSString *)anObject;
		[arrayStrings replaceObjectAtIndex:rowIndex withObject:data];
	}
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] owner:self];
	[pboard setData:indexData forType:MyPrivateTableViewDataType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard *pboard = [info draggingPasteboard];
	NSData *rowData = [pboard dataForType:MyPrivateTableViewDataType];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	NSInteger dragRow = [rowIndexes firstIndex];
	
	if (dragRow < row) 
	{
		[arrayStrings insertObject:[arrayStrings objectAtIndex:dragRow] atIndex:row];
		[arrayStrings removeObjectAtIndex:dragRow];
	}
	else
	{
		TableData *data = [arrayStrings objectAtIndex:dragRow];
		[[data retain] autorelease]; // set this before removeObjectAtIndex
		[arrayStrings removeObjectAtIndex:dragRow];
		[arrayStrings insertObject:data atIndex:row];
	}
	
	[self.aTable noteNumberOfRowsChanged];
	[self.aTable reloadData];
	return YES;
}

@end