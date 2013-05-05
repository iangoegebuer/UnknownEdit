/* MapControl */

#import <Cocoa/Cocoa.h>
#import "MyDocument.h"

@interface MapControl : NSObject
{
	id layer;
}
- (IBAction)setLayer:(id)sender;
- (IBAction)setPlayer:(id)sender;
- (IBAction)triggers:(id)sender;
- (IBAction)openUnitPallet:(id)sender;
- (IBAction)testMapSize:(id)sender;
@end

