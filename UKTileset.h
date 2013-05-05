//
//  UKTileset.h
//  tester
//
//  Created by Ian Goegebuer on Sat May 26 2007.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//
#define __COREGRAPHICS__
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/NSBitmapImageRep.h>
#import <AppKit/AppKit.h>
//#include <ApplicationServices/Frameworks/CoreGraphics/CoreGraphics.h>

#import <ApplicationServices/ApplicationServices.h>
//@class NSArray, NSColor, NSImageRep, NSPasteboard, NSURL;

@interface UKTileset : NSObject 
{
//NSArray *colorArray;
//NSArray *tileArray;
//NSArray *cv5Array;
	NSString *type;
	NSImage *tiles;
	NSImage *tiles2;
	unsigned char *microTiles;
	unsigned char *cv5;
	int tileCount;
	
}

- (NSImage *) makePallet;
- (unsigned char *)getCV5;
-(void)setType:(NSString *)typee;
-(unsigned char *)parseCV5:(NSData *)tilData3;
//-(unsigned char *)parseCV5B:(NSData *)tilData3;
-(BOOL)parseMicrotiles:(NSData *)palData data:(NSData *)theData;
- (NSImage *)getTiles;
- (NSImage *)getTiles2;
-(NSImage *)parseTiles:(NSData *)tileData;
-(NSImage *)parseTiles2:(NSData *)tileData;
@end
