//
//  MyDocument.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/2/08.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "MyDocument.h"
//#import "main.m"

extern id dataHolder;
@implementation MyDocument

//int testHolder;
- (id)init
{
    self = [super init];
    if (self) {
		//NSLog(@"Hmm %@ ",[dataHolder dataPath]);
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		NSLog(@"Rand %i", 33);
    }
    return self;
}

- (NSString *)windowNibName
{
	
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
	
}

- (void)testMeNow
{
	
	NSLog(@"The test worked!");
}

- (IBAction)updateMap:(id)sender
{
	NSLog(@"The test worked!");
	[mapHolder changeSize:NSMakeSize([[widthBox selectedItem] tag],[[heightBox selectedItem] tag]) withTile:[tileBox intValue] era:[[tilesetBox selectedItem] tag]];
	tileset = [dataHolder loadTileset:[mapHolder tileset]];
	//tiles = [tileset getTiles];
	[tileset retain];
	map = [mapHolder createTerrain:tileset];
	NSLog(@"DONE");
	unitIm = [mapHolder createUnits];
	NSLog(@"DONE");
	[imagething setImage:map];
	NSLog(@"DONE");
	//[mapView setBoundsSize:[map size]];
	[mapView setImage:map units:unitIm array:[mapHolder retUnits] withLocations:locats];
	NSLog(@"DONE");
}

- (void)setMapSize:(NSSize)dim;
{
	[pptWindow orderFront:nil];
}

- (void)openTrig
{
	[trigWin orderFront:nil];
	NSLog(@"The test worked!");
}

- (void)openUnitPallet
{
	[unitPallet orderFront:nil];
	NSLog(@"The test worked!");
}

- (void)setLayer:(int)layerNum
{
	layer = layerNum;
	if(layer == 0) {
		[[UIControl values] setValue:[NSString stringWithFormat:@"%i",0] forKey:@"selectedTab"];
	[unitPallet orderFront:nil];
	} else if(layer == 3) {
		[[UIControl values] setValue:[NSString stringWithFormat:@"%i",1] forKey:@"selectedTab"];
		[unitPallet orderOut:nil];
	} else {
		[[UIControl values] setValue:[NSString stringWithFormat:@"%i",2] forKey:@"selectedTab"];
		[unitPallet orderOut:nil];
	}
		[mapView setLayer:layerNum];
	NSLog(@"The layer has been set to: %i",layerNum);
}

- (void)setPlayer:(int)playerNum
{
	player = playerNum-1;
	NSLog(@"The player has been set to: %i",playerNum);
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{

    [super windowControllerDidLoadNib:aController];
	
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	if(![dataHolder pathsCorrect]) {
	NSAlert *alert = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"The path(%@) to the starcraft data specified in the preferences cannot be read. \r\rPlease correct the path in the preferences and restart UnKnownEdit",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"mpqPath"]];
	[alert runModal];
	}
	NSLog(@"HMM %@",[[UIControl values] valueForKey:@"winVis"]);
	[[UIControl values] setValue:@"false" forKey:@"winVis"];
	layer = 1;
	brushW = 1;
	brushH = 1;
	[mapView updateBrushW:brushW andH:brushH];
	[mapView setLayer:1];
	[[UIControl values] setValue:[NSString stringWithFormat:@"%i",2] forKey:@"selectedTab"];
	[self showWindows];
	//[self setDocumentView: mapView];
	[imagething setImage:map];
	//[mapView setBoundsSize:[map size]];
	if(map != NULL) [mapView setImage:map units:NULL array:unitAr withLocations:locats];
	[palletView setPImage:[tileset makePallet]];
	[[UIControl values] setValue:[NSString stringWithFormat:@"%s",[mapHolder getTitle]] forKey:@"scnPropTitle"];
	//[[UIControl values] setValue:@"Destroy" forKey:@"scnPropDesc"];
//	[mapView setBoundsSize:[map size]];

}


/*- (NSData *)dataRepresentationOfType:(NSString *)aType
{
	NSLog(@"%@ aType",aType);
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    return theData;
} */

