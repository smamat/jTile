//
//  jTileViewController.m
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import "jTileViewController.h"
#import "AbjadConstants.h"
#import "PanelGrid.h"
#import "JawiLetter.h"

@implementation jTileViewController

@synthesize letterList;
@synthesize objSpell;

- (void) drawPanelAlignment {
	
	CGFloat vWidth = self.view.frame.size.width;
	PanelGrid* panelGrid = [[PanelGrid alloc] initWithFrame:CGRectMake(0,0,vWidth,100)];
	
	panelGrid.gridScale = 1; //0.72;
	
	[self.view addSubview:panelGrid];
	panelGrid.center = self.view.center;
	
	[panelGrid release];
}

/* calculate width of row by pixels */
- (CGFloat) widthOfPanelWithWord :(NSMutableArray*)word {
	
	NSUInteger wordLength = [word count];
	
	NSLog(@"There are %d tiles", wordLength);

	CGFloat totalWidth = 0.0;
	
	for (NSUInteger i=0; i < wordLength; ++i) {
		//NSLog(@"Letter: %@", (NSString*)[word objectAtIndex:i]);
		NSString* fname = [NSString stringWithFormat:@"%@.png", [word objectAtIndex:i]];
		
		UIImage* im = [UIImage imageNamed:fname];
		//NSLog(@"length: %f", im.size.width);
		totalWidth += im.size.width;
	}

	return totalWidth;
}

/* The pre-condition for this method is
 * each element of "word" is a string where
 * it consists of a letter name and its pos
 * e.g. @"alif1", @"ya2", @"mim3"
 */
- (void) putPanelOfWord :(NSMutableArray*)word withMarginLength:(CGFloat)mLength {
	
	//- give letter tile for later easy retrieval
	NSInteger tag = 1000;
	
	NSInteger i = [word count]-1;
	
	//- coarse y-coord for tile panel
	CGFloat panelY = self.view.center.y;
	
	//- start from right (because Arabic)
	for (; i >= 0; --i) {
		//- get letter info
		NSString* currLetPos = [word objectAtIndex:i];
		int wLength = [currLetPos length];
		NSString* currLetter = [currLetPos substringWithRange:NSMakeRange(0, wLength-1)];
		int lpos = [[currLetPos substringWithRange:NSMakeRange(wLength-1, 1)] integerValue];
		NSLog(@"letter:%@, pos:%d", currLetPos, lpos);
		
		NSString* fname = [NSString stringWithFormat:@"%@.png", currLetPos];
		UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fname]];
		iv.tag = tag++;
		[self.view addSubview:iv];
		
		//- compute x-coord for this tile
		//- x is coord for tile's centre, accounting for margin length
		CGFloat w = iv.frame.size.width;
		CGFloat x = mLength + w/2.0;
		
		//- fine-tuned y-coord for tile panel
		NSDictionary* letterInfo = [self.letterList objectForKey:currLetter];
		CGFloat	dy = [[[letterInfo objectForKey:Y_KEY] objectAtIndex:lpos] floatValue];
		
		iv.center = CGPointMake(x, panelY+dy);
		
		[iv release];

		//- incr marginLength by skipping width of this tile
		mLength += w;
	}
}

- (void) putLettersOfWord:(NSMutableArray *)word {
	
	CGFloat panelWidth = [self widthOfPanelWithWord:word];
	NSLog(@"width of word panel is: %f", panelWidth);
	
	// make image context
	CGFloat imgX = 0;
	
	//- todo: height == 100?
	UIGraphicsBeginImageContext(CGSizeMake(panelWidth, 100));
	
	for (NSInteger i = [word count]-1; i>=0; --i) {
		
		//- a JawiLetter object to represent letter
		//- TODO: need to release letter eventhough not assigning it to self.var?
		JawiLetter* letter = [[JawiLetter alloc] initWithString:[word objectAtIndex:i]];

		//- compute vertical offset of letter
		CGFloat imgY = [letter yOffsetFromDictionary:self.letterList];
		
		//- draw image onto context
		UIImage* img = [UIImage imageNamed:[letter imageFilename]];
		[img drawAtPoint:CGPointMake(imgX, imgY)];
		
		//- update x-coord for next letter
		imgX += [img size].width;
		
		//- add dash/space between letters
		if ([letter needsDashFromDictionary:self.letterList]) {
			//- add dash
			UIImage* dimg = [UIImage imageNamed:@"dash0.png"];
			[dimg drawAtPoint:CGPointMake(imgX, imgY)];
		} else {
			NSLog(@"add space?");
			//- TODO: add space?
		}
		
		//- TODO: figure out how to realease without memory leak
		//[letter release];
		
	}
	
	UIImage* panelImg = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	//- embed word image into panel into app frame
	UIImageView* iv = [[UIImageView alloc] initWithImage:panelImg];
	[self.view addSubview:iv];
	iv.center = self.view.center;
	[iv release];
	
}

