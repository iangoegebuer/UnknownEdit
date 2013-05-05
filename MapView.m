#import "MapView.h"

@implementation MapView
- (void)awakeFromNib 
{
	[[self window] setAcceptsMouseMovedEvents:YES];
	NSLog(@"AWAKE");
	//[self setBoundsSize:NSMakeSize(400,400)];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
} 

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
		modee = 1;
		selectedUnit = -1;
		//image = [[NSImage alloc] initWithSize:NSMakeSize(320,320)];
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	if(image != NULL) {
		
	
	//NSLog(@"Draw %@ %i",image, self);
	//[image drawAtPoint:NSMakePoint(32,32) fromRect:NSMakeRect(2,2,10,10) operation:NSCompositeSourceOver fraction:1];
	[image compositeToPoint:NSMakePoint(0,0) operation:NSCompositeSourceOver];
	//if(modee != 0)[unitIm compositeToPoint:NSMakePoint(0,0) operation:NSCompositeSourceOver];
	//[self setBounds:NSMakeRect(0,0,[image size].width,[image size].height)];
	if([[NSString stringWithFormat:@"%@",[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"gridOn"]] isEqualTo:@"1"]) {
		int tst;
		for(tst = 0; tst < 256; tst++) 
		{
			[[NSColor blackColor] set];
			NSRectFill(NSMakeRect(0, tst * 32, 8192, 1));
			NSRectFill(NSMakeRect(tst * 32, 0, 1, 8192));
		}
		//NSFrameRectWithWidth([self visibleRect], 5);NSForegroundColorAttributeName
		
//value:[NSColor blueColor]
	}
	if(modee == 1) {
		[[NSColor colorWithCalibratedRed:1.000000 green:0.188235 blue:0.188235 alpha:1.0] set];
		NSFrameRectWithWidth(NSMakeRect((floor(mouse.x/32) * 32), (floor(mouse.y/32) * 32), brushW*32, brushH*32), 1);
	}
	
	if(modee == 0) {
		NSLog(@"..... ");
		if (selectedUnit != -1) {
			NSRect rect3 = NSMakeRect(unitsArray[selectedUnit].area.origin.x,unitsArray[selectedUnit].area.origin.y,unitsArray[selectedUnit].area.size.width,unitsArray[selectedUnit].area.size.width/2);
			NSBezierPath *path3 = [NSBezierPath bezierPathWithOvalInRect: rect3]; 
			[[NSColor colorWithCalibratedRed:0.164706 green:1.000000 blue:0.111765 alpha:1.0] set];
			[path3 setLineWidth:2.5];
	//	[NSColor colorWithCalibratedRed:0.364706 green:1.000000 blue:0.411765 alpha:1.0]
			[path3 stroke];
		}
		if(cuIm != NULL) [cuIm dissolveToPoint:NSMakePoint(mouse.x - [cuIm size].width/2,(mouse.y - [cuIm size].height/2)) fraction:1];
	}
		
	//	const NSRect *rects;
		if(image != NULL) {
		[[NSColor blackColor] set];
		int count = 0;
		while(unitsArray[count].image != NULL){
			if(NSIntersectsRect([self visibleRect],unitsArray[count].area)) [unitsArray[count].image drawInRect:unitsArray[count].area fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
			//[NSBezierPath fillRect:unitsArray[count].area];
			//NSLog(@"..... %f ... %f ... %i", unitsArray[count].area.origin.x, unitsArray[count].area.origin.y, count);
			count++;
		}
		NSLog(@"..... %i %@",[[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"gridOn"] isEqualTo:@"1"],[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"gridOn"]);
		}
	//	id thing;
	//	NSRect windowRe = [self frame];
	//	NSSize windowSize = windowRe.size;
	//	NSEnumerator *thingEnumerator = [unitsArray objectEnumerator];
		
		//[self getRectsBeingDrawn:&rects count:&count];
		
		//while (thing = [thingEnumerator nextObject]) {
			
			//if(NSPointInRect(NSMakePoint([[thing objectAtIndex:2] intValue],[[thing objectAtIndex:3] intValue]), [self visibleRect])) {
			//	NSSize imgSize = [[thing objectAtIndex:5] size];
			//x - imgSize.width/2,windowSize.height - (y + imgSize.height/2)
				
			//NSLog(@"YES IT'S IN %i and %i and %i",[[thing objectAtIndex:2] intValue],(int)windowSize.height,[[thing objectAtIndex:3] intValue]);
		//		[[thing objectAtIndex:5] dissolveToPoint:NSMakePoint([[thing objectAtIndex:2] intValue] - imgSize.width/2,([[thing objectAtIndex:3] intValue] - imgSize.height/2)) fraction:1];
		//	}
			
        // First test against coalesced rect.
			
			/*if (NSIntersectsRect([[thing objectAtIndex:7] bounds], rect)) {
			
        // Then test per dirty rect
			
            for (i = 0; i < count; i++) {
				
				if (NSIntersectsRect([[thing objectAtIndex:7] bounds], rects[i])) {
					
                    [[thing objectAtIndex:7] dissolveToPoint:NSMakePoint([[thing objectAtIndex:2] intValue],[[thing objectAtIndex:3] intValue]) fraction:1];
					
                    break;
					
                }
				
            }*/
			
			//}
	if(modee == 3) {
		[[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.3 alpha:0.250] set];
		int c= 0;
		while(c < 255) {
			if(c != 63 && locations[c].area.size.height != 0) {
				//[[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.3 alpha:0.250] set];
				
				NSFrameRectWithWidth(locations[c].area, 2);
				[NSBezierPath fillRect: locations[c].area];
				if(selectedUnit == c) {
					[[NSColor colorWithCalibratedRed:0.7 green:0.7 blue:1 alpha:0.250] set];
					NSFrameRectWithWidth(locations[c].area, 2);
					[NSBezierPath fillRect: locations[c].area];
					[[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:0.3 alpha:0.250] set];
				}
				//[[NSColor whiteColor] set];
				//[NSDictionary dictionaryWithObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
				[[NSString stringWithUTF8String:locations[c].name] drawAtPoint:NSMakePoint(locations[c].area.origin.x + 10,locations[c].area.origin.y + locations[c].area.size.height - 20) withAttributes:[NSDictionary dictionaryWithObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName]];
			}
			c++;
		}
		NSLog(@"..... ");
	}
		}
	
	//if(modee == 0 && cuIm != NULL) [cuIm dissolveToPoint:
}