- (NSImage *)placeTile:(NSPoint)at
{
	[mapHolder placeAtX:(int)at.x andY:(int)at.y brushW:brushW andH:brushH tid:[tileBox intValue]];
	/*NSImage *tile = [[NSImage alloc] initWithSize:NSMakeSize(32,32)];
	[tile lockFocus];
	int totalTiles = [tiles size].height/32;
	unsigned char *cv5 = [tileset getCV5];
	//s = ((bites[i*2+offset] + bites[i*2+offset+1]*0x100));
	int n = (cv5[17*2+2] + 0x100*cv5[17*2+3]);
	//x = (i%64)*32;
	//y = (63-floor(i/64))*32;
	if(n >= totalTiles) [tiles compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(32,(totalTiles-(n-totalTiles)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*2) [tiles compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(64,(totalTiles-(n-totalTiles*2)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*3) [tiles compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(96,(totalTiles-(n-totalTiles*3)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n < totalTiles) [tiles compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(0,(totalTiles-n-1)*32, 32, 32) operation:NSCompositeSourceOver];
	[tile unlockFocus];*/
	return [tileset getTileById:[tileBox intValue]];
}

- (void)getTileAt:(NSPoint)at
{
	[tileBox setIntValue:[mapHolder getTileAt:at]];
}


- (BOOL)writeToFile:(NSString *)fileName ofType:(NSString *)aType
{
	//NSLog(@"%@ %@ %i", [imagething image], [tileset getTiles],[theData writeToFile:[theData path] atomically:NO]);
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
//    [theData writeToFile:fileName atomically:YES];
//	[mapView setBoundsSize:NSMakeSize(400,400)];
	[theData release];
	theData = [[MPQArchive alloc] initWithPath:lastpath];
	[theData retain];
	NSMutableData *dataH = [mapHolder getData];
	if ([theData deleteFile:@"staredit\\scenario.chk"] == NO)
		NSLog(@"Brokenzor %i %@", [dataH length], [@"staredit/scenario.chk" stringByReplacingSlashWithBackslash]);
	if ([theData addFileWithData:[NSData dataWithBytes:[dataH bytes] length:[dataH length]] name:@"staredit\\scenario.chk" attributes:nil] == NO)
		NSLog(@"Brokens %i %@", [theData writeToFile:fileName atomically:YES], fileName);
	[theData release];
	theData = [[MPQArchive alloc] initWithPath:fileName];
	[theData retain];
	//lastpath = fileName;
	//MPQArchive *testarch = [[MPQArchive alloc] initWithPath:lastpath];
	//[testarch addFileWithData:[NSData dataWithBytes:[dataH bytes] length:[dataH length]] name:[@"staredit/scenario.chk" stringByReplacingBackslashWithSlash] attributes:nil];
	//[testarch writeToFile:fileName atomically:YES];
		return YES;
}

- (void)deleteUnit:(int)unitToK {
	//memmove (str+20,str+15,11);
	[mapHolder deleteUnit:unitToK];
	NSLog(@"HMM %i",[[UIControl values] valueForKey:@"unitID"]);
	
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)aType
{
	NSLog(@"Start");
	
	theData = [[MPQArchive alloc] initWithPath:fileName];
	[theData retain];
	mapHolder = [[CHKMap alloc] initWithData:[theData dataForFile:@"staredit\\scenario.chk"]];
	[mapHolder decodeStringNumber:3];
	tileset = [dataHolder loadTileset:[mapHolder tileset]];
	//tiles = [tileset getTiles];
	[tileset retain];
	//test = [[tileset getTiles2] retain];
	//tileset = [dataHolder loadTileset:@"Badlands"];
	//[[[tileset getTiles] TIFFRepresentation] writeToFile:@"/games/testimage.tiff" atomically:YES];
	//NSLog(@"%@ %@", [imagething image], test);
	lastpath = fileName;
	//[palletView setPImage:[tileset makePallet]];
	map = [mapHolder createTerrain:tileset];
	//unitIm = [mapHolder createUnits];
	unitAr = [mapHolder createUnitsTest];
	//unitsArray = [mapHolder retUnits];
	NSLog(@"End %@", [mapHolder tileset]);
	
	locats = [mapHolder getLocations];
	[mapHolder retain];
	[map retain];
	
	//[tiles retain];
	
//	NSLog(@"%@ %@",[mapHolder createTerrain:tileset],mapHolder);
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    return YES;
}
/*- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	theData = data;
	[theData retain];
	NSLog(@"%@", aType);
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    return YES;
}*/

