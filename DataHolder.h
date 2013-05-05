//
//  DataHolder.h
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MPQ/MPQ.h>
//#import <UKSCFiles/UKSCTilesSet.h>
#import "UKTileset.h"

@interface DataHolder : NSObject {
	MPQArchive *StarcraftData;
	MPQArchive *BroodwarData;
	NSString *path;
	NSMutableArray *units;
}

- (NSString *)dataPath;
- (BOOL)pathsCorrect;
- (NSImage *)getUnit:(int)num color:(int)clr;
- (NSString *)setDataPaths:(NSString *)newPath;
- (UKTileset *)loadTileset:(NSString *)tileset;
- (BOOL)startLoad;

@end
