//
//  main.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <MPQ/MPQ.h>
#import "DataHolder.h"
//#import "SFmpqapi_no-lib.h"
//#include <stdio.h>

//#include <stdlib.h>

//#include <dlfcn.h>

//#include <string.h>
id dataHolder;
 


int main(int argc, char *argv[])
{
	dataHolder = [[DataHolder alloc] init];
	[dataHolder setDataPaths:@"Blarge"];
	[dataHolder startLoad];
	[dataHolder retain];
		
	
    return NSApplicationMain(argc, (const char **) argv);
}
