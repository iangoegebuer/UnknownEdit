//
//  UKSCTilesSet.h
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
	unsigned char unknown[20];
	unsigned short tileNums[16];
} cv5Template;

typedef struct {
	unsigned short tileNums[16];
} cv5Holder;

@interface UKSCTilesSet : NSObject {
	unsigned char *microTiles;
	NSImage *tiles;
	cv5Holder *cv5;
}

-(BOOL)parseMicrotilesWithPallet:(NSData *)palData data:(NSData *)theData;
-(NSImage *)parseTiles:(NSData *)tileData;
-(unsigned char *)parseCV5:(NSData *)tilcv53;

@end