/* -- Ligature algorithm --
 * The algorithm handles how an alphabet is connected to the others.
 * This is a recursive algorithm.
 * recurseForWord :word should be called for each word,
 * which will call recurseForWord :word :prevType where the algorithm
 * is executed.
 */

- (NSMutableArray*) recurseForWord:(NSMutableArray*)word {
	return [self recurseForWord:word withPrevType:1];
}

- (NSMutableArray*) recurseForWord :(NSMutableArray*)word withPrevType:(NSInteger)prevType {
	
	NSInteger pos;
	NSString* currLetter = [word objectAtIndex:0]; //- copy of word's first element
	
	//- BASE CASE: last letter
	
	if ([word count] == 1) {
		
		//- add pos to current letter
		if (prevType == TYPE_A)	pos = 0;
		else pos = 3;
		NSString* modfLetter = [currLetter stringByAppendingFormat:@"%d", pos];
		
		//- return new word with modified letter
		NSMutableArray* newWord = [[NSMutableArray alloc] initWithObjects:modfLetter, nil];
		return [newWord autorelease];
	}

	//- RECURSIVE CASE: front/middle letter
	
	//- get current letter's type
	NSDictionary* letterInfo = [self.letterList objectForKey:currLetter];
	NSInteger lType = [[letterInfo objectForKey:T_KEY] integerValue];
	
	//- add pos to current letter
	if (prevType == TYPE_A) pos = 1;
	else pos = 2;
	NSString* modfLetter = [currLetter stringByAppendingFormat:@"%d", pos];
	
	//- recurse remaining letters
	NSMutableArray* subWord = (NSMutableArray*)[word subarrayWithRange:NSMakeRange(1,[word count]-1)];
	NSMutableArray* modfSubWord = [self recurseForWord:subWord withPrevType:lType];
	
	//- return modified currLetter + recurseForWord(subWord,lType)
	NSMutableArray* newWord = [[[NSMutableArray alloc] initWithObjects:modfLetter, nil] autorelease];
	
	return (NSMutableArray*)[newWord arrayByAddingObjectsFromArray:modfSubWord];
	
}


- (CGFloat) marginForPanelWidth : (CGFloat)panelWidth {
	//- simple at the moment, might need different calculation
	//- for different devices, UIView object dependent etc.
	
	return ((self.view.frame.size.width) - panelWidth)/2.0;
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

	//- bagrid as alignment guide
	UIImageView* bgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bagrid.png"]];
	//- uncomment this to display bagrid in app
	//[self.view addSubview:bgv ];
	bgv.center = self.view.center;
	[bgv release];
	

	
	// load dictionary
	NSString* path = [[NSBundle mainBundle] pathForResource:@"LetterList" ofType:@"plist"];
	NSMutableDictionary* tmpDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	self.letterList = tmpDict;
	[tmpDict release];
	
	// load spelling
	path = [[NSBundle mainBundle] pathForResource:@"ObjectSpelling" ofType:@"plist"];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	self.objSpell = tmpArray;
	[tmpArray release];
	

	// test crude tiling
	NSLog(@"spell: %d", [self.objSpell count]);
	NSDictionary* aSpell = [self.objSpell objectAtIndex:2];
	NSMutableArray* word = [aSpell objectForKey:@"spell"];
	NSMutableArray* sword = [self recurseForWord:word];

	CGFloat panelWidth = [self widthOfPanelWithWord:sword];
	CGFloat marginLength = [self marginForPanelWidth:panelWidth];
	NSLog(@"panel width = %f, margin length = %f", panelWidth, marginLength);
	

	//[self putPanelOfWord:sword withMarginLength:marginLength];
	[self putLettersOfWord:sword];
	
	[self drawPanelAlignment];
	

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
	
	[letterList dealloc];
	[objSpell dealloc];
	
    [super dealloc];
}

@end
