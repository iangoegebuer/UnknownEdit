//
//  CHKMap.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 8/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHKMap.h"

extern id dataHolder;
@implementation CHKMap
- (id)initWithData:(NSData *)aData
{
	self = [super init];
    if (self) {
		chunkCount = 0;
		dataContainer = [NSMutableData dataWithLength:[aData length]];
		[dataContainer setData:aData];
		[dataContainer retain];
		bites = (unsigned char *)[dataContainer mutableBytes];
		int i = 0;
		int c = 0;
		unsigned char *name = malloc(5);
		name[4] = '\0';
		//mapWidth = 64;
		unsigned int length = 0;
		while(i < [aData length]) {
			i += 4;
			length = bites[i+0] + (bites[i+1] * 0x100) + (bites[i+2] * 0x10000) + (bites[i+3] * 0x1000000);
			i += 4;
			//if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"MTXM"]) mtxmRange = NSMakeRange(i,length);
		//	printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n } \r\n",name,length);
			i += length;
			c++;
		}
		chunkCount = c;
		chunkHolder = (chunk*)malloc(c * sizeof(chunk));
		i = 0;
		c = 0;
		//chunks = (chunk *)malloc((c+1)* sizeof(chunk));
		//chunk chky[c];
		while(i < [aData length]) {
			//name = malloc(5);
			
			name[4] = '\0';
			name[0] = bites[i];
			name[1] = bites[i+1];
			name[2] = bites[i+2];
			name[3] = bites[i+3];
			chunkHolder[c].name[4] = '\0';
			chunkHolder[c].name[0] = bites[i];
			chunkHolder[c].name[1] = bites[i+1];
			chunkHolder[c].name[2] = bites[i+2];
			chunkHolder[c].name[3] = bites[i+3];
			//chunkHolder[c].name = name;
			i += 4;
			length = bites[i+0] + (bites[i+1] * 0x100) + (bites[i+2] * 0x10000) + (bites[i+3] * 0x1000000);
			i += 4;
		//	printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n } \r\n",name,length);
			//if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"TRIG"]) [[dataContainer subdataWithRange:NSMakeRange(i,length)] writeToFile:@"/testtrg" atomically:NO];
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"ERA "]) era = bites[i];
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"DIM "]) width = bites[i] + 0x100*bites[i+1];
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"DIM "]) height = bites[i+2] + 0x100*bites[i+3];
					
			chunkHolder[c].length = length;
			chunkHolder[c].offset = i;
			if(![[NSString stringWithFormat:@"%s",name] isEqualTo:@"UNIT"] && ![[NSString stringWithFormat:@"%s",name] isEqualTo:@"STR "] && ![[NSString stringWithFormat:@"%s",name] isEqualTo:@"MTXM"]) {
				chunkHolder[c].data = malloc(length);
				memcpy(chunkHolder[c].data,(unsigned char *)[[dataContainer subdataWithRange:NSMakeRange(i,length)] bytes],length);
			}
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"UNIT"]) {
				chunkHolder[c].data = malloc(MAX_UNITS * 36);
				memcpy(chunkHolder[c].data,(unsigned char *)[[dataContainer subdataWithRange:NSMakeRange(i,length)] bytes],length);
			}
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"STR "]) {
				chunkHolder[c].data = malloc(MAX_STRINGS * 102 + 2);
				memcpy(chunkHolder[c].data,(unsigned char *)[[dataContainer subdataWithRange:NSMakeRange(i,length)] bytes],length);
			}
			if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"MTXM"]) {
				chunkHolder[c].data = malloc(256*256*2);
				memcpy(chunkHolder[c].data,(unsigned char *)[[dataContainer subdataWithRange:NSMakeRange(i,length)] bytes],length);
			}
// [dataContainer getBytes:chunkHolder[c].data range:NSMakeRange(i,length)];
			//if([[NSString stringWithFormat:@"%s",name] isEqualTo:@"UNIT"]) era = bites[i];
//chunkHolder[c].name = name;
//offsets[c] = i;
			//lengths[c] = length;
			//names[c] = name;
			if([[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"debug"]) printf(" Chunk \r\n { \r\n Name: %s; \r\n Length: %i; \r\n } \r\n",chunkHolder[c].name,length,chunkHolder[c].data);
			i += length;
			c++;
		}
		totalLength = i;
		stringCount = [self decodeStrings];
		
    }
    return self;
}

- (id)init
{
	self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)description
{
	return @"Bleh";
}

