//
//  UKSCMap.h
//  UnKnown Edit
//
//  Created by Ian Goegebuer on 5/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define MAX_CHUNKS 150
#define MAX_UNITS 800

typedef struct {
	int length;
	unsigned char name[5];
	unsigned char *data;
} chunk;

@interface UKSCMap : NSObject {
	chunk *chunkHolder;
	int chunkCount;
	char era;
	int width;
	int height;
}
- (id)initWithData:(NSData *)aData;
@end
