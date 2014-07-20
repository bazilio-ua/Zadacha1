//
//  AppDelegate.m
//  Zadacha1
//
//  Created by Basil Nikityuk on 7/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

- (void)dealloc
{
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	// place here code to write out ours strings to file
	writePlist();
	NSLog(@"applicationShouldTerminate");
	return NSTerminateNow;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	NSLog(@"applicationShouldTerminateAfterLastWindowClosed");
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	NSLog(@"applicationWillTerminate");
}

- (void)applicationWillUpdate:(NSNotification *)aNotification
{
//	NSLog(@"applicationWillUpdate");
}

- (void)applicationDidUpdate:(NSNotification *)aNotification
{
//	NSLog(@"applicationDidUpdate");
}

@end