- (NSImage *)createUnits
{
	NSImage *unitIm = [[NSImage alloc] initWithSize:NSMakeSize(width*32,height*32)];
	NSLog(@"Hmm %i", arrayMade);
	NSImage *im;
	unitsArray = [NSMutableArray arrayWithCapacity:1];
	unitType *testUnitsArray = malloc(MAX_UNITS*sizeof(unitType));
	/*
	 Units array format
	 Code
	 ID
	 x
	 y
	 color image
	 
	 
	 typedef struct {
		 NSRect area;
		 int unitID;
		 NSImage *image;
	 } unitType;
	 
	 */
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	int currUnit = 0;
	[unitIm lockFocus];
	while(currUnit < chunkHolder[chunkNum].length/36) {
		//NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
		//imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		//CGContextDrawImage((CGContextRef)[[NSGraphicsContext currentContext] graphicsPort], *(CGRect*)&imageRect, [[[[dataHolder getUnit:(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])] representations] objectAtIndex:chunkHolder[chunkNum].data[currUnit * 36 + 16]] CGImage]);
		if((chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9]) < 265) {
			im = [dataHolder getUnit:(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9]) color:chunkHolder[chunkNum].data[currUnit * 36 + 16]];
			[unitsArray addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])],[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 1])],[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])],[NSString stringWithFormat:@"%i",height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7])],[NSString stringWithFormat:@"%i",chunkHolder[chunkNum].data[currUnit * 36 + 16]],im,nil]];
			//[im drawRepresentation:[[im representations] objectAtIndex:chunkHolder[chunkNum].data[currUnit * 36 + 16]] inRect:NSMakeRect((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])  - [im size].width/2,height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]) - [im size].height/2, 64,64)];
			testUnitsArray[currUnit].image = im;
			testUnitsArray[currUnit].area = NSMakeRect((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5]), height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]),[im size].width,[im size].height);
			
			[im compositeToPoint:NSMakePoint((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])  - [im size].width/2,height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]) - [im size].height/2) operation:NSCompositeSourceOver];
		}
		//[mapView addUnit:(currUnit[currUnit2 * 36+8] + 0x100*currUnit[currUnit2 * 36+9]) atX:(currUnit[currUnit2 * 36+4] + 0x100*currUnit[currUnit2 * 36+5]) andY:(currUnit[currUnit2 * 36+6] + 0x100*currUnit[currUnit2 * 36+7]) owner:currUnit[currUnit2 * 36+16] code:(currUnit[currUnit2 * 36] + 0x100*currUnit[currUnit2 * 36+1] + 0x100*0x100*currUnit[currUnit2 * 36+2] + 0x100*0x100*0x100*currUnit[currUnit2 * 36+3]) image:[[unitImages objectAtIndex:(currUnit[currUnit2 * 36+8] + 0x100*currUnit[currUnit2 * 36+9])] objectAtIndex:currUnit[currUnit2 * 36+16]] addData:NULL];
		currUnit++;
	}
	[unitIm unlockFocus];
	[unitsArray retain];
	return unitIm;
	
}

- (unitType *)createUnitsTest
{
	//NSImage *unitIm = [[NSImage alloc] initWithSize:NSMakeSize(width*32,height*32)];
	NSLog(@"Hmm %i", arrayMade);
	NSImage *im;
	unitsArray = [NSMutableArray arrayWithCapacity:1];
	unitType *testUnitsArray = malloc(MAX_UNITS*sizeof(unitType));
	/*
	 Units array format
	 Code
	 ID
	 x
	 y
	 color image
	 
	 
	 typedef struct {
		 NSRect area;
		 int unitID;
		 NSImage *image;
	 } unitType;
	 
	 */
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	int currUnit = 0;
	//[unitIm lockFocus];
	while(currUnit < chunkHolder[chunkNum].length/36) {
		//NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
		//imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		//CGContextDrawImage((CGContextRef)[[NSGraphicsContext currentContext] graphicsPort], *(CGRect*)&imageRect, [[[[dataHolder getUnit:(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])] representations] objectAtIndex:chunkHolder[chunkNum].data[currUnit * 36 + 16]] CGImage]);
		if((chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9]) < 265) {
			im = [dataHolder getUnit:(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9]) color:chunkHolder[chunkNum].data[currUnit * 36 + 16]];
			[unitsArray addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])],[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 1])],[NSString stringWithFormat:@"%i",(chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])],[NSString stringWithFormat:@"%i",height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7])],[NSString stringWithFormat:@"%i",chunkHolder[chunkNum].data[currUnit * 36 + 16]],im,nil]];
			//[im drawRepresentation:[[im representations] objectAtIndex:chunkHolder[chunkNum].data[currUnit * 36 + 16]] inRect:NSMakeRect((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])  - [im size].width/2,height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]) - [im size].height/2, 64,64)];
			testUnitsArray[currUnit].image = im;
			testUnitsArray[currUnit].area = NSMakeRect((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5]) - [im size].width/2,height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]) - [im size].height/2, [im size].width, [im size].height);
			testUnitsArray[currUnit].props.player = chunkHolder[chunkNum].data[currUnit * 36 + 16];
			testUnitsArray[currUnit].props.unitID = (chunkHolder[chunkNum].data[currUnit * 36 + 8] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9]);
			//[im compositeToPoint:NSMakePoint((chunkHolder[chunkNum].data[currUnit * 36 + 4] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 5])  - [im size].width/2,height*32-(chunkHolder[chunkNum].data[currUnit * 36 + 6] + 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 7]) - [im size].height/2) operation:NSCompositeSourceOver];
		}
		//testUnitsArray[currUnit].image = im;
		//testUnitsArray[currUnit].area = NSMakeRect(100,100,100,100);
		//[mapView addUnit:(currUnit[currUnit2 * 36+8] + 0x100*currUnit[currUnit2 * 36+9]) atX:(currUnit[currUnit2 * 36+4] + 0x100*currUnit[currUnit2 * 36+5]) andY:(currUnit[currUnit2 * 36+6] + 0x100*currUnit[currUnit2 * 36+7]) owner:currUnit[currUnit2 * 36+16] code:(currUnit[currUnit2 * 36] + 0x100*currUnit[currUnit2 * 36+1] + 0x100*0x100*currUnit[currUnit2 * 36+2] + 0x100*0x100*0x100*currUnit[currUnit2 * 36+3]) image:[[unitImages objectAtIndex:(currUnit[currUnit2 * 36+8] + 0x100*currUnit[currUnit2 * 36+9])] objectAtIndex:currUnit[currUnit2 * 36+16]] addData:NULL];
		currUnit++;
	}
	return testUnitsArray;
}

