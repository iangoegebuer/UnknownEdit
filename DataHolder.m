//
//  DataHolder.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DataHolder.h"
#import "UKGrp.h"


@implementation DataHolder

- (id)init
{
	self = [super init];
    if (self) {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSLog(@"Test%i ..",[[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"gridOn"]] isEqualTo:@"1"]);
		StarcraftData = [[MPQArchive alloc] initWithPath:[NSString stringWithFormat:@"%@/Starcraft Data",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"mpqPath"]]];
		BroodwarData = [[MPQArchive alloc] initWithPath:[NSString stringWithFormat:@"%@/Brood War Data",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"mpqPath"]]];
		NSLog(@" %p %p", StarcraftData,BroodwarData);
		[pool release];
	}
    return self;
}

- (NSString *)dataPath
{
	return path;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	
    if (returnCode == NSAlertFirstButtonReturn) {
		
		NSLog(@"No Data");
		
    }
	
}

- (BOOL)startLoad
{
	NSLog(@"Start");
	//com.edit.unknown
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if(StarcraftData == NULL || BroodwarData == NULL) {
	//	NSAlert *alert = [[[NSAlert alloc] initalertWithMessageText:(NSString *)messageTitle defaultButton:(NSString *)defaultButtonTitle alternateButton:(NSString *)alternateButtonTitle otherButton:(NSString *)otherButtonTitle informativeTextWithFormat:(NSString *)informativeText,  ...	//	[alert addButtonWithTitle:@"OK"];
		
	//	[alert addButtonWithTitle:@"Cancel"];
		
	//	[alert setMessageText:@"Delete the record?"];
		
	//	[alert setInformativeText:@"Deleted records cannot be restored."];
		
	//	[alert setAlertStyle:NSWarningAlertStyle];
		
		//[alert beginSheetModalForWindow:[searchField window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
		
	} else {
		//UKSCTilesSet *ins =[[UKSCTilesSet alloc] init];
		//[ins parseMicrotilesWithPallet:[BroodwarData dataForFile:@"tileset\\Twilight.wpe"] data:[BroodwarData dataForFile:@"tileset\\Twilight.vr4"]];
		//NSLog(@"%@",[ins parseTiles:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vx4",tileset]]]);
		//[ins parseTiles:[BroodwarData dataForFile:@"tileset\\Twilight.vx4"]];
		//[ins parseCV5:[BroodwarData dataForFile:@"tileset\\Twilight.cv5"]];
		
	units = [NSMutableArray arrayWithCapacity:1];
	
	NSData *palDat = [[NSBundle mainBundle] pathForResource:@"Units" ofType:@"pal"];
	unsigned char *unitDat = [[BroodwarData dataForFile:@"arr\\units.dat"] bytes];
	unsigned char *flingyDat = [[BroodwarData dataForFile:@"arr\\flingy.dat"] bytes];
	unsigned char *spriteDat = [[BroodwarData dataForFile:@"arr\\sprites.dat"] bytes];
	unsigned char *imageDat = [[BroodwarData dataForFile:@"arr\\images.dat"] bytes];
	unsigned char *tblPoint = [[BroodwarData dataForFile:@"arr\\images.tbl"] bytes];
	unsigned char *tblstring = [[BroodwarData dataForFile:@"arr\\images.tbl"] bytes];
	NSString *filename;
	UKGrp *testGRP = [UKGrp alloc];
	int i = 0;
	while(i < 265) {
	unsigned int tblPointIndex = i;
	tblPointIndex = (unitDat[tblPointIndex])*2;
	tblPointIndex = (flingyDat[tblPointIndex] + 0x100*flingyDat[tblPointIndex+1])*2;
	tblPointIndex = (spriteDat[tblPointIndex] + 0x100*spriteDat[tblPointIndex+1])*4;
	tblPointIndex = (imageDat[tblPointIndex] + 0x100*imageDat[tblPointIndex+1])*2;
	int strT = 0;
	while(tblstring[(tblPoint[tblPointIndex] + 0x100*tblPoint[tblPointIndex+1]) + strT] != 0x00) {
			//fileNameHolder[str] = tblstring[(tblPoint[tblPointIndex] + 0x100*tblPoint[tblPointIndex+1]) + str];
			//strcat(name, "test");
			//NSLog(@"File %s s",fileNameHolder);
		strT++;
		//tblstring = [[tbl subdataWithRange:NSMakeRange((tblPoint[0] + 0x100*tblPoint[1]) + str,1)] bytes];
		//str++;
		
	}
	unsigned char fileNameHolder[strT+1];
	
		//NSLog(@"TEST %i",strT);
	int str = 0;
	fileNameHolder[strT] = '\0';
	while(str < strT) {
		fileNameHolder[str] = tblstring[(tblPoint[tblPointIndex] + 0x100*tblPoint[tblPointIndex+1]) + str];
		//strcat(name, "test");
		//NSLog(@"File %s s",fileNameHolder);
		str++;
		//tblstring = [[tbl subdataWithRange:NSMakeRange((tblPoint[0] + 0x100*tblPoint[1]) + str,1)] bytes];
		//str++;
		
	}
	
	filename = [NSString stringWithFormat:@"%s",fileNameHolder];
	//NSLog(@" %@",filename);
	//UKGrp *testGRP = [UKGrp alloc];
	if([StarcraftData dataForFile:[NSString stringWithFormat:@"unit\\%@",filename]] != nil) {
		//[grpHolder setData:[MPQ dataForFile:[NSString stringWithFormat:@"unit\\%@",filename]] pal:@"unit"];
[units addObject:[testGRP loadAndCreate:[StarcraftData dataForFile:[NSString stringWithFormat:@"unit\\%@",filename]] pallet:[NSData dataWithContentsOfFile:palDat]]];		
//NSLog(@"GRP test: %@", [testGRP loadAndCreate:[StarcraftData dataForFile:[NSString stringWithFormat:@"unit\\%@",filename]] pallet:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Units" ofType:@"pal"]]]);
	} else {
		[units addObject:[testGRP loadAndCreate:[BroodwarData dataForFile:[NSString stringWithFormat:@"unit\\%@",filename]] pallet:[NSData dataWithContentsOfFile:palDat]]];
	}
	
	i++;
	}
	//UKGrp *testGRP = [UKGrp alloc];
	NSLog(@"GRP test: %@", [testGRP loadAndCreate:[StarcraftData dataForFile:@"unit\\terran\\marine.grp"] pallet:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Units" ofType:@"pal"]]]);
	[units retain];
	}
	[pool release];
	NSLog(@"End");
}


- (UKTileset *)loadTileset:(NSString *)tileset
{
//	NSLog(@"Start");
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UKTileset *ins = [UKTileset alloc];
	[ins setType:@"ins"];
	
	if(![StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.wpe",tileset]]) {
		[ins parseMicrotiles:[BroodwarData dataForFile:[NSString stringWithFormat:@"tileset\\%@.wpe",tileset]] data:[BroodwarData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vr4",tileset]]];
	//NSLog(@"%@",[ins parseTiles:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vx4",tileset]]]);
		[ins parseTiles2:[BroodwarData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vx4",tileset]]];
		[ins parseCV5:[BroodwarData dataForFile:[NSString stringWithFormat:@"tileset\\%@.cv5",tileset]]];
		
	} else {
	[ins parseMicrotiles:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.wpe",tileset]] data:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vr4",tileset]]];
	//NSLog(@"%@",[ins parseTiles:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vx4",tileset]]]);
	[ins parseTiles2:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.vx4",tileset]]];
	[ins parseCV5:[StarcraftData dataForFile:[NSString stringWithFormat:@"tileset\\%@.cv5",tileset]]];
	}
	//[pool release];
//	NSLog(@"End");
	return ins;
}

- (void)awakeFromNib 
{
	//[[self window] setAcceptsMouseMovedEvents:YES];
	NSLog(@"AWAKE22");
	//[self setBoundsSize:NSMakeSize(400,400)];
}

- (NSImage *)getUnit:(int)num color:(int)clr
{
	//NSImage *un = [[units objectAtIndex:num] objectAtIndex:clr];
	//NSImage *im = [[NSImage alloc] initWithSize:NSMakeSize([un size].width,[un size].height)];
	//[im lockFocus];
	NSLog(@" HMM %@ %i %i", [[units objectAtIndex:num] objectAtIndex:clr], YES, NO);
	//[[[un representations] objectAtIndex:clr] drawAtPoint:NSMakePoint(0,0)];
	 //representations] objectAtIndex:chunkHolder[chunkNum].data[currUnit * 36 + 16]
	//[im unlockFocus];
	return [[units objectAtIndex:num] objectAtIndex:clr];
}

- (BOOL)pathsCorrect
{
	if(StarcraftData == NULL || BroodwarData == NULL) return NO;
	return YES;
}

- (NSString *)setDataPaths:(NSString *)newPath
{
	path = newPath;
	[path retain];
	
	return path;
}
@end