- (void)setLayer:(int)layerNum
{
	modee = layerNum;
	[self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)aImage units:(NSImage *)unitImin array:(unitType *)arr withLocations:(locationType *)locs
{
	
	//doc = aDoc;
	//image = [[NSImage alloc] initWithSize:NSMakeSize(320,320)];
	if(aImage != NULL) image = aImage;
	//if(unitImin != NULL) unitIm = unitImin;
	if(arr != NULL)  {
		unitsArray = arr;
		int c = 0;
		while(unitsArray[c].image != NULL) {
			c++;
		}
		unitCount = c;
	}
	if(locs != NULL) locations = locs;
	//modee = 0;
	//[image lockFocus];
	//[aImage drawAtPoint:NSMakePoint(0,0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	//[aImage compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(0,0, 2048, 4048) operation:NSCompositeCopy];
	//[image unlockFocus];
	NSLog(@"Set %f", [self bounds].size.width);
	//[[self superview] setNeedsDisplayInRect:[self frame]];
	//[self setBoundsSize:[image size]];
	NSLog(@"Set %@ %f %f",image, [self frame].size.width, [image size].width);
	//[super setBounds:NSMakeRect(0,0,[image size].width,[image size].height)];
	if(aImage != NULL) [self setFrame:NSMakeRect([self frame].origin.x,[self frame].origin.y,[image size].width,[image size].height)];
	[image retain];
	[unitIm retain];
	//[unitsArray retain];
	//[[self superview] setNeedsDisplayInRect:[self frame]];
	NSLog(@"Set %@ %f %f",image, [self frame].origin.x, [image size].width);
	//[self retain];
	//modee = 1;
	[self setNeedsDisplay:YES];
	//return;
}


- (void) mouseDown:(NSEvent *)event
{
	if(image != NULL) {
		
	
	NSPoint eventLocation = [event locationInWindow];
	///NSLog(@"Start2");
	NSPoint center = [self convertPoint:[event locationInWindow] fromView:nil];
//	NSLog(@"Start2");
	NSPoint at1 = NSMakePoint(floor(center.x/32),floor(center.y/32));
	if(modee == 1) {
		
	//	NSLog(@"Start4 %f %f",eventLocation.x,center.y);
		[image lockFocus];
		int a = 0;
		int c = 0;
		while(a < brushH) {
			c = 0;
			while(c < brushW) {
				NSPoint at = NSMakePoint(floor(center.x/32) + c,floor(center.y/32) + a);
				//[[doc placeTile:at] compositeToPoint:center operation:NSCompositeSourceOver];
				[[doc placeTile:at] compositeToPoint:NSMakePoint(at.x*32,at.y*32) operation:NSCompositeSourceOver];
				
				c++;
			}
			a++;
		}
		[image unlockFocus];
	}
	if(modee == 0 && cuIm != NULL) {
		[doc placeUnitAt:center];
		//[unitsArray addObject:[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%i",0],[NSString stringWithFormat:@"%i",unitId],[NSString stringWithFormat:@"%i",(int)floor(center.x)],[NSString stringWithFormat:@"%i",(int)floor(center.y)],[NSString stringWithFormat:@"%i",player],cuIm,nil]];
		
		unitsArray[unitCount].image = cuIm;
		unitsArray[unitCount].area.size = [cuIm size];
		unitsArray[unitCount].area.origin.x = floor(center.x - unitsArray[unitCount].area.size.width/2);
		unitsArray[unitCount].area.origin.y = floor(center.y - unitsArray[unitCount].area.size.height/2);
		unitsArray[unitCount].props.player = player;
		unitsArray[unitCount].props.unitID = unitId;
		unitCount++;
		//NSLog(@"unit count : %i",[unitsArray count]);
		//[unitsArray retain];
	}
	if(modee == 0 && cuIm == NULL) {
	/*	int count;
		int c =0;
		
		id thing;
		NSRect windowRe = [self frame];
		NSSize windowSize = windowRe.size;
		NSEnumerator *thingEnumerator = [unitsArray objectEnumerator];
		
		//[self getRectsBeingDrawn:&rects count:&count];
		
		while (thing = [thingEnumerator nextObject]) {
			
			if(abs(center.x - [[thing objectAtIndex:2] intValue]) < 19 && abs(center.y -[[thing objectAtIndex:3] intValue]) < 19) {
					selectedUnit = c;
			}
			c++;
		}*/
		//if(unitIm != NULL) {
			//[[NSColor blackColor] set];
			int count = 0;
		selectedUnit = -1;
			while(unitsArray[count].image != NULL){
				if(NSPointInRect(center,unitsArray[count].area)) selectedUnit = count;
				//[NSBezierPath fillRect:unitsArray[count].area];
				//NSLog(@"..... %f ... %f ... %i", unitsArray[count].area.origin.x, unitsArray[count].area.origin.y, count);
				count++;
			}
			NSLog(@"Selecting unit %i ",selectedUnit);
			[doc unitProp:selectedUnit forUnit:unitsArray[selectedUnit]];
	//	}
		
	}
	if(modee == 3) {
		int c =0;
		selectedUnit = -1;
		while(c < 255) {
		
			if(NSPointInRect(center, locations[c].area) && c != 63){
				selectedUnit = c;
			}
		c++;
		}
		[doc locProp:selectedUnit forLocation:locations[selectedUnit]];
	}
	[self setNeedsDisplay:YES];
	}
}


- (void)rightMouseDown:(NSEvent *)theEvent
{
	if(image != NULL) {
	NSPoint eventLocation = [theEvent locationInWindow];
	NSPoint center = [self convertPoint:eventLocation fromView:nil];
	NSRect windowRe = [self frame];
	NSSize windowSize = windowRe.size;
	//NSLog(@"YO!!!!!!!!!! %i %i ",((floor((int)windowSize.height)/32) - floor(floor((int)test.y)/32)),floor(floor((int)test.x)/32));  
	
	[doc getTileAt:NSMakePoint(floor(center.x/32),floor(center.y/32))];
	}
}

- (void) mouseDragged:(NSEvent *)event
{
	if(image != NULL) {
	NSPoint eventLocation = [event locationInWindow];
	//NSLog(@"Start2");
	NSPoint center = [self convertPoint:[event locationInWindow] fromView:nil];
	//NSLog(@"Start2");
	if(modee == 1) {
	//	NSLog(@"Start4 %f %f",eventLocation.x,center.y);
		[image lockFocus];
		int a = 0;
		int c = 0;
		while(a < brushH) {
			c = 0;
			while(c < brushW) {
				NSPoint at = NSMakePoint(floor(center.x/32) + c,floor(center.y/32) + a);
				//[[doc placeTile:at] compositeToPoint:center operation:NSCompositeSourceOver];
				[[doc placeTile:at] compositeToPoint:NSMakePoint(at.x*32,at.y*32) operation:NSCompositeSourceOver];
				
				c++;
			}
			a++;
		}
		[image unlockFocus];
	}
	if(modee == 3) {
		if(selectedUnit == -1) {
			NSLog(@"start new loc");
			int c =0;
			selectedUnit = -1;
			while(locations[c].area.size.width != 0) {
				c++;
				NSLog(@"Hrm %i",c);
			}
			selectedUnit = c;
			locations[c].area.origin.x = floor(center.x);
			locations[c].area.origin.y = floor(center.y);
			locations[c].area.size.width = 1;
			locations[c].area.size.height = 1;
		} else {
			//locations[c].area.origin.x = floor(center.x);
			//locations[c].area.origin.x = floor(center.x);
			locations[selectedUnit].area.size.width = floor(center.x) - locations[selectedUnit].area.origin.x;
			locations[selectedUnit].area.size.height += locations[selectedUnit].area.origin.y - floor(center.y);
			locations[selectedUnit].area.origin.y = floor(center.y);
		}
	}
	if(modee == 0 && selectedUnit != -1) {
		//if(NSPointInRect(center,unitsArray[selectedUnit].area)) {
			unitsArray[selectedUnit].area.origin.x = floor(center.x - unitsArray[selectedUnit].area.size.width/2);
			unitsArray[selectedUnit].area.origin.y = floor(center.y - unitsArray[selectedUnit].area.size.height/2);
		//}
	}
	[self setNeedsDisplay:YES];
	}
}

-(void)mouseMoved:(NSEvent *)event
{
	if(image != NULL) {
	NSPoint eventLocation = [event locationInWindow];
	NSPoint center = [self convertPoint:eventLocation fromView:nil];
//NSLog(@"Mouse %f, %f, %f", mouse.x, mouse.y, floor(mouse.x / 32));
//mouse = center;
	NSRect windowRe = [self frame];
	NSSize windowSize = windowRe.size;
	/*if(modee != -1) {
		if(snapToGrid) {
						//floor(ovalRect.size.height/2) +floor(ovalRect.size.width/4)
						//(floor((test.x-floor(ovalRect.size.height/2))/32) * 32)
			[[unitArray objectAtIndex:placing-1] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%f",(floor((test.x)/32) * 32)]];
			[[unitArray objectAtIndex:placing-1] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",windowSize.height - (floor((test.y)/32) * 32)]];
		} else {
			[[unitArray objectAtIndex:placing-1] replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%f",center.x]];
			[[unitArray objectAtIndex:placing-1] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",windowSize.height - center.y]];
			
		}
	}*/
	mouse = center;
	if(modee == 1 && (floor(center.x/32) != floor(mouse.x/32) || floor(center.y/32) != floor(mouse.y/32))) {
//NSLog(@"Mouse down at %f, %f, %f", center.x, center.y, (center.x / 32));
		//mouse = center;
		[self setNeedsDisplay:YES];
	}
	if(modee == 0 && cuIm != NULL) [self setNeedsDisplay:YES];
	}
//test = center;
//[self RectorAtY: center];
//[self setNeedsDisplay:YES];
}
-(void)keyDown:(NSEvent *)event
{
	if(image != NULL) {
	NSLog(@"KEEEY! %i %i %i", [event keyCode],selectedUnit,unitCount);
	if([event keyCode] == 51 && modee == 0 && cuIm == NULL && selectedUnit != -1) {
		//[unitsArray removeObjectAtIndex:selectedUnit];
		[doc deleteUnit:selectedUnit];
		memmove(unitsArray+selectedUnit,unitsArray+selectedUnit +1,(unitCount - selectedUnit)*sizeof(unitType));
		unitsArray[unitCount].image = NULL;
		unitCount--;
		selectedUnit = -1;
		[self setNeedsDisplay:YES];
	}
	if([event keyCode] == 36 && modee == 0 && cuIm == NULL && selectedUnit != -1) {
		//[unitsArray removeObjectAtIndex:selectedUnit];
		[doc unitProp:selectedUnit forUnit:unitsArray[selectedUnit]];
		//memmove(unitsArray+selectedUnit,unitsArray+selectedUnit +1,(unitCount - selectedUnit)*sizeof(unitType));
		//unitsArray[unitCount].image = NULL;
		//unitCount--;
		//selectedUnit = -1;
		[self setNeedsDisplay:YES];
	}
	if([event keyCode] == 51 && modee == 3 && selectedUnit != -1) {
		
		locations[selectedUnit].area.origin.x = 0;
		locations[selectedUnit].area.origin.y = 0;
		locations[selectedUnit].area.size.width = 0;
		locations[selectedUnit].area.size.height = 0;
		[doc updateLocation:selectedUnit withRect:locations[selectedUnit].area andAts:0];
		selectedUnit = -1;
		[self setNeedsDisplay:YES];
	}
	}
}
-(void)mouseUp:(NSEvent *)event
{
	if(image != NULL) {
	if(modee == 3 && selectedUnit != -1) {
		[doc updateLocation:selectedUnit withRect:locations[selectedUnit].area andAts:&locations[selectedUnit].ats];
		[self setNeedsDisplay:YES];
	}
	if(modee == 0 && selectedUnit != -1) {
		[doc updateUnit:selectedUnit withUnit:unitsArray[selectedUnit]];
		NSLog(@"Unit moved");
	}
	}
}

- (void)mouseEntered:(NSEvent *)event 
{
    //[self setAcceptsMouseMovedEvents:YES];
} 

- (void)mouseExited:(NSEvent *)theEvent 
{
//	[ [self window] setAcceptsMouseMovedEvents:NO]; 
} 

- (void)updateBrushW:(int)newW andH:(int)newH
{
	brushW = newW;
	brushH = newH;
}

- (void)startPlacing:(NSImage *)im player:(int)plr uid:(int)uid
{
	cuIm = im;
	player = plr;
	unitId = uid;

}

- (locationType*)currLoc
{
	//if(selectedUnit == -1) return NULL;
	return &locations[selectedUnit];
}

- (unitType*)currUnit
{
	//if(selectedUnit == -1) return NULL;
	return &unitsArray[selectedUnit];
}

- (int)currUnitNum
{
	
	return selectedUnit;
}

@end