- (void)updateUnit:(int)c withUnit:(unitType)aUnit
{
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MGRN") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	unsigned char le[4];
	
	NSPoint at2 = NSMakePoint(aUnit.area.origin.x + aUnit.area.size.width/2, height*32 - aUnit.area.origin.y - aUnit.area.size.height/2);
	NSLog(@"Update Unit:%i (%f,%f)",c, at2.x, at2.y);
	//int editNum = chunkHolder[chunkNum].length;
	//chunkHolder[chunkNum].length += 36;
	//chunkHolder[chunkNum].data[c + 9] = (char)floor(unitId/0x100);
	//chunkHolder[chunkNum].data[c + 8] = unitId - 0x100*chunkHolder[chunkNum].data[editNum + 9];
	//chunkHolder[chunkNum].data[c + 16] = curPlayer;
	chunkHolder[chunkNum].data[c*36 + 5] = (char)floor(at2.x/0x100);
	chunkHolder[chunkNum].data[c*36 + 4] = floor(at2.x) - 0x100*chunkHolder[chunkNum].data[c*36 + 5];
	chunkHolder[chunkNum].data[c*36 + 7] = (char)floor(at2.y/0x100);
	chunkHolder[chunkNum].data[c*36 + 6] = floor(at2.y) - 0x100*chunkHolder[chunkNum].data[c*36 + 7];
	//chunkHolder[chunkNum].data[c*36 + 5] = (char)floor(at2.x/0x100);
	chunkHolder[chunkNum].data[c*36 + 16] = aUnit.props.player;
	chunkHolder[chunkNum].data[c*36 + 9] = (char)floor(aUnit.props.unitID/0x100);
	chunkHolder[chunkNum].data[c*36 + 8] = aUnit.props.unitID - 0x100*chunkHolder[chunkNum].data[c*36 + 9];
	
	
	//chunkHolder[chunkNum].data[c*20+18] = ats[0];
	//chunkHolder[chunkNum].data[c*20+19] = ats[1];
	
}

- (void)placeUnitAt:(NSPoint)at uid:(int)unitId player:(int)curPlayer settings:(NSDictionary *)data
{
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	NSPoint at2 = NSMakePoint(at.x, height*32 - at.y);
	int editNum = chunkHolder[chunkNum].length;
	chunkHolder[chunkNum].length += 36;
	chunkHolder[chunkNum].data[editNum + 9] = (char)floor(unitId/0x100);
	chunkHolder[chunkNum].data[editNum + 8] = unitId - 0x100*chunkHolder[chunkNum].data[editNum + 9];
	chunkHolder[chunkNum].data[editNum + 16] = curPlayer;
	chunkHolder[chunkNum].data[editNum + 5] = (char)floor(at.x/0x100);
	chunkHolder[chunkNum].data[editNum + 4] = floor(at.x) - 0x100*chunkHolder[chunkNum].data[editNum + 5];
	chunkHolder[chunkNum].data[editNum + 7] = (char)floor(at2.y/0x100);
	chunkHolder[chunkNum].data[editNum + 6] = floor(at2.y) - 0x100*chunkHolder[chunkNum].data[editNum + 7];
		//+ 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])
}

