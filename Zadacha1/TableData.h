//
//  Data.h
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableData : NSObject
{
	NSString *string;
}

//@property (retain) NSString *string;

- (id)initWithString:(NSString *)str;

- (NSString *)string;
- (void)setString:(NSString *)str;

@end
