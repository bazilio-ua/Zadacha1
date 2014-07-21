//
//  Controller.m
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"

NSString *path;
NSFileManager *file;
NSMutableDictionary *plist;
NSMutableArray *arrayStrings;

void writePlist (void)
{
	path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	NSLog(@"Write Strings to File");
	for (TableData *data in arrayStrings) 
	{
		NSLog(@"write string %@", data.string);
		// add the new string object to the array
		[array addObject:data.string];
	}
	
	plist = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, @"ArrayKey", @"Some string", @"StringKey", nil];
	[plist writeToFile:path atomically:NO];
	
	NSLog(@"WRITE: a new plist file: %@ with array of strings %@", path, plist);
	
	// done with array
	[array release];
}

NSMutableString *generateRandomString (void)
{
	NSString *letters  = @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"; // latin alphabet with numbers
//	srandom((unsigned)time(NULL)); // seed the random number generator
	int len = ((int)random() % 100) + 1; // [1..100] hundred letters in string is enough?
	NSMutableString *string = [NSMutableString stringWithCapacity:len];
	for (int j = 0; j < len; j++)
	{
		unsigned long r = arc4random() % [letters length];
		unichar c = [letters characterAtIndex:r];
		[string appendFormat:@"%C", c];
	}
	return string;
}

@implementation TableController
/*
@synthesize path;
@synthesize file;
@synthesize plist;	*/
//@synthesize arrayStrings;
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
/*
- (void)writePlist
{
	path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	NSLog(@"Write Strings to File");
	for (TableData *data in arrayStrings) 
	{
		NSLog(@"write string %@", data.string);
		// add the new string object to the array
		[array addObject:data.string];
	}
	
	plist = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, @"ArrayKey", @"Some string", @"StringKey", nil];
	[plist writeToFile:path atomically:NO];
	
	NSLog(@"WRITE: a new plist file: %@ with array of strings %@", path, plist);
	
	// done with array
	[array release];
}
*/
- (IBAction)writeStrings:(id)sender
{
//	[self writePlist];
	writePlist();
}

- (IBAction)addString:(id)sender
{
	NSInteger index = [aTable selectedRow];
	NSLog(@"index: %ld", index);
	
//	[arrayStrings addObject:[[TableData alloc] initWithString:@"random-add"]]; // @"random-add" // this is leak
	
//	TableData *data = [[TableData alloc] initWithString:@"random-add"];
	TableData *data = [[TableData alloc] initWithString:generateRandomString()]; // @"random-add"
	if (index != -1)
	{
		[arrayStrings insertObject:data atIndex:index];
	}
	else
	{
		[arrayStrings addObject:data];
	}
	[data release]; // done with data

	[aTable noteNumberOfRowsChanged];
	[aTable reloadData];
	
	NSLog(@"add");

/*
//	[arrayStrings addObject:[[TableData alloc] initWithString:@"random-add"]]; // @"random-add" // this is leak
	
//	TableData *data = [[TableData alloc] initWithString:@"random-add"];
	TableData *data = [[TableData alloc] initWithString:generateRandomString()]; // @"random-add"
	[arrayStrings addObject:data];
	[data release]; // done with data

	[aTable reloadData];
	
	NSLog(@"add");	*/
}

- (IBAction)delString:(id)sender
{
	NSIndexSet *enumerator = [aTable selectedRowIndexes];
	NSUInteger index = [enumerator firstIndex];
	NSMutableArray *tempArray = [NSMutableArray array];
	id tempObject;
	
	while (index != NSNotFound) 
	{
		//work with current index
		tempObject = [arrayStrings objectAtIndex:index]; // No modification, no problem
		//get the next index in the set
		index = [enumerator indexGreaterThanIndex:index];
		[tempArray addObject:tempObject]; // keep track of the record to delete in tempArray
	}
	
	[arrayStrings removeObjectsInArray:tempArray];
	
	[aTable noteNumberOfRowsChanged];
	[aTable reloadData];
	
	NSLog(@"del");

//this variant is deprecated
/*	NSEnumerator *enumerator = [aTable selectedRowEnumerator];
	NSNumber *index;
	NSMutableArray *tempArray = [NSMutableArray array];
	id tempObject;
	
	while (index = [enumerator nextObject]) 
	{
		tempObject = [arrayStrings objectAtIndex:[index intValue]]; // No modification, no problem
		[tempArray addObject:tempObject]; // keep track of the record to delete in tempArray
	}
	
	[arrayStrings removeObjectsInArray:tempArray];
	
	[aTable reloadData];
	
	NSLog(@"del");	*/
}

- (void)awakeFromNib
{
//	NSString *path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
//	NSFileManager *file = [NSFileManager defaultManager];
	srandom((unsigned)time(NULL)); // seed the random number generator
	path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
	file = [NSFileManager defaultManager];
	
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
//		srandom((unsigned)time(NULL)); // seed the random number generator
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
	NSLog(@"numberOfRowsInTableView");
	if (aTableView == aTable) 
	{
		return [arrayStrings count];
	}
	return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSLog(@"objectValueForTableColumn");
	if (aTableView == aTable) 
	{
		TableData *data = [arrayStrings objectAtIndex:rowIndex];
		return data.string;
	}
	return NULL;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSLog(@"setObjectValue");
	if (aTableView == aTable) 
	{
		TableData *data = [arrayStrings objectAtIndex:rowIndex];
		data.string = (NSString *)anObject;
		[arrayStrings replaceObjectAtIndex:rowIndex withObject:data];
	}
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSLog(@"writeRowsWithIndexes");
	NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] owner:self];
	[pboard setData:indexData forType:MyPrivateTableViewDataType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	NSLog(@"validateDrop");
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSLog(@"acceptDrop");
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
		[[data retain] autorelease]; // set this before removeObjectAtIndex (retain it until insertObject)
		[arrayStrings removeObjectAtIndex:dragRow];
		[arrayStrings insertObject:data atIndex:row];
	}
	
	[self.aTable noteNumberOfRowsChanged];
	[self.aTable reloadData];
	return YES;
}

@end
