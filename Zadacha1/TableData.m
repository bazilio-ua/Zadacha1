//
//  Data.m
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TableData.h"

@implementation TableData

- (id)init
{
	return [self initWithString:@"empty string"];
}

- (void)dealloc
{
	NSLog(@"deallocate %@", self);
	[string release];
	[super dealloc];
}

- (id)initWithString:(NSString *)str
{
	self = [super init];
	if (self) 
	{
		string = [str retain];
	}
	return self;
}

- (NSString *)string
{
	return string;
}

- (void)setString:(NSString *)str
{
	[str retain];
	[string release];
	string = str;
}

- (NSString *)description
{
//	return [self string];
	return [NSString stringWithFormat:@"%@", [self string]];
}

@end
