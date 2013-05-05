//
//  CHKMap.h
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UKTileset.h"
#define MAX_CHUNKS 150
#define MAX_UNITS 600
#define MAX_STRINGS 100

typedef struct {
	int offset;
	int length;
	unsigned char name[5];
	unsigned char *data;
} chunk;

typedef struct {
	int length;
	char text[100];
} stringType;

typedef struct {
	NSRect area;
	char *name;
	char ats[2];
} locationType;
typedef struct {
	int unitID;
	//int unitID;
	int player;
} unitProp;

typedef struct {
	NSRect area;
	//int unitID;
	NSImage *image;
	unitProp props;
} unitType;



@interface CHKMap : NSObject {
	int chunkCount;
	BOOL arrayMade;
	unsigned char *cv5;
	int era;
	int width;
	int height;
	int totalLength;
	int unitOffset;
	int stringCount;
	NSMutableData *dataContainer;
	NSMutableArray *unitsArray;
	chunk *chunkHolder;
	NSRange mtxmRange;
	stringType *stringHolder;
	//unitType *testUnitsArray;
	@private
		unsigned char *bites;
}
- (void)updateLocation:(int)c withRect:(NSRect)aRect andAts:(const char*)ats;
- (void)updateUnit:(int)c withUnit:(unitType)aUnit;
- (NSMutableArray *) retUnits;
- (void)changeSize:(NSSize)dim withTile:(int)tilNum;
- (int)getTileAt:(NSPoint)at;
- (locationType *)getLocations;
- (id)initWithData:(NSData *)aData;
- (NSImage *)createTerrain:(UKTileset *)tileset;
- (BOOL) placeAtX:(int)x andY:(int)y brushW:(int)brushW andH:(int)brushH tid:(int)tid;
- (NSString *)tileset;
- (NSMutableData *)getData;
- (BOOL)importTriggers;
- (char *)getTitle;
- (char *)getDesc;
- (NSImage *)createUnits;
- (unitType *)createUnitsTest;
- (void)deleteUnit:(int)unitToK;
- (char *)decodeStringNumber:(int)c;
- (int)decodeStrings;
- (BOOL)exportTriggers;
- (void)placeUnitAt:(NSPoint)at uid:(int)unitId player:(int)curPlayer settings:(NSDictionary *)data;
@end