- (char *)decodeStringNumber:(int)c
{
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"STR ") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	//NSPoint at2 = NSMakePoint(at.x, height*32 - at.y);
	//int editNum = chunkHolder[chunkNum].length;
	///chunkHolder[chunkNum].length += 36;
	//chunkHolder[chunkNum].data[editNum + 9] = (char)floor(unitId/0x100);
	//chunkHolder[chunkNum].data[editNum + 8] = unitId - 0x100*chunkHolder[chunkNum].data[editNum + 9];
	//chunkHolder[chunkNum].data[editNum + 16] = curPlayer;
	//chunkHolder[chunkNum].data[editNum + 5] = (char)floor(at.x/0x100);
	//chunkHolder[chunkNum].data[editNum + 4] = floor(at.x) - 0x100*chunkHolder[chunkNum].data[editNum + 5];
	//chunkHolder[chunkNum].data[editNum + 7] = (char)floor(at2.y/0x100);
	//chunkHolder[chunkNum].data[editNum + 6] = floor(at2.y) - 0x100*chunkHolder[chunkNum].data[editNum + 7];
	if(c < stringCount) NSLog(@"String #%i: %s",c, (stringHolder[c].text));
	if(c < stringCount) return (stringHolder[c].text);
	if(c >= stringCount) return NULL;
	//+ 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])
}

- (int)decodeStrings
{
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"STR ") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	stringHolder = malloc(MAX_STRINGS * sizeof(stringType));
	int c = 0;
	int j = 0;
	while(c < chunkHolder[chunkNum].data[0] + 0x100*chunkHolder[chunkNum].data[1]) {
		j = 0;
		while(chunkHolder[chunkNum].data[j + chunkHolder[chunkNum].data[c*2] + 0x100*chunkHolder[chunkNum].data[1+c*2]] != 0) {
			j++;
		}
		NSLog(@"String #%i:(Length:%i) %s",c,j,&chunkHolder[chunkNum].data[chunkHolder[chunkNum].data[c*2] + 0x100*chunkHolder[chunkNum].data[1+c*2]]);
		stringHolder[c].length = j;
		if(j < 100) memcpy(stringHolder[c].text,&chunkHolder[chunkNum].data[chunkHolder[chunkNum].data[c*2] + 0x100*chunkHolder[chunkNum].data[1+c*2]],j+1);
		c++;
		
	}
	//if(c < chunkHolder[chunkNum].data[0] + 0x100*chunkHolder[chunkNum].data[1]) NSLog(@"String #%i: %s",c,&chunkHolder[chunkNum].data[chunkHolder[chunkNum].data[c*2] + 0x100*chunkHolder[chunkNum].data[1+c*2]]);
	return c;
	//+ 0x100*chunkHolder[chunkNum].data[currUnit * 36 + 9])
}

- (NSImage *)createTerrain:(UKTileset *)tileset
{ 
	
	NSImage *tiles = [tileset getTiles];
	NSLog(@"Map size %i %i",height,width);
	//NSImage *tiles2 = [tileset getTiles2];
	cv5 = [tileset getCV5];
	int totalTiles = [tiles size].height/32;
	int offset = mtxmRange.location;
	int i = 0;
	int ii = 0;
	int chunkNum = 0;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"MTXM") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	NSLog(@"DONE");
	NSArray *reps = [tiles representations];
	//[[reps objectAtIndex:(cv5[(r)*2+2] + 0x100*cv5[(r)*2+3])] drawAtPoint:NSMakePoint(x,y)];
