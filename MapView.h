/* MapView */

#import <Cocoa/Cocoa.h>
#import "MyDocument.h"
#import "CHKMap.h"

@interface MapView : NSView
{
	IBOutlet id doc;
	//id doc;
	NSImage *image;
	NSImage *unitIm;
	NSImage *cuIm;
	unitType *unitsArray;
	locationType *locations;
	int modee;
	int brushW;
	int brushH;
	int player;
	int unitId;
	int selectedUnit;
	int unitCount;
	NSPoint mouse;
}
- (void)setImage:(NSImage *)aImage units:(NSImage *)unitImin array:(unitType *)arr withLocations:(locationType *)locs;
- (void)setImage:(NSImage *)aImage;
- (int)currUnitNum;
- (locationType*)currLoc;
- (unitType*)currUnit;
- (void)updateBrushW:(int)newW andH:(int)newH;
//- (void)startPlacing:(NSImage *)im;
- (void)startPlacing:(NSImage *)im player:(int)plr uid:(int)uid;
@end
