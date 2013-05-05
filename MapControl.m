#import "MapControl.h"

@implementation MapControl

- (IBAction)setLayer:(id)sender
{
	if([sender tag] != 55) {
		MyDocument *currentDocument=(MyDocument *)[[NSDocumentController sharedDocumentController] currentDocument];
		if(currentDocument==nil){
			currentDocument=(MyDocument *)[[NSApp orderedDocuments] objectAtIndex:0];
			if(currentDocument==nil){
				NSLog(@"currentDocument playing up.");
				NSBeep();
				return;
			}
		}
		if(layer != 0) [layer setState:NSOffState];
		//[layer tag]
		[currentDocument setLayer:[sender tag]];
		layer = sender;
		[layer setState:NSOnState];
		//currntPlayer = [sender tag];
		NSLog(@"Current layer: %i %i ",[sender tag],layer);
	}
	
}

- (IBAction)triggers:(id)sender
{
	MyDocument *currentDocument=(MyDocument *)[[NSDocumentController sharedDocumentController] currentDocument];
	if(currentDocument==nil){
		currentDocument=(MyDocument *)[[NSApp orderedDocuments] objectAtIndex:0];
		if(currentDocument==nil){
			NSLog(@"currentDocument playing up.");
			NSBeep();
			return;
		}
	}
	[currentDocument openTrig];
}

- (IBAction)openUnitPallet:(id)sender
{
	MyDocument *currentDocument=(MyDocument *)[[NSDocumentController sharedDocumentController] currentDocument];
	if(currentDocument==nil){
		currentDocument=(MyDocument *)[[NSApp orderedDocuments] objectAtIndex:0];
		if(currentDocument==nil){
			NSLog(@"currentDocument playing up.");
			NSBeep();
			return;
		}
	}
	[currentDocument openUnitPallet];
}

- (IBAction)testMapSize:(id)sender
{
	MyDocument *currentDocument=(MyDocument *)[[NSDocumentController sharedDocumentController] currentDocument];
	if(currentDocument==nil){
		currentDocument=(MyDocument *)[[NSApp orderedDocuments] objectAtIndex:0];
		if(currentDocument==nil){
			NSLog(@"currentDocument playing up.");
			NSBeep();
			return;
		}
	}
	//currntPlayer = [sender tag];
	//NSLog(@"Current player: %i",[sender tag]);
	[currentDocument setMapSize:NSMakeSize(128,128)];
}

- (IBAction)setPlayer:(id)sender
{
	MyDocument *currentDocument=(MyDocument *)[[NSDocumentController sharedDocumentController] currentDocument];
	if(currentDocument==nil){
		currentDocument=(MyDocument *)[[NSApp orderedDocuments] objectAtIndex:0];
		if(currentDocument==nil){
			NSLog(@"currentDocument playing up.");
			NSBeep();
			return;
		}
	}
	//currntPlayer = [sender tag];
	NSLog(@"Current player: %i",[sender tag]);
	[currentDocument setPlayer:[sender tag]];
}

@end