//	NSLog(@"GO! %i %i %i %s %s",offset,chunks[3].start,chunks[3].length,chunks[3].name,chunks[4].name);
	NSImage *terrain = [[NSImage alloc] initWithSize:NSMakeSize(width*32,height*32)];
	[terrain lockFocus];
	int x,y;
	i = 0;
	int nn = 0;
	int n = 0;
	int s = 0;
	while(i < height*width) {
		//int offset = mtxmRange.location;
		//if(bites[i*2+offset] != chunkHolder[chunkNum].data[i*2]) printf("Error in reading\r\n");
		s = ((chunkHolder[chunkNum].data[i*2] + chunkHolder[chunkNum].data[i*2+1]*0x100))*2;
		n = (cv5[s+2] + 0x100*cv5[s+3]);
		x = (i%width)*32;
		y = (height-1-floor(i/width))*32;
	//	nn = floor(n/totalTiles);
		[[reps objectAtIndex:n] drawAtPoint:NSMakePoint(x,y)];
		//[tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(nn*32,(totalTiles-(n-(totalTiles*nn))-1)*32, 32, 32) operation:NSCompositeSourceOver];
		/*if(n >= totalTiles) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(32,(totalTiles-(n-totalTiles)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		if(n >= totalTiles*2) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(64,(totalTiles-(n-totalTiles*2)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		if(n >= totalTiles*3) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(96,(totalTiles-(n-totalTiles*3)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		if(n >= totalTiles*4) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(128,(totalTiles-(n-totalTiles*4)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		if(n >= totalTiles*5) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(160,(totalTiles-(n-totalTiles*5)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		if(n < totalTiles) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(0,(totalTiles-n-1)*32, 32, 32) operation:NSCompositeSourceOver]; */
		//if(n < totalTiles) NSLog(@"1 %i %i %i %i",x,y,n,i);
	//	if(n > totalTiles) NSLog(@"39941 %i	%i	%i	%i	%i	%i",n,(totalTiles-(n-totalTiles)-1)*32,(n-totalTiles),(totalTiles-(s%totalTiles)-1),totalTiles,s);
		
//[[self makeTileById:j] compositeToPoint:NSMakePoint((k/2) * 32, (mapHeight*32 - 32) -l*32) operation:NSCompositeSourceOver];
		i++;
		//NSLog(@"DONE %i", i);
	}
	//[tiles2 compositeToPoint:NSMakePoint(0,0) operation:NSCompositeSourceOver];
	[terrain unlockFocus];
	[tiles release];
	NSLog(@"DONER");
//	[tiles2 release];
	return terrain;
}

- (NSMutableArray *) retUnits
{
	
	return unitsArray;
}

- (void)changeSize:(NSSize)dim withTile:(int)tilNum era:(int)newEra
{
	int i = 0;
	int chunkNum = 0;
	while(i < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[i].name,"MTXM") == 0) chunkNum = i;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		i++;
	}
	NSLog(@"ROAR");
	int length = dim.width*2*dim.height;
	unsigned char *newDat = malloc(length);
	NSLog(@"ROAR");
	i = 0;
	int a = 0;
	NSLog(@"ROAR");
	while(i < (int)dim.height) {
		a = 0;
		NSLog(@" i: %i a: %i",i,a);
		while(a < (int)dim.width) {
			if(i%2 == 0) {
			newDat[(int)(i*dim.width*2 + a*2)] = tilNum - 0x100*(int)floor(tilNum/0x100);
			newDat[(int)(i*dim.width*2 + a*2) + 1] = (int)floor(tilNum/0x100);
			} else {
				newDat[(int)(i*dim.width*2 + a*2)] = tilNum - 0x100*(int)floor(tilNum/0x100) + 16;
				newDat[(int)(i*dim.width*2 + a*2) + 1] = (int)floor(tilNum/0x100);
			}
			if(a < width && i < height) newDat[(int)floor(i*(int)dim.width*2 + a*2)] = chunkHolder[chunkNum].data[(int)floor(i*(int)width*2 + a*2)];
			if(a < width && i < height) newDat[(int)floor(i*(int)dim.width*2 + a*2 + 1)] = chunkHolder[chunkNum].data[(int)floor(i*(int)width*2 + a*2 + 1)];
			a++;
			
		}
		i++;
		
	}
	width = dim.width;
	height = dim.height;
	//chunkHolder[c].length = length;
	NSLog(@"DONE");
	memcpy(chunkHolder[chunkNum].data,newDat,length);
	NSLog(@"DONE");
	chunkHolder[chunkNum].length = length;
	NSLog(@"DONE");
	i = 0;
	while(i < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[i].name,"DIM ") == 0) chunkNum = i;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		i++;
	}
	chunkHolder[chunkNum].data[1] = width - 0x100*(int)floor(width/0x100);
	chunkHolder[chunkNum].data[2] = (int)floor(width/0x100);
	chunkHolder[chunkNum].data[3] = height - 0x100*(int)floor(height/0x100);
	chunkHolder[chunkNum].data[4] = (int)floor(height/0x100);
	i = 0;
	while(i < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[i].name,"ERA ") == 0) chunkNum = i;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		i++;
	}
	chunkHolder[chunkNum].data[1] = newEra;
	era = newEra;
}


