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

@synthesize typeList;
@synthesize objSpell;

/* calculate width of row by pixels */

- (CGFloat) widthOfPanelWithWord :(NSMutableArray*)word {
	
	NSUInteger wordLength = [word count];
	
	NSLog(@"There are %d tiles", wordLength);

	//NSUInteger i;
	CGFloat totalWidth = 0.0;
	
	for (NSUInteger i=0; i < wordLength; ++i) {
		NSLog(@"Letter: %@", (NSString*)[word objectAtIndex:i]);
		NSString* fname = [NSString stringWithFormat:@"%@.png", [word objectAtIndex:i]];
		
		UIImage* im = [UIImage imageNamed:fname];
		NSLog(@"length: %f", im.size.width);
		totalWidth += im.size.width;
	}

	return totalWidth;
}

- (void) putPanelOfWord :(NSMutableArray*)word withMarginLength:(CGFloat)mLength {
	
	//- give letter tile for later easy retrieval
	NSInteger tag = 1000;
	
	NSInteger i = [word count]-1;
	
	//- start from right (because Arabic)
	for (; i >= 0; --i) {
		
		NSString* fname = [NSString stringWithFormat:@"%@.png", [word objectAtIndex:i]];
		UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fname]];
		iv.tag = tag++;
		[self.view addSubview:iv];
		
		//- compute x-coord for this tile
		//- x is coord for tile's centre, accounting for margin length
		CGFloat w = iv.frame.size.width;
		CGFloat x = mLength + w/2.0;
		iv.center = CGPointMake(x, 100);
		
		[iv release];
		
		//- incr marginLength by skipping width of this tile
		mLength += w;
	}
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

- (NSMutableArray*) recurseForWord:(NSMutableArray*)word {
	return [self recurseForWord:word withPrevType:1];
}

- (NSMutableArray*) recurseForWord :(NSMutableArray*)word withPrevType:(NSInteger)prevType {
	
	NSInteger pos;
	//NSMutableArray* word = [[uword mutableCopy] autorelease]; //- ensure array mutable each time
	NSString* currLetter = [word objectAtIndex:0]; //- copy of word's first element
	
	//- BASE CASE: last letter
	
	if ([word count] == 1) {
		
		//- add pos to current letter
		if (prevType == TYPE_A)	pos = 0;
		else pos = 3;
		NSString* modfLetter = [currLetter stringByAppendingFormat:@"%d", pos];
		//NSLog(@"prevType: %d, last letter: %@", prevType, modfLetter);
		
		//- return new word with modified letter
		NSMutableArray* newWord = [[NSMutableArray alloc] initWithObjects:modfLetter, nil];
		return [newWord autorelease];
	}
	
	//- RECURSIVE CASE: front/middle letter
	
	//- get current letter's type
	NSInteger lType = [[self.typeList objectForKey:currLetter] integerValue];
	
	//- add pos to current letter
	if (prevType == TYPE_A) pos = 1;
	else pos = 2;
	NSString* modfLetter = [currLetter stringByAppendingFormat:@"%d", pos];
	//NSLog(@"prevType:%d, mid letter: %@", prevType, modfLetter);
	
	//- recurse remaining letters
	NSMutableArray* subWord = (NSMutableArray*)[word subarrayWithRange:NSMakeRange(1,[word count]-1)];
	NSMutableArray* modfSubWord = [self recurseForWord:subWord withPrevType:lType];
	
	//- return modified currLetter + recurseForWord(subWord,lType)
	NSMutableArray* newWord = [[[NSMutableArray alloc] initWithObjects:modfLetter, nil] autorelease];
	
	return (NSMutableArray*)[newWord arrayByAddingObjectsFromArray:modfSubWord];
	
}


/*
- (NSMutableArray*) recurseForWord :(NSMutableArray*)uword withPrevType:(NSInteger)prevType {

	NSInteger pos;
	NSMutableArray* word = [[uword mutableCopy] autorelease]; //- ensure array mutable each time
	NSString* currLetter = [word objectAtIndex:0]; //- copy of word's first element
	
	//- base case (last letter)
	if ([word count] == 1) {
		if (prevType == TYPE_A)
			pos = 0;
		else
			pos = 3;
		[word replaceObjectAtIndex:0
						withObject:[currLetter stringByAppendingFormat:@"%d", pos]];
		NSLog(@"prevType:%d, last letter: %@", prevType, (NSString*)[word objectAtIndex:0]);
		return word;
	}
	
	//- front/middle letter
	if (prevType == TYPE_A) 
		pos = 1;
	else
		pos = 2;
		
	//- get current letter's type
	NSInteger lType = [[self.typeList objectForKey:currLetter] integerValue];
		
	//- change letter
	[word replaceObjectAtIndex:0
					withObject:[currLetter stringByAppendingFormat:@"%d", pos]];
		
	NSLog(@"prevType:%d, mid letter: %@", prevType, [word objectAtIndex:0]);
	
	//- recurse remaining letters
	NSMutableArray* subWord = (NSMutableArray*)[word subarrayWithRange:NSMakeRange(1,[word count]-1)];
	NSMutableArray* sw = [self recurseForWord:subWord withPrevType:lType];
	
	//- return newCurrLetter + recurseForWord(subWord,lType)
	NSMutableArray* nw = [[[NSMutableArray alloc] initWithObjects:[word objectAtIndex:0], nil] autorelease];
	return (NSMutableArray*)[nw arrayByAddingObjectsFromArray:sw];
	
	
	//return [self recurseForWord:subWord withPrevType:lType];
	
}
*/	

