//
//  UKSCTilesSet.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UKSCTilesSet.h"

@implementation UKSCTilesSet

-(BOOL)parseMicrotilesWithPallet:(NSData *)palData data:(NSData *)theData
{
	microTiles = malloc(([theData length]/64)*8*8*3);
	unsigned char *color = (unsigned char*)[palData bytes];
	unsigned char *tester = (unsigned char*)[theData bytes];
	//NSLog(@"%i",([theData length]/64)*8*8*3);
	int g = 0;
	int i = 0;
	//int j = 0;
	while(g < [theData length]) {
		
		
		i = 0;
		//j = 0;
		while(i < 64) {
			
			microTiles[g*3 + i*3] = color[tester[g + i] * 4];
			microTiles[g*3 + i*3 + 1] = color[tester[g + i] * 4 + 1];
			microTiles[g*3 + i*3 + 2] = color[tester[g + i] * 4 + 2];
			
			i++;
		}
		g += 64;
	}
	
	return YES;
}

-(NSImage *)parseTiles:(NSData *)tileData
{
	unsigned char *data = (unsigned char*)[tileData bytes];
	unsigned char *fullTiles = malloc(32*32*3);
	tiles = [[NSImage alloc] initWithSize:NSMakeSize(32,32)];
	//	fullTiles = malloc(32*32*3*100);
	//printf("%i \r\n",([tileData length]/2)*32*32*3);
	int ii = 0;
	int dd = 0;
	int i = 0;
	int d = 0;
	
	int c = 0;
	int t = [tileData length]/32;
	NSLog(@"Tileset %i %i",t,(int)ceil((([tileData length]/32)*32*192*3)/6));
	int count = ceil(t/6);
	int a = 0;
	
	while(i < t) {
		
		fullTiles = malloc(32*32*3);
		//printf("%i \r\n",((int)floor((data[(i*32)+(int)floor(d/64)] + 0x100*data[(i*32)+(int)floor(d/64)+1])/2))*192);
		a = 0;
		/*	while(d < 1024) {
			
			
			//((int)floor((data[i*32+(int)floor(d/32)] + 0x100*data[i*32+(int)floor(d/32)*2+1])/2))*192 + (d%32)*3
			c = (i*32+(int)floor(d/32)*2);
		dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%32)*3);
		ii = (i*3072 + d*3);
		//if((data[c] + 0x100*data[c+1])%2 > 0) ii = ((i+1)*3072 - d*3);
		//if((data[c] + 0x100*data[c+1])%2 == 0) ii = (i*3072 + d*3);
		fullTiles[ii] = microTiles[dd];
		fullTiles[ii +1] = microTiles[dd +1];
		fullTiles[ii +2] = microTiles[dd +2];
		d++;
		} */
		while(a < 32) {
			d = 0;
			while(d < 32) {
				c = (i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
				//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
				if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				ii = (a*96 + d*3);
				fullTiles[ii] = microTiles[dd];
				fullTiles[ii +1] = microTiles[dd +1];
				fullTiles[ii +2] = microTiles[dd +2];
				//NSLog(@"grr: %i %i %i %i %i %i",i,ii,dd,c,a,d);
				d+=1;
			}
			a++;
		}
		[tiles addRepresentation:[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&fullTiles pixelsWide:32 pixelsHigh:32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:32*3 bitsPerPixel:8*3]];
		i++;
	} 
	
	//	NSLog(@" Count %i Total %i %@", (count*5 + i), t, tiles2);
	//tileCount = t;
	//tiles = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&fullTiles pixelsWide:192 pixelsHigh:(count)*32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:192*3 bitsPerPixel:8*3] TIFFRepresentation]];
	//tiles = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&image pixelsWide:32 pixelsHigh:32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:32*3 bitsPerPixel:8*3] TIFFRepresentation]];
	//[tilesIm release];
	[tiles retain];
	//tiles2 = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&fullTiles2 pixelsWide:32 pixelsHigh:2000*32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:32*3 bitsPerPixel:8*3] TIFFRepresentation]];
	//[tiles2 retain];
	return nil;
}

-(unsigned char *)parseCV5:(NSData *)tilcv53
{
	cv5 = malloc((([tilcv53 length]/52)*32) + 2);
	int i = 0;
	int j = 0;
	int b = 0;
	int le = (([tilcv53 length]/52)*16);
	
	cv5Template *tileNum = (cv5Template *)[tilcv53 bytes];
	while(i < [tilcv53 length]/52) {
		b = 0;
		
		while(b < 16) {
			cv5[i].tileNums[b] = tileNum[i].tileNums[b];
			b++;
		}
		i++; 
	}
	return cv5;
}


@end
