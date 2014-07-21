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
		[array addObject:data.string];
	}
	
	plist = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, @"ArrayKey", @"Some string", @"StringKey", nil];
	[plist writeToFile:path atomically:NO];
	
	NSLog(@"WRITE: a new plist file: %@ with array of strings %@", path, plist);
	
	[array release]; // done with array
}

NSMutableString *generateRandomString (void)
{
	NSString *letters  = @" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"; // space and latin alphabet with numbers
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
	writePlist();
}

- (IBAction)addString:(id)sender
{
	NSInteger index = [aTable selectedRow];
	NSLog(@"index: %ld", index);
	
	TableData *data = [[TableData alloc] initWithString:generateRandomString()];
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
		tempObject = [arrayStrings objectAtIndex:index]; // no modification
		//get the next index in the set
		index = [enumerator indexGreaterThanIndex:index];
		[tempArray addObject:tempObject]; // keep track of the record to delete in tempArray
	}
	
	[arrayStrings removeObjectsInArray:tempArray];
	
	[aTable noteNumberOfRowsChanged];
	[aTable reloadData];
	
	NSLog(@"del");
}

- (void)awakeFromNib
{
	srandom((unsigned)time(NULL)); // seed the random number generator
	path = [@"~/TableStore.plist" stringByExpandingTildeInPath];
	file = [NSFileManager defaultManager];
	
	if ([file fileExistsAtPath:path])
	{
		plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		
		NSLog(@"NORMAL start: read existed plist file for array of strings %@", plist);
	}
	else
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		int num = ((int)random() % 10) + 1; // [1..10] ten strings in array is enough?
		for (int i = 0; i < num; i++) 
		{
			[array addObject:generateRandomString()];
		}
		
		plist = [NSMutableDictionary dictionaryWithObjectsAndKeys:array, @"ArrayKey", @"Some string", @"StringKey", nil];
		[plist writeToFile:path atomically:NO];
		
		NSLog(@"FIRST start: created a new plist file with array of random-generated strings %@", plist);
		
		[array release]; // done with array
	}
	
	arrayStrings = [[NSMutableArray alloc] init];
	
	NSMutableArray *table = [[NSMutableArray alloc] initWithArray:[plist objectForKey:@"ArrayKey"]];
	NSLog(@"Table loaded from plist %@", table);
	
	int idx = 0;
	for (NSMutableString *str in table) 
	{
		NSLog(@"at index: %d, string: %@", idx++ /* increase index */, str);
		
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
//	NSLog(@"numberOfRowsInTableView");
	if (aTableView == aTable) 
	{
		return [arrayStrings count];
	}
	return 0;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
//	NSLog(@"objectValueForTableColumn");
	NSString* ident = [aTableColumn identifier];
	if ([ident isEqual:@"strings"])
	{
		if (aTableView == aTable) 
		{
			TableData *data = [arrayStrings objectAtIndex:rowIndex];
			return data.string;
		}
		return NULL;
	}
	else if ([ident isEqual:@"image"])
	{
		NSString *imgpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"objc.png"];		
		NSImage *image =  [[NSImage alloc] initWithContentsOfFile:imgpath];

		[image autorelease]; //done with image
		return image;
	}
	else
		return NULL;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
//	NSLog(@"setObjectValue");
	if (aTableView == aTable) 
	{
		TableData *data = [arrayStrings objectAtIndex:rowIndex];
		data.string = (NSString *)anObject;
		[arrayStrings replaceObjectAtIndex:rowIndex withObject:data];
	}
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
//	NSLog(@"writeRowsWithIndexes");
	NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] owner:self];
	[pboard setData:indexData forType:MyPrivateTableViewDataType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
//	NSLog(@"validateDrop");
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
//	NSLog(@"acceptDrop");
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
