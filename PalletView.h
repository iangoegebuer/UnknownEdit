/* PalletView */

#import <Cocoa/Cocoa.h>

@interface PalletView : NSView
{
    IBOutlet id document;
		IBOutlet id tileBox;
	NSImage *image;
}
- (void)setPImage:(NSImage *)im;
@end