- (BOOL) placeAtX:(int)x andY:(int)y brushW:(int)brushW andH:(int)brushH tid:(int)tid
{
//NSLog(@"%i %i %i %i",code[0],code[1],(y - 1)*mapWidth*2,x*2);
//[mtxmData replaceBytesInRange:NSMakeRange((y - 1)*mapWidth*2 + x*2,2) withBytes:code];
//[mtxmData retain];
	int ii = 0;
	int chunkNum = 0;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"MTXM") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	int offset = mtxmRange.location;
	//NSLog(@"X %i", tid);
	int c = 0;
	int a = 0;
	int i = ((height - (y) -1)*width*2 + x*2);
	//while(c < brushH) {
		a = 0;
		//while(a < brushW) {
	//NSLog(@"X %i %i", x, i);
			i = ((height - (y-c) -1)*width*2 + (x+a)*2);
			//bites[i+1] = (int)floor(tid/0x100);
			//bites[i] = tid - (bites[i] * 0x100);
			chunkHolder[chunkNum].data[i+1] = (int)floor(tid/0x100);
			chunkHolder[chunkNum].data[i] = tid - (chunkHolder[chunkNum].data[i+1] * 0x100);
			a++;
	//	}
		c++;
	//}
	//NSLog(@"X %i %i", bites[i], bites[i+1]);
	return YES;
}
- (NSString *)tileset
{
	switch(era%8) {
		case 0:
			return @"Badlands";
			break;
		case 1:
			return @"platform";
			break;
		case 2:
			return @"intall";
			break;
		case 3:
			return @"AshWorld";
			break;
		case 4:
			return @"Jungle";
			break;
		case 5:
			return @"Desert";
			break;
		case 6:
			return @"ice";
			break;
		case 7:
			return @"Twilight";
			break;
	}
}

- (void)deleteUnit:(int)unitToK {
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"UNIT") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	//NSPoint at2 = NSMakePoint(at.x, height*32 - at.y);
	//int editNum = chunkHolder[chunkNum].length;
	chunkHolder[chunkNum].length -= 36;
	//chunkHolder[chunkNum].data[editNum + 9] = (char)floor(unitId/0x100);
	
	memmove(chunkHolder[chunkNum].data+unitToK*36,chunkHolder[chunkNum].data+unitToK*36 + 36,chunkHolder[chunkNum].length - unitToK*36);
	
}

- (void)updateLocation:(int)c withRect:(NSRect)aRect andAts:(const char*)ats
{
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MGRN") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"MRGN") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	unsigned char le[4];
	NSPoint start = NSMakePoint(aRect.origin.x,height*32 - (aRect.origin.y + aRect.size.height));
	NSPoint end = NSMakePoint(aRect.origin.x + aRect.size.width,height*32 - (aRect.origin.y));
	le[3] = floor(start.x/0x1000000);
	le[2] = floor((start.x - (le[3] * 0x1000000))/0x10000);
	le[1] = floor((start.x - (le[3] * 0x1000000) - (le[2] *0x10000))/0x100);
	le[0] = start.x - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
	chunkHolder[chunkNum].data[c*20+0] = le[0];
	chunkHolder[chunkNum].data[c*20+1] = le[1];
	chunkHolder[chunkNum].data[c*20+2] = le[2];
	chunkHolder[chunkNum].data[c*20+3] = le[3];
	le[3] = floor(start.y/0x1000000);
	le[2] = floor((start.y - (le[3] * 0x1000000))/0x10000);
	le[1] = floor((start.y - (le[3] * 0x1000000) - (le[2] *0x10000))/0x100);
	le[0] = start.y - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
	chunkHolder[chunkNum].data[c*20+4] = le[0];
	chunkHolder[chunkNum].data[c*20+5] = le[1];
	chunkHolder[chunkNum].data[c*20+6] = le[2];
	chunkHolder[chunkNum].data[c*20+7] = le[3];
	le[3] = floor(end.x/0x1000000);
	le[2] = floor((end.x - (le[3] * 0x1000000))/0x10000);
	le[1] = floor((end.x - (le[3] * 0x1000000) - (le[2] *0x10000))/0x100);
	le[0] = end.x - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
	chunkHolder[chunkNum].data[c*20+8] = le[0];
	chunkHolder[chunkNum].data[c*20+9] = le[1];
	chunkHolder[chunkNum].data[c*20+10] = le[2];
	chunkHolder[chunkNum].data[c*20+11] = le[3];
	le[3] = floor(end.y/0x1000000);
	le[2] = floor((end.y - (le[3] * 0x1000000))/0x10000);
	le[1] = floor((end.y - (le[3] * 0x1000000) - (le[2] *0x10000))/0x100);
	le[0] = end.y - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
	chunkHolder[chunkNum].data[c*20+12] = le[0];
	chunkHolder[chunkNum].data[c*20+13] = le[1];
	chunkHolder[chunkNum].data[c*20+14] = le[2];
	chunkHolder[chunkNum].data[c*20+15] = le[3];
	chunkHolder[chunkNum].data[c*20+18] = ats[0];
	chunkHolder[chunkNum].data[c*20+19] = ats[1];
	
}

- (char *)getDesc {
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MGRN") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"SPRP") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	return [self decodeStringNumber:((chunkHolder[chunkNum].data[2]) + (chunkHolder[chunkNum].data[3] * 0x100))];
}

