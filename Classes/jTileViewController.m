//
//  jTileViewController.m
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import "jTileViewController.h"
#import "AbjadConstants.h"

@implementation jTileViewController

@synthesize letterType;
@synthesize objSpell;

/* calculate width of row by pixels */

- (float) widthOfRow :(NSMutableArray*)tileset {
	
	float arrSize = [tileset count];
	
	NSLog(@"There are %d tiles", arrSize);

	NSUInteger i;
	
	float totalSize = 0.0;
	
	for (i=0; i<arrSize; ++i) {
		NSLog(@"Letter: %@", (NSString*)[tileset objectAtIndex:i]);
		NSString* fname = [NSString stringWithFormat:@"%@.png", [tileset objectAtIndex:i]];
		UIImage* im = [UIImage imageNamed:fname];
		NSLog(@"length: %f", im.size.width);
		totalSize += im.size.width;
	}

	
	return totalSize;
}

- (void) placeTile :(NSMutableArray*)tileset startAtCoord:(float)xcoord {
	
	NSUInteger nTile = [tileset count];
	
	
	NSInteger tag = 1000;
	
	NSInteger i = nTile-1;
	for (; i >= 0; --i) {
		
		NSString* fname = [NSString stringWithFormat:@"%@.png", [tileset objectAtIndex:i]];
		UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fname]];
		iv.tag = tag++;
		[self.view addSubview:iv];
		
		CGFloat w = iv.frame.size.width;
		CGFloat x = xcoord + w/2;
		iv.center = CGPointMake(x,50);

		[iv release];
		
		xcoord += w;
	}
	
	//UIImageView *iv0 = (UIImageView*)[self.view viewWithTag:1001];
	//iv0.center = self.view.center;
	
}

- (NSMutableArray*) recPanelWithPrevType:(NSInteger)prevType forPanel:(NSMutableArray*)panel1 {

	
	NSInteger pos;
	
	NSMutableArray* panel = [panel1 mutableCopy];
	
	// - at last letter
	if ([panel count] == 1) {
		if (prevType == TYPE_A)
			pos = 0;
		else 
			pos = 3;
		
		[panel replaceObjectAtIndex:0
						 withObject:[(NSString*)[panel objectAtIndex:0] stringByAppendingFormat:@"%d", pos]];
		NSLog(@"last letter: %@",(NSString*)[panel objectAtIndex:0]);
		return panel;
		
	}
	
	NSLog(@"prevType: %d", prevType);
	// - front/middle letter
	if (prevType == TYPE_A)
		pos = 1;
	else
		pos = 2;
	
		  
	NSInteger typeletter = [[self.letterType objectForKey:[panel objectAtIndex:0]] integerValue];

	// change current letter
	//NSString* tmpStr = [(NSString*)[panel objectAtIndex:0] stringByAppendingFormat:@"%d", pos];
	[panel replaceObjectAtIndex:0
					 withObject:[(NSString*)[panel objectAtIndex:0] stringByAppendingFormat:@"%d", pos]];
	NSLog(@"letter: %@", [panel objectAtIndex:0]);
	
	// recurse the rest
	NSLog(@"typeletter: %d", typeletter);
	NSInteger l = [panel count]-1;
	
//	NSLog(@"count sub: %d", [[(NSMutableArray*)[panel subarrayWithRange:NSMakeRange(1,3)]] count]);
	NSMutableArray* sp = (NSMutableArray*)[panel subarrayWithRange:NSMakeRange(1,l)];

			

														
	//[self recPanelWithPrevType:typeletter forPanel:(NSMutableArray*)[panel subarrayWithRange:NSMakeRange(1,l)]];
	[self recPanelWithPrevType:typeletter forPanel:(NSMutableArray*)sp];
		
	return panel;
	
	
	//- simple syntax: return [panel objectAtIndex:0] + pos + recPanel(pos,[panel objectStartAt:1]);
	
}

- (void) detPos : (NSMutableArray*)panel {
	
	//NSLog(@"the letters are:");
	//int i = 0, c = [panel count];
	
	//for (; i<c; ++i) 
	//	NSLog(@"%@", [panel objectAtIndex:i]);
	
	
	
	NSMutableArray* rpanel = [self recPanelWithPrevType:TYPE_A forPanel:panel]; 
	
	NSLog( @"size of rpanel = %d", [rpanel count]);
	
	for (int i=0; i<[rpanel count]; ++i)
		NSLog(@"K: %@", [panel objectAtIndex:i]);
}

- (void) arrangeTile {
	
	/*	
	UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alif1.png"]];
	NSLog(@"%f x %f", iv.frame.size.width, iv.frame.size.height);
	[self.view addSubview:iv]; 
	[iv release];
	
	UIImageView* iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ya2.png"]];
	NSLog(@"%f x %f", iv2.frame.size.width, iv2.frame.size.height);
	[self.view addSubview:iv2]; 
	iv2.center = CGPointMake(30, 30);
	[iv2 release];
	
	UIImageView* iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mim4.png"]];
	NSLog(@"%f x %f", iv3.frame.size.width, iv3.frame.size.height);
	[self.view addSubview:iv3]; 
	[iv3 release];
	 */
	
	NSMutableArray* tileArray = [[NSMutableArray alloc] initWithObjects:@"alif1", @"ya2", @"mim4", nil];
	
	//NSMutableArray* panel = [[NSMutableArray alloc] initWithObjects:@"alif", @"ya", @"mim", @"sin", nil];
	NSMutableArray* panel = [[NSMutableArray alloc] initWithObjects:@"ba", @"wau", @"ra", @"wau", @"nga", nil];
	
	

	float rowWidth = [self widthOfRow:tileArray];
	
	//NSLog( @"size of tiles: %f", rowWidth );
	

	
	//float a = ((self.view.frame.size.width) - rowWidth)/2;
	
	//NSLog( @"a is %f", a);
	
	//[self placeTile:tileArray startAtCoord:a];
	
	// try recursion
	//[self detPos:panel];

	[self detPos:panel];
	 
	[panel release];
	[tileArray release];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSLog( @"device: %f x %f", self.view.frame.size.width, self.view.frame.size.height );


	// load dictionary
	NSString* path = [[NSBundle mainBundle] pathForResource:@"LetterType" ofType:@"plist"];
	NSMutableDictionary* tmpDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	self.letterType = tmpDict;
	[tmpDict release];
	
	// load spelling
	path = [[NSBundle mainBundle] pathForResource:@"ObjectSpelling" ofType:@"plist"];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.objSpell = tmpArray;
	[tmpArray release];
	
	NSInteger i, nObj = [self.objSpell count];
	
	for (i=0; i < nObj; ++i) {
		NSDictionary* spellWord = [self.objSpell objectAtIndex:i];
		NSLog(@"%@", [spellWord objectForKey:@"name"]);
	}
	
	//UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(160, 240, 50, 50)];
	//[iv setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
	//UIImage* im = [UIImage imageNamed:@"ya2.png"];
	//UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ya2.png"]];
	//[iv setImage:im];
	//iv.contentMode = UIViewContentModeScaleToFill;
	//[self.view addSubview: iv];
	//iv.center = self.view.center;
	//NSLog( @"tile: %f x %f", iv.frame.size.width, iv.frame.size.height );
	//[iv release];
	
	//UIImageView* iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mim4.png"]];
	//[self.view addSubview: iv2];
	//iv2.center = self.view.center;
	//[iv2 release];

	//[self arrangeTile];
	
						

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[letterType dealloc];
	
    [super dealloc];
}

@end