- (IBAction)increaseBrush:(id)sender {
	if([sender tag] == 0) brushW = [sender intValue];
	if([sender tag] == 1) brushH = [sender intValue];
	
	NSLog(@"Value of %i :%i %@",[sender tag], [sender intValue],[NSString stringWithFormat:@"& %i x %i",brushW,brushH]);
	[brushSize setTitleWithMnemonic:[NSString stringWithFormat:@"& %i x %i",brushW,brushH]];
	[mapView updateBrushW:brushW andH:brushH];
	//[NSString stringWithFormat:@"%i x %i",brushW,brushH]
}

- (IBAction)updateUnit:(id)sender
{
	if(layer == 0) {
		
	NSLog(@"Updated %i", [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"playerNum"]] intValue]);
	unitType *unitSel = [mapView currUnit];
	unitSel->props.player = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"playerNum"]] intValue];
	unitSel->props.unitID = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"unitID"]] intValue];
	unitSel->image = [dataHolder getUnit:[[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"unitID"]] intValue] color:[[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"playerNum"]] intValue]];
	unitSel->area.size = [unitSel->image size];
	//unitSel->area.origin = NSMakePoint(
	[mapHolder updateUnit:[mapView currUnitNum] withUnit:*unitSel];
	[mapView setNeedsDisplay:YES];
	}
	if(layer == 3) {
		NSLog(@"Updated %i %@",~(char)(([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"] == nil) + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"]] isEqualTo:@"true"] + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMG"] == nil)*2 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMG"]] isEqualTo:@"true"]*2 + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHG"] == nil)*4 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"]] isEqualTo:@"true"]*4), [NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMA"]]);
		//[[UIControl values] setValue:@"yes" forKey:@"locLG"];
			locationType *unitSel = [mapView currLoc];
		
		unitSel->ats[0] = (([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"] == nil) + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"]] isEqualTo:@"0"] + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMG"] == nil)*2 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMG"]] isEqualTo:@"0"]*2 + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHG"] == nil)*4 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHG"]] isEqualTo:@"0"]*4+ ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLA"] == nil)*8 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLA"]] isEqualTo:@"0"]*8);
		//unitSel->ats[1] = (([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMA"] == nil) + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMA"]] isEqualTo:@"1"] + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHA"] == nil)*2 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHA"]] isEqualTo:@"1"]*2);
		unitSel->ats[1] = (([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMA"] == nil) + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locMA"]] isEqualTo:@"0"] + ([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHA"] == nil)*2 + [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locHA"]] isEqualTo:@"0"]*2);
		//unitSel->props.player = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"playerNum"]] intValue];
		//unitSel->props.unitID = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"unitID"]] intValue]; [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locLG"]] isEqualTo:@"true"]
		//unitSel->image = [dataHolder getUnit:[[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"unitID"]] intValue] color:[[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"playerNum"]] intValue]];
		unitSel->area.size.width = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locW"]] intValue];
		unitSel->area.size.height = [[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"locH"]] intValue];
		//unitSel->area.origin = NSMakePoint(
		//[mapHolder updateUnit:[mapView currUnitNum] withUnit:*unitSel];
		[mapHolder updateLocation:[mapView currUnitNum] withRect:unitSel->area andAts:&(unitSel->ats)];
		[mapView setNeedsDisplay:YES];
	}
}

- (IBAction)triggerImEx:(id)sender {
	if([sender tag] == 0) [mapHolder exportTriggers];
	if([sender tag] == 1) [mapHolder importTriggers];
	//[NSString stringWithFormat:@"%i x %i",brushW,brushH]
}
- (IBAction)changeUnitIm:(id)sender {
	[grpImage setImage:[dataHolder getUnit:[sender intValue] color:player]];
	//[NSString stringWithFormat:@"%i x %i",brushW,brushH]
}

