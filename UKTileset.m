//
//  UKTileset.m
//  tester
//
//  Created by Ian Goegebuer on Sat May 26 2007.
//  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
//

#import "UKTileset.h"


@implementation UKTileset
-(void)setType:(NSString *)aType
{
type = aType;
//	NSLog(type);
}


-(BOOL)parseMicrotiles:(NSData *)palData data:(NSData *)theData
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
	unsigned char *fullTiles = malloc((int)ceil((([tileData length]/32)*32*192*3)/6));
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

	while(i < count) {
		
		
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
						ii = (i*18432 + a*576 + d*3 );
						fullTiles[ii] = microTiles[dd];
						fullTiles[ii +1] = microTiles[dd +1];
						fullTiles[ii +2] = microTiles[dd +2];
						d+=1;
					}
					a++;
				}

		i++;
	} 

	//NSLog(@"%@",[[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&fullTiles pixelsWide:32 pixelsHigh:t*32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:8*3 bitsPerPixel:8*3] TIFFRepresentation]]);

	i = 0;
	//unsigned char *fullTiles2 = malloc((([tileData length]/64)*32*32*3)/2);
	//unsigned char *fullTiles2 = malloc((2000*32*32*3));
	while(i < count) {
		
		
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
				c = ((count)*32 + i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
						//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
				if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				ii = (i*18432 + a*576 + d*3 + 96);
				fullTiles[ii] = microTiles[dd];
				fullTiles[ii +1] = microTiles[dd +1];
				fullTiles[ii +2] = microTiles[dd +2];
				d+=1;
			}
			a++;
		}
		
		i++;
	} 
	i = 0;
	//unsigned char *fullTiles2 = malloc((([tileData length]/64)*32*32*3)/2);
	//unsigned char *fullTiles2 = malloc((2000*32*32*3));
	while(i < count) {
		
		
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
				c = ((count)*64 + i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
						//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
				if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				ii = (i*18432 + a*576 + d*3 + 192);
				fullTiles[ii] = microTiles[dd];
				fullTiles[ii +1] = microTiles[dd +1];
				fullTiles[ii +2] = microTiles[dd +2];
				d+=1;
			}
			a++;
		}
		
		i++;
	} 	i = 0;
	//unsigned char *fullTiles2 = malloc((([tileData length]/64)*32*32*3)/2);
	//unsigned char *fullTiles2 = malloc((2000*32*32*3));
	while(i < count) {
		
		
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
				c = ((count)*96 + i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
						//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
				if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
				ii = (i*18432 + a*576 + d*3 + 288);
				fullTiles[ii] = microTiles[dd];
				fullTiles[ii +1] = microTiles[dd +1];
				fullTiles[ii +2] = microTiles[dd +2];
				d+=1;
			}
			a++;
		}
		
		i++;
	} 
	
	i = 0;
	
		while(i < count) {
			a = 0;
	while(a < 32) {
		d = 0;
		while(d < 32) {
			c = ((count)*128 + i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
						//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
			if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
			if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
			
			//ii = (i*18432 + a*576 + d*3 );
			ii = (i*18432 + a*576 + d*3 + 384);
			fullTiles[ii] = microTiles[dd];
			fullTiles[ii +1] = microTiles[dd +1];
			fullTiles[ii +2] = microTiles[dd +2];
			d+=1;
		}
		a++;
	}
	
	i++;
} 

i = 0;

while(i < count) {
	a = 0;
	while(a < 32) {
		d = 0;
		while(d < 32) {
			c = ((count)*160 + i*32+(int)floor(d/8)*2 + (int)floor(a/8)*8);
						//dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
			if((data[c])%2 == 1) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 - (d%8)*3 + (a%8)*24 +21);
			if((data[c])%2 == 0) dd = (((int)floor((data[c] + 0x100*data[c+1])/2))*192 + (d%8)*3 + (a%8)*24);
			//ii = (i*18432 + a*576 + d*3 );

			ii = (i*18432 + a*576 + d*3 + 480);
			fullTiles[ii] = microTiles[dd];
			fullTiles[ii +1] = microTiles[dd +1];
			fullTiles[ii +2] = microTiles[dd +2];
			d+=1;
		}
		a++;
	}
	
	i++;
} 
NSLog(@" Count %i Total %i", (count*5 + i), t);
tileCount = t;
	tiles = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:fullTiles pixelsWide:192 pixelsHigh:(count)*32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:192*3 bitsPerPixel:8*3] TIFFRepresentation]];
	//tiles = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&image pixelsWide:32 pixelsHigh:32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:32*3 bitsPerPixel:8*3] TIFFRepresentation]];
	[tiles retain];
	//[self parseTiles2:tileData];
	//tiles2 = [[NSImage alloc] initWithData:[[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&fullTiles2 pixelsWide:32 pixelsHigh:2000*32 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:32*3 bitsPerPixel:8*3] TIFFRepresentation]];
	//[tiles2 retain];
	return tiles;
}