- (char *)getTitle {
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MGRN") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"SPRP") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	return [self decodeStringNumber:((chunkHolder[chunkNum].data[0]) + (chunkHolder[chunkNum].data[1] * 0x100))];
}


- (locationType *)getLocations {
	int ii = 0;
	int chunkNum = 0;
	int offset;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MGRN") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"MRGN") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	//NSPoint at2 = NSMakePoint(at.x, height*32 - at.y);
	//int editNum = chunkHolder[chunkNum].length;
	//chunkHolder[chunkNum].length -= 36;
	if(chunkHolder[chunkNum].length < 255*20){
		unsigned char *newLocs = malloc(5100);
		memcpy(newLocs,chunkHolder[chunkNum].data,chunkHolder[chunkNum].length);
		chunkHolder[chunkNum].data = newLocs;
		chunkHolder[chunkNum].length = 5100;
	}
	//chunkHolder[chunkNum].data[editNum + 9] = (char)floor(unitId/0x100);
	locationType *locs = malloc(sizeof(locationType)*(chunkHolder[chunkNum].length/20));
	NSLog(@"Length :%i %i %i",chunkHolder[chunkNum].length, chunkNum, sizeof(locationType));
	if(chunkHolder[chunkNum].length > 19) {
		int c = 0;
		unsigned char test[4];
		while(c < chunkHolder[chunkNum].length/20) {
			//test[0] = ((chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000)) % 0x1010000 - ((chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000)) % 0x1010100)) / 0x100; 
			//NSLog(@"Location #%u: start(%u,%u) end(%u,%u) name:",test[0], chunkHolder[chunkNum].data[c*20+1] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000),chunkHolder[chunkNum].data[c*20+4] + (chunkHolder[chunkNum].data[c*20+5] * 0x100) + (chunkHolder[chunkNum].data[c*20+6] * 0x10000) + (chunkHolder[chunkNum].data[c*20+7] * 0x1000000),chunkHolder[chunkNum].data[c*20+8] + (chunkHolder[chunkNum].data[c*20+9] * 0x100) + (chunkHolder[chunkNum].data[c*20+10] * 0x10000) + (chunkHolder[chunkNum].data[c*20+11] * 0x1000000),chunkHolder[chunkNum].data[c*20+12] + (chunkHolder[chunkNum].data[c*20+13] * 0x100) + (chunkHolder[chunkNum].data[c*20+14] * 0x10000) + (chunkHolder[chunkNum].data[c*20+15] * 0x1000000));
			locs[c].area = NSMakeRect(chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000),height*32 - (chunkHolder[chunkNum].data[c*20+4] + (chunkHolder[chunkNum].data[c*20+5] * 0x100) + (chunkHolder[chunkNum].data[c*20+6] * 0x10000) + (chunkHolder[chunkNum].data[c*20+7] * 0x1000000)) + (chunkHolder[chunkNum].data[c*20+4] + (chunkHolder[chunkNum].data[c*20+5] * 0x100) + (chunkHolder[chunkNum].data[c*20+6] * 0x10000) + (chunkHolder[chunkNum].data[c*20+7] * 0x1000000)) - (chunkHolder[chunkNum].data[c*20+12] + (chunkHolder[chunkNum].data[c*20+13] * 0x100) + (chunkHolder[chunkNum].data[c*20+14] * 0x10000) + (chunkHolder[chunkNum].data[c*20+15] * 0x1000000)), -1*(chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000)) + (chunkHolder[chunkNum].data[c*20+8] + (chunkHolder[chunkNum].data[c*20+9] * 0x100) + (chunkHolder[chunkNum].data[c*20+10] * 0x10000) + (chunkHolder[chunkNum].data[c*20+11] * 0x1000000)), -1*(chunkHolder[chunkNum].data[c*20+4] + (chunkHolder[chunkNum].data[c*20+5] * 0x100) + (chunkHolder[chunkNum].data[c*20+6] * 0x10000) + (chunkHolder[chunkNum].data[c*20+7] * 0x1000000)) + (chunkHolder[chunkNum].data[c*20+12] + (chunkHolder[chunkNum].data[c*20+13] * 0x100) + (chunkHolder[chunkNum].data[c*20+14] * 0x10000) + (chunkHolder[chunkNum].data[c*20+15] * 0x1000000)));
			//sprintf(locs[c].name, "(#%d) %s", c, [self decodeStringNumber:((chunkHolder[chunkNum].data[c*20+16]) + (chunkHolder[chunkNum].data[c*20+17] * 0x100))]); 
		//	[self decodeStringNumber:((chunkHolder[chunkNum].data[c*20+16]) + (chunkHolder[chunkNum].data[c*20+17] * 0x100))];
			locs[c].ats[0] = chunkHolder[chunkNum].data[c*20+18];
			locs[c].ats[1] = chunkHolder[chunkNum].data[c*20+19];
			locs[c].name = [self decodeStringNumber:((chunkHolder[chunkNum].data[c*20+16]) + (chunkHolder[chunkNum].data[c*20+17] * 0x100))];
			NSLog(@"Name %i", locs[c].ats[0] & 4);
			// -1*(chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000)) + (chunkHolder[chunkNum].data[c*20+8] + (chunkHolder[chunkNum].data[c*20+9] * 0x100) + (chunkHolder[chunkNum].data[c*20+10] * 0x10000) + (chunkHolder[chunkNum].data[c*20+11] * 0x1000000)), -1*(chunkHolder[chunkNum].data[c*20+4] + (chunkHolder[chunkNum].data[c*20+5] * 0x100) + (chunkHolder[chunkNum].data[c*20+6] * 0x10000) + (chunkHolder[chunkNum].data[c*20+7] * 0x1000000)) + (chunkHolder[chunkNum].data[c*20+12] + (chunkHolder[chunkNum].data[c*20+13] * 0x100) + (chunkHolder[chunkNum].data[c*20+14] * 0x10000) + (chunkHolder[chunkNum].data[c*20+15] * 0x1000000))
			//chunkHolder[chunkNum].data[c*20+0] + (chunkHolder[chunkNum].data[c*20+1] * 0x100) + (chunkHolder[chunkNum].data[c*20+2] * 0x10000) + (chunkHolder[chunkNum].data[c*20+3] * 0x1000000);
			c++;
		}
	}
	//memmove(chunkHolder[chunkNum].data+unitToK*36,chunkHolder[chunkNum].data+unitToK*36 + 36,chunkHolder[chunkNum].length - unitToK*36);
	return locs;
}
- (int)getTileAt:(NSPoint)at
{
	int ii = 0;
	int chunkNum = 0;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		if(strcmp(chunkHolder[ii].name,"MTXM") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	
	//int offset = mtxmRange.location;
	int i = at.x + (height - at.y - 1)*width;
	int s = ((chunkHolder[chunkNum].data[i*2] + chunkHolder[chunkNum].data[i*2+1]*0x100));
	return s;
}

- (BOOL)importTriggers {
	int ii = 0;
	int chunkNum = 0;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"TRIG") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
	NSOpenPanel *open = [NSOpenPanel openPanel];
	int result = [open runModal];
	if (result == NSOKButton){
		NSData *imDat = [NSData dataWithContentsOfFile:[open filename]];
		chunkHolder[chunkNum].data = malloc([imDat length]);
		[imDat getBytes:chunkHolder[chunkNum].data];
		chunkHolder[chunkNum].length = [imDat length];
	}
	return YES;
}

