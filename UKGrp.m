//
//  UKGrp.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 25/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UKGrp.h"


@implementation UKGrp

-(NSArray *)loadAndCreate:(NSData *)data pallet:(NSData *)pallet
{
	unsigned char *color = [pallet bytes];
	NSMutableArray *grpImArray = [[NSMutableArray alloc] initWithCapacity:16];
	//NSLog(@"GRO");
	int playerNum = 0;
	//NSLog(@"GRO");
	unsigned char *bts = [[data subdataWithRange:NSMakeRange(0,12)] bytes];
	//NSLog(@"GRO");
	unsigned char *frameData = [[data subdataWithRange:NSMakeRange(bts[10]+bts[11]*0x100,bts[9]*2)] bytes];
	//unsigned char playerColors[144] = {244,4,4,168,8,8,168,8,8,132,4,4,96,0,0,72,0,0,52,0,0,16,0,0,12,72,204,8,52,152,8,52,152,20,52,124,4,32,100,0,8,80,0,16,52,0,0,2444,180,148,32,144,112,32,144,112,32,144,112,16,84,60,16,84,60,16,84,60,0,40,0,136,64,156,136,64,156,136,64,156,104,48,120,72,28,80,72,28,80,72,28,80,56,16,32,248,140,20,232,120,36,188,104,36,160,84,28,124,64,24,92,44,20,52,32,12,28,16,8,112,48,20,92,49,20,92,49,20,68,52,8,68,52,8,52,32,12,52,32,12,28,16,8};
	//NSLog(@"GRO");
	unsigned char *playerColors = [[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playercolors" ofType:@"act"]] bytes];
//NSLog(@"%i",bts[6]);

//NSImage *frame = [[NSImage alloc] initWithSize:NSMakeSize((bts[2] + 0x100*bts[3]),(bts[4] + 0x100*bts[5]))];
while(playerNum < 16) {	
	NSImage *testIm = [[NSImage alloc] initWithSize:NSMakeSize(bts[8],bts[9])];
unsigned char *image = malloc((bts[8]) * (bts[9])*4);
//unsigned char *image = malloc((bts[8]) * (bts[9])*4);
	int i = 0;
	while(i < bts[9]) {
		unsigned char *lineData = [[data subdataWithRange:NSMakeRange(bts[10]+bts[11]*0x100 + frameData[i*2] + frameData[i*2+1]*0x100,([data length] - (bts[10]+bts[11]*0x100 + frameData[i*2] + frameData[i*2+1]*0x100)))] bytes];
		unsigned char *line = malloc(bts[6]*4 + bts[8]*4);
		int lineCount = 0;
		int repeat = -1;
		int skip = 0-1;
		int loop = 0-1;
		int dataS = 0;
		int currentSpot = 0;
		
		while(lineCount < (bts[8])) {
//NSLog(@"L %i S %i R %i Byte %i",loop,skip,repeat,lineData[currentSpot]);
			image[bts[8] * i * 4 + lineCount * 4] = 0;
			image[bts[8] * i * 4 + lineCount * 4 + 1] = 0;
			image[bts[8] * i * 4 + lineCount * 4 + 2] = 0;
			if(skip > 0) {
				image[bts[8] * i * 4 + lineCount * 4] = 0;
				image[bts[8] * i * 4 + lineCount * 4 + 1] = 0;
				image[bts[8] * i * 4 + lineCount * 4 + 2] = 0;
				image[bts[8] * i * 4 + lineCount * 4 + 3] = 0;
				lineCount++;
//NSLog(@"%i",skip);
				skip--;
			} else if(repeat > 0) {
				
				if(lineData[currentSpot] > 7 && lineData[currentSpot] < 16 && playerNum < 12) {
		//NSLog(@"%i",(lineData[currentSpot] - 9));
					image[bts[8] * i * 4 + lineCount * 4] = playerColors[(lineData[currentSpot] - 8) * 3 + playerNum*24];
					image[bts[8] * i * 4 + lineCount * 4 + 1] = playerColors[(lineData[currentSpot] - 8) * 3 + 1 + playerNum*24];
					image[bts[8] * i * 4 + lineCount * 4 + 2] = playerColors[(lineData[currentSpot] - 8) * 3 + 2 + playerNum*24];
				} else {
					image[bts[8] * i * 4 + lineCount * 4] = color[lineData[currentSpot] * 3];
					image[bts[8] * i * 4 + lineCount * 4 + 1] = color[lineData[currentSpot] * 3 + 1];
					image[bts[8] * i * 4 + lineCount * 4 + 2] = color[lineData[currentSpot] * 3 + 2];
				}
				image[bts[8] * i * 4 + lineCount * 4 + 3] = 255;
				lineCount++;
//NSLog(@"%i %i",repeat,loop);
//image[bts[8] * i * 4 +lineCount] = loop;
				
				repeat--;
				if(repeat <= 0) currentSpot++;
//repeat--;
				
			} else if(loop > 0) {
				if(lineData[currentSpot] > 7 && lineData[currentSpot] < 16 && playerNum < 12) {
		//NSLog(@"%i",(lineData[currentSpot] - 9));
					image[bts[8] * i * 4 + lineCount * 4] = playerColors[(lineData[currentSpot] - 8) * 3 + playerNum*24];
					image[bts[8] * i * 4 + lineCount * 4 + 1] = playerColors[(lineData[currentSpot] - 8) * 3 + 1 + playerNum*24];
					image[bts[8] * i * 4 + lineCount * 4 + 2] = playerColors[(lineData[currentSpot] - 8) * 3 + 2 + playerNum*24];
				} else {
					image[bts[8] * i * 4 + lineCount * 4] = color[lineData[currentSpot] * 3];
					image[bts[8] * i * 4 + lineCount * 4 + 1] = color[lineData[currentSpot] * 3 + 1];
					image[bts[8] * i * 4 + lineCount * 4 + 2] = color[lineData[currentSpot] * 3 + 2];
				}
				image[bts[8] * i * 4 + lineCount * 4 + 3] = 255;
				lineCount++;
//image[bts[8] * i * 4lineCount] = lineData[currentSpot];
				loop--;
				currentSpot++;
			} else if(lineData[currentSpot] >= 128) {
				skip = lineData[currentSpot] - 128;
				
//NSLog(@"Skip %i",lineData[currentSpot]-128);
				currentSpot++;
				
			} else if(lineData[currentSpot] >= 64) {
				if(lineData[currentSpot] - 64 != 0) {
					repeat = lineData[currentSpot] - 64;
//loop = lineData[currentSpot + 1];
				}
//NSLog(@"Repeat %i %i",lineData[currentSpot]-64,lineData[currentSpot + 1]);
				currentSpot++;
			} else {
				loop = lineData[currentSpot];
//NSLog(@"Loop %i",lineData[currentSpot]);
				currentSpot++;
//lineCount++;
				
			}
			
			
//lineCount++;
		}
//NSLog(@"%i %i",lineCount,bts[8]);
		
		
		i++;
	}
playerNum++;
//	NSLog(@"Start bitmap");
	NSImageRep *btmp = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: &image pixelsWide: bts[8] pixelsHigh: bts[9] bitsPerSample: 8 samplesPerPixel: 4 hasAlpha: YES isPlanar: NO colorSpaceName: NSCalibratedRGBColorSpace bytesPerRow: bts[8]*4 bitsPerPixel: 8*4];
//	NSLog(@"NSImage done");
//	CGImageRef imageRef = CGImageCreate(bts[8],bts[9],8,8,bts[8]*4,CGColorSpaceCreateDeviceRGB(),kCGImageAlphaNoneSkipLast,CGDataProviderCreateWithData(NULL,&image,bts[8]*bts[9]*4,NULL), NULL,NO,kCGRenderingIntentDefault);
//	NSLog(@"CGImage done");
//	CGImageRelease(imageRef);
	[btmp setOpaque:NO];
	[testIm addRepresentation:btmp];
	[grpImArray addObject:testIm];
}

	
	
	//[testIm setBackgroundColor:[NSColor clearColor]];
	//[testIm lockFocus];
	//[grpImage drawAtPoint:NSMakePoint(0,0)];
//	NSLog(@"%@",grpImageArray);
	//[testIm unlockFocus];	
	//[testIm addRepresentation:grpImage];
[grpImArray retain];
	return grpImArray;
}


@end