- (IBAction)startPlaceUnit:(id)sender {
	//[grpImage setImage:[dataHolder getUnit:[sender intValue] color:1]];
	//[NSString stringWithFormat:@"%i x %i",brushW,brushH]
	NSLog(@"State %i",rand() % 200);
	
	[mapView startPlacing:NULL player:1 uid:1];
	if([sender state] == 1) [mapView startPlacing:[dataHolder getUnit:[unitIdBox intValue] color:player] player:player uid:[unitIdBox intValue]];
}

-(void)placeUnitAt:(NSPoint)at
{
	[mapHolder placeUnitAt:at uid:[unitIdBox intValue] player:player settings:NULL];
}
- (void)updateUnit:(int)c withUnit:(unitType)aUnit
{
	[mapHolder updateUnit:c withUnit:aUnit];
}
- (void)updateLocation:(int)c withRect:(NSRect)aRect andAts:(const char*)ats
{
	[mapHolder updateLocation:c withRect:aRect andAts:ats];
}

- (void)unitProp:(int)c forUnit:(unitType)aUnit
{
	[[UIControl values] setValue:@"true" forKey:@"winVis"];
	NSLog(@"HMM %@",[[UIControl values] valueForKey:@"winVis"]);
	NSLog(@"Unit props");
	
	if(c != -1) {
		[[UIControl values] setValue:[NSString stringWithFormat:@"%i",aUnit.props.player] forKey:@"playerNum"];
	[[UIControl values] setValue:[NSString stringWithFormat:@"%i",aUnit.props.unitID] forKey:@"unitID"];
	[[UIControl values] setValue:[NSString stringWithFormat:@"%i",c] forKey:@"unitNum"];
	}
}

- (void)locProp:(int)c forLocation:(locationType)aLoc
{
	[[UIControl values] setValue:@"true" forKey:@"winVis"];
	//NSLog(@"HMM %@",[[UIControl values] valueForKey:@"locHG"]);
	NSLog(@"Location props %i",aLoc.ats[0] & 8);
	[[UIControl values] setValue:@"0" forKey:@"locLG"];
	[[UIControl values] setValue:@"0" forKey:@"locMG"];
	[[UIControl values] setValue:@"0" forKey:@"locHG"];
	[[UIControl values] setValue:@"0" forKey:@"locLA"];
	[[UIControl values] setValue:@"0" forKey:@"locMA"];
	[[UIControl values] setValue:@"0" forKey:@"locHA"];
	
	
	if(c != -1) {
		[[UIControl values] setValue:[NSString stringWithFormat:@"%f",aLoc.area.origin.x] forKey:@"locX"];
		[[UIControl values] setValue:[NSString stringWithFormat:@"%f",aLoc.area.origin.y] forKey:@"locY"];
		[[UIControl values] setValue:[NSString stringWithFormat:@"%f",aLoc.area.size.width] forKey:@"locW"];
		[[UIControl values] setValue:[NSString stringWithFormat:@"%f",aLoc.area.size.height] forKey:@"locH"];
		[[UIControl values] setValue:[NSString stringWithFormat:@"%i",c] forKey:@"locNum"];
		[[UIControl values] setValue:[NSString stringWithFormat:@"%s",aLoc.name] forKey:@"locName"];
		if((aLoc.ats[0] & 1) == 0) [[UIControl values] setValue:@"1" forKey:@"locLG"];
		if((aLoc.ats[0] & 2) == 0) [[UIControl values] setValue:@"1" forKey:@"locMG"];
		if((aLoc.ats[0] & 4) == 0) [[UIControl values] setValue:@"1" forKey:@"locHG"];
		if((aLoc.ats[0] & 8) == 0) [[UIControl values] setValue:@"1" forKey:@"locLA"];
		if((aLoc.ats[1] & 1) == 0) [[UIControl values] setValue:@"1" forKey:@"locMA"];
		if((aLoc.ats[1] & 2) == 0) [[UIControl values] setValue:@"1" forKey:@"locHA"];
	}
}

@end
