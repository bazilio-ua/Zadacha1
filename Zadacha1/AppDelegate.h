//
//  AppDelegate.h
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TableData.h"
#import "TableController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