/*- (void) recPanelWithPrevType:(NSInteger)prevType forPanel:(NSMutableArray*)panel1 {

	
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
		//return panel;
		return;		
	}
	
	NSLog(@"prevType: %d", prevType);
	// - front/middle letter
	if (prevType == TYPE_A)
		pos = 1;
	else
		pos = 2;
	
	//- get letter type
	NSInteger lType = [[self.typeList objectForKey:[panel objectAtIndex:0]] integerValue];

	// change current letter
	//NSString* tmpStr = [(NSString*)[panel objectAtIndex:0] stringByAppendingFormat:@"%d", pos];
	[panel replaceObjectAtIndex:0
					 withObject:[(NSString*)[panel objectAtIndex:0] stringByAppendingFormat:@"%d", pos]];
	NSLog(@"letter: %@", [panel objectAtIndex:0]);
	
	// recurse the rest
	NSLog(@"letter type: %d", lType);
	NSInteger l = [panel count]-1;
	
	NSMutableArray* sp = (NSMutableArray*)[panel subarrayWithRange:NSMakeRange(1,l)];

			

														
	[self recPanelWithPrevType:lType forPanel:(NSMutableArray*)sp];
		
	//return panel;
	
		
}*/

/*- (void) detPos : (NSMutableArray*)panel {
	
	//NSLog(@"the letters are:");
	//int i = 0, c = [panel count];
	
	//for (; i<c; ++i) 
	//	NSLog(@"%@", [panel objectAtIndex:i]);
	
	
	
	//NSMutableArray* rpanel = [self recPanelWithPrevType:TYPE_A forPanel:panel]; 
	[self recPanelWithPrevType:TYPE_A forPanel:panel]; 
	
	//NSLog( @"size of rpanel = %d", [rpanel count]);
	
	//for (int i=0; i<[rpanel count]; ++i)
		//NSLog(@"K: %@", [panel objectAtIndex:i]);
}*/

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
	
	

	//float rowWidth = [self widthOfRow:tileArray];
	
	//NSLog( @"size of tiles: %f", rowWidth );
	

	
	//float a = ((self.view.frame.size.width) - rowWidth)/2;
	
	//NSLog( @"a is %f", a);
	
	//[self placeTile:tileArray startAtCoord:a];
	
	// try recursion
	//[self detPos:panel];

	[panel release];
	[tileArray release];
}

- (CGFloat) marginForPanelWidth : (CGFloat)panelWidth {
	//- simple at the moment, might need different calculation
	//- for different devices, UIView object dependent etc.
	
	return ((self.view.frame.size.width) - panelWidth)/2.0;
}

- (void) arrangeTileForWord :(NSMutableArray *)word {
	
	
	
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
	NSString* path = [[NSBundle mainBundle] pathForResource:@"TypeList" ofType:@"plist"];
	NSMutableDictionary* tmpDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	self.typeList = tmpDict;
	[tmpDict release];
	
	// load spelling
	path = [[NSBundle mainBundle] pathForResource:@"ObjectSpelling" ofType:@"plist"];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.objSpell = tmpArray;
	[tmpArray release];
	
	/* Test
	NSInteger i, nObj = [self.objSpell count];
	
	for (i=0; i < nObj; ++i) {
		NSDictionary* spellWord = [self.objSpell objectAtIndex:i];
		NSLog(@"%@", [spellWord objectForKey:@"name"]);
		NSMutableArray* word = [spellWord objectForKey:@"spell"];
	
		NSLog(@"- %@", word);
		//NSMutableArray* newWord = [self recurseForWord:word withPrevType:1];
		NSMutableArray* newWord = [self recurseForWord:word];
		NSLog(@"~ %@",newWord);
	}
	 */
	
	NSDictionary* aSpell = [self.objSpell objectAtIndex:1];
	NSMutableArray* word = [aSpell objectForKey:@"spell"];
	NSMutableArray* sword = [self recurseForWord:word];
	
	CGFloat panelWidth = [self widthOfPanelWithWord:sword];
	CGFloat marginLength = [self marginForPanelWidth:panelWidth];
	NSLog(@"panel width = %f, margin length = %f", panelWidth, marginLength);
	
	
	[self putPanelOfWord:sword withMarginLength:marginLength];
	
	/*
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
	*/
						

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
	
	[typeList dealloc];
	[objSpell dealloc];
	
    [super dealloc];
}

@end
