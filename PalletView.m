#import "PalletView.h"

@implementation PalletView

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
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	[image compositeToPoint:NSMakePoint(0,[image size].height) operation:NSCompositeSourceOver fraction:1];
	[image compositeToPoint:NSMakePoint(0,0) fromRect:NSMakeRect(512,0,512,[image size].height) operation:NSCompositeSourceOver fraction:1];
}

- (void)setPImage:(NSImage *)im
{
	NSLog(@"Pallet %@", im);
	image = im;
	//[image retain];
	NSLog(@"Pallet %@", im);
	[self setFrame:NSMakeRect([self frame].origin.x,[self frame].origin.y,512,[image size].height*2)];
	
	[self setNeedsDisplay:YES];
}

- (void) mouseDown:(NSEvent *)event
{
	NSPoint eventLocation = [event locationInWindow];
	///NSLog(@"Start2");
	NSPoint center = [self convertPoint:[event locationInWindow] fromView:nil];
//	NSLog(@"Start2");
	
	//	NSLog(@"Start4 %f %f",eventLocation.x,center.y);
		
		
				//NSPoint at = NSMakePoint(floor(center.x/32) + c,floor(center.y/32) + a);
				//[[doc placeTile:at] compositeToPoint:center operation:NSCompositeSourceOver];
				//[[doc placeTile:at] compositeToPoint:NSMakePoint(at.x*32,at.y*32) operation:NSCompositeSourceOver];
				[tileBox setIntValue:(int)((int)floor(center.x/32)+(int)floor(([image size].height*2 - center.y)/32)*16)];
			
		
	
	[self setNeedsDisplay:YES];
}

@end