-(NSImage *)parseTiles2:(NSData *)tileData
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

- (NSImage *)getTiles
{
	return tiles;
}

- (NSImage *)getTiles2
{
	return tiles2;
}

/*
 
 
 c = 0;
 while(c < 4) {
	 b = 0;
	 while(b < 4) {
		 b++;
	 }
	 c++;
 }
 
 
-(NSArray *)parseCV5B:(NSData *)tilData3
{
//	NSLog([[NSBundle mainBundle] pathForResource:type ofType:@"cv5"]);
NSArray *cv5Array = [NSMutableArray arrayWithObjects:nil];
//NSData *tilData3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:type ofType:@"cv5"]];
int i = 0;
unsigned char *tileNum = (unsigned char*)[tilData3 bytes];
while(i < [tilData3 length]) {
i += 20;
//NSLog(@"DEBUG");
int b = 0;

while(b < 32) {
//int j = [self numStrToHEX:[self getChunkLength:[self dataStrtoStr:[[tilData3 subdataWithRange:NSMakeRange(i+b,2)] description]] le:3]];
//NSLog(@"%i",j);
//tiles[i/2] = j;

//[cv5Array addObject:[NSString stringWithFormat:@"%i",(tileNum[i+b] + 0x100*tileNum[i+b+1])]];
b+=2;
}
//NSLog(@"%i",j);
i+=32; 
//NSLog(@"%i",j);
//[loader incrementBy:1];
//NSLog(@"%i",i);
}
[cv5Array retain];
return cv5Array;
}*/
- (unsigned char *)getCV5
{
	return cv5;
}

-(unsigned char *)parseCV5:(NSData *)tilcv53
{
//	NSLog([[NSBundle mainBundle] pathForResource:type ofType:@"cv5"]);
	//NSArray *cv5Array = [NSMutableArray arrayWithObjects:nil];
	cv5 = malloc((([tilcv53 length]/52)*32) + 2);
//NSData *tilData3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:type ofType:@"cv5"]];
	int i = 0;
	int j = 0;
	int b = 0;
	
//	le[0] = [[[mapDataArray objectAtIndex:i] objectAtIndex:1] intValue] - (le[1] * 0x100) - (le[3] * 0x1000000) - (le[2] *0x10000);
	int le = (([tilcv53 length]/52)*16);
	cv5[1] = (floor(le/0x100));
	cv5[0] = (le - (cv5[1] * 0x100));
	
	unsigned char *tileNum = (unsigned char*)[tilcv53 bytes];
	while(i < [tilcv53 length]) {
		i += 20;
//NSLog(@"DEBUG");
		b = 0;
		
		while(b < 32) {
			
//int j = [self numStrToHEX:[self getChunkLength:[self cv5StrtoStr:[[tilcv53 subcv5WithRange:NSMakeRange(i+b,2)] description]] le:3]];
//NSLog(@"%i",j);
//tiles[i/2] = j;
			cv5[j*2+2] = tileNum[i+b];
			cv5[j*2+3] =tileNum[i+b+1];
				
			//[cv5Array addObject:[NSString stringWithFormat:@"%i",(tileNum[i+b] + 0x100*tileNum[i+b+1])]];
			b+=2;
			j++;
		}
//NSLog(@"%i",j);
		i+=32; 
//NSLog(@"%i",j);
//[loader incrementBy:1];
//NSLog(@"%i",i);
	}
	//[cv5Array retain];
	return cv5;
}

