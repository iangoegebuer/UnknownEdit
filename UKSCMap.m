//
//  UKSCMap.m
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 5/12/09.
//  Copyright 2009 Sajasabie. All rights reserved.
//

#import "UKSCMap.h"


@implementation UKSCMap
- (id)initWithData:(NSData *)aData
{
	self = [super init];
    if (self) {
		chunkCount = 0;
		unsigned char *bites = (unsigned char *)[aData bytes];
		int i = 0;
		int c = 0;
		unsigned char *name = malloc(5);
		name[4] = '\0';
		unsigned int length = 0;
		while(i < [aData length]) {
			i += 4;
			length = bites[i+0] + (bites[i+1] * 0x100) + (bites[i+2] * 0x10000) + (bites[i+3] * 0x1000000);
			i += 4;
			i += length;
			c++;
		}
		chunkCount = c;
		chunkHolder = (chunk*)malloc(c * sizeof(chunk));
		i = 0;
		c = 0;
		while(i < [aData length]) {
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
			i += 4;
			length = bites[i+0] + (bites[i+1] * 0x100) + (bites[i+2] * 0x10000) + (bites[i+3] * 0x1000000);
			i += 4;
			if(strcmp("ERA ",name) == 0) era = bites[i];
			if(strcmp("DIM ",name) == 0) {
				width = bites[i] + 0x100*bites[i+1];
				height = bites[i+2] + 0x100*bites[i+3];
			}
			
			chunkHolder[c].length = length;
			if(strcmp("UNIT",name) != 0 && strcmp("MTXM",name) != 0) {
				chunkHolder[c].data = malloc(length);
				memcpy(chunkHolder[c].data,bites+i,length);
			}
			if(strcmp("UNIT",name) == 0) {
				chunkHolder[c].data = malloc(MAX_UNITS * 36);
				memcpy(chunkHolder[c].data,bites+i,length);
			}
			if(strcmp("MTXM",name) == 0) {
				chunkHolder[c].data = malloc(256*256*2);
				memcpy(chunkHolder[c].data,bites+i,length);
			}
			i += length;
			c++;
		}
    }
    return self;
}
@end