- (BOOL)exportTriggers {
	int ii = 0;
	int chunkNum = 0;
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		if(strcmp(chunkHolder[ii].name,"TRIG") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %s \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		ii++;
	}
NSSavePanel *sp;
int runResult;

sp = [NSSavePanel savePanel];

[sp setRequiredFileType:@"trg"];

runResult = [sp runModalForDirectory:NSHomeDirectory() file:@""];

[[NSData dataWithBytes:chunkHolder[chunkNum].data length:chunkHolder[chunkNum].length] writeToFile:[sp filename] atomically:NO];
}
- (NSMutableData *)getData
{
	NSMutableData *testExport = [NSMutableData dataWithLength:0];
	int len = 0;
	int ii = 0;
	unsigned char *le = malloc(4);
	while(ii < chunkCount) {
		//printf(" Chunk { \r\n Name: %s; \r\n Length: ; \r\n } \r\n",chunkHolder[i].name);
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) offset = chunkHolder[ii].offset;
		//if(strcmp(chunkHolder[ii].name,"MTXM") == 0) chunkNum = ii;
		//printf(" Chunk { \r\n Name: %s; \r\n Length: %i; \r\n Data: %c \r\n } \r\n",chunkHolder[ii].name,chunkHolder[ii].length,chunkHolder[ii].data);
		[testExport appendBytes:chunkHolder[ii].name length:4];
		le[3] = floor(chunkHolder[ii].length/0x1000000);
		le[2] = floor((chunkHolder[ii].length - (le[3] * 0x1000000))/0x10000);
		le[1] = floor((chunkHolder[ii].length - (le[3] * 0x1000000) - (le[2] *0x10000))/0x100);
		le[0] = chunkHolder[ii].length - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
		[testExport appendBytes:le length:4];
		[testExport appendBytes:chunkHolder[ii].data length:chunkHolder[ii].length];
		len += chunkHolder[ii].length + 4 + 4;
		ii++;
	}
	NSLog(@" LE: %i Norm: %i\r\n", [testExport length],[dataContainer length]);
	return testExport;
}

@end