- (NSImage *) getTileById:(int)num 
{
	NSImage *reTile = [[NSImage alloc] initWithSize:NSMakeSize(32,32)];
	[reTile lockFocus];
	int totalTiles = [tiles size].height/32;
	//unsigned char *cv5 = [tileset getCV5];
	//s = ((bites[i*2+offset] + bites[i*2+offset+1]*0x100));
	int n = (cv5[num*2+2] + 0x100*cv5[num*2+3]);
	//x = (i%64)*32;
	//y = (63-floor(i/64))*32;
	/*int i = num;
	int s = num;
	//n = (cv5[s*2+2] + 0x100*cv5[s*2+3]);
	int x = 0;
	int y = 0;
	if(n >= totalTiles) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(32,(totalTiles-(n-totalTiles)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*2) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(64,(totalTiles-(n-totalTiles*2)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*3) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(96,(totalTiles-(n-totalTiles*3)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*4) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(128,(totalTiles-(n-totalTiles*4)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n >= totalTiles*5) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(160,(totalTiles-(n-totalTiles*5)-1)*32, 32, 32) operation:NSCompositeSourceOver];
	if(n < totalTiles) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(0,(totalTiles-n-1)*32, 32, 32) operation:NSCompositeSourceOver];*/
	[[[tiles representations] objectAtIndex:n] drawAtPoint:NSMakePoint(0,0)];
	//[[reps objectAtIndex:(cv5[(r)*2+2] + 0x100*cv5[(r)*2+3])] drawAtPoint:NSMakePoint(x,y)];
	[reTile unlockFocus];
	return reTile;
}

- (NSImage *) makePallet
{
	int totalTiles = cv5[0] + 0x100*cv5[1];
	NSImage *palletImage = [[NSImage alloc] initWithSize:NSMakeSize(1024,((totalTiles-2)/32)*32)];
	int i = 0;
	int j = 0;
	int x = 0;
	int y = 0;
	int n = 0;
	int r = 0;
	NSLog(@"IM: %i",((totalTiles-2)/16)*32);
	NSArray *reps = [tiles representations];
	//[[reps objectAtIndex:(cv5[(r)*2+2] + 0x100*cv5[(r)*2+3])] drawAtPoint:NSMakePoint(x,y)];
	[palletImage lockFocus];
	while(n < 2) {
		i=0;
	while(i < ((totalTiles-2)/32)*16) {
		j = 0;
		while(j < 16) {
			//n = i + j;
			//x = (j%16)*32;
			//y = i;
			x = j*32 +n*512;
			y = ((totalTiles-2)/32)*32 - i*2 -32;
			r = n*((totalTiles-2)/32)*16 + i + j;
		//	if(i >= totalTiles)1024,(totalTiles/2)*32 [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(32,(totalTiles-(n-totalTiles)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		//	if(i >= totalTiles*2) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(64,(totalTiles-(n-totalTiles*2)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		//	if(i >= totalTiles*3) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(96,(totalTiles-(n-totalTiles*3)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		//	if(i >= totalTiles*4) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(128,(totalTiles-(n-totalTiles*4)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		//	if(i >= totalTiles*5) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(160,(totalTiles-(n-totalTiles*5)-1)*32, 32, 32) operation:NSCompositeSourceOver];
		//	if(i < totalTiles) [tiles compositeToPoint:NSMakePoint(x,y) fromRect:NSMakeRect(0,(totalTiles-n-1)*32, 32, 32) operation:NSCompositeSourceOver];
			[[reps objectAtIndex:(cv5[(r)*2+2] + 0x100*cv5[(r)*2+3])] drawAtPoint:NSMakePoint(x,y)];
			//NSLog(@"Hmm testing?: %i %i %i %i",i,j,x,y);
			j++;
			
		}
		i += 16;
	}
	n++;
	}
	[palletImage unlockFocus];
	NSLog(@"IM:");
	return palletImage;
}

/*
- (void) dealloc 
{ 
	[tiles release];
	delloc(microTiles);
	//delloc(bites);
	[tiles2 release]; 
	[super dealloc]; 
}*/

@end
