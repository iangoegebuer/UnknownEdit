//
//  MyDocument.h
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
//#import <AppKit/NSAlert.h>
#import <MPQ/MPQ.h>
#import "DataHolder.h"
#import "UKTileset.h"
#import "MapView.h"
#import "CHKMap.h"



@interface MyDocument : NSDocument
{	
    IBOutlet id brushSize;
    IBOutlet id grpImage;
    IBOutlet id heightBox;
    IBOutlet id imagething;
    IBOutlet id mapView;
    IBOutlet id myOutlet;
    IBOutlet id namBox;
    IBOutlet id palletView;
    IBOutlet id pptWindow;
    IBOutlet id tileBox;
    IBOutlet id tilesetBox;
    IBOutlet id trigWin;
    IBOutlet id unitIdBox;
    IBOutlet id unitPallet;
    IBOutlet id widthBox;
	IBOutlet NSUserDefaultsController *UIControl;
	MPQArchive *theData;
	UKTileset *tileset;
	NSImage *tiles;
	NSImage *map;
	NSImage *unitIm;
	CHKMap *mapHolder;
	NSString *lastpath;
	locationType *locats;
	unitType *unitAr;
	int player;
	int layer;
	int brushW;
	int brushH;
}
- (void)updateLocation:(int)c withRect:(NSRect)aRect andAts:(const char*)ats;
- (void)updateUnit:(int)c withUnit:(unitType)aUnit;
- (void)getTileAt:(NSPoint)at;
- (void)placeUnitAt:(NSPoint)at;
- (NSImage *)placeTile:(NSPoint)at;
- (void)unitProp:(int)c forUnit:(unitType)aUnit;
- (void)locProp:(int)c forLocation:(locationType)aLoc;
- (void)testMeNow;
- (void)openTrig;
- (void)openUnitPallet;
- (void)setPlayer:(int)playerNum;
- (void)setLayer:(int)layerNum;
- (void)setMapSize:(NSSize)dim;
- (void)deleteUnit:(int)unitToK;
- (IBAction)increaseBrush:(id)sender;
- (IBAction)triggerImEx:(id)sender;
- (IBAction)changeUnitIm:(id)sender;
- (IBAction)startPlaceUnit:(id)sender;
@end
