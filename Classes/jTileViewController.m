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
- (CGFloat) widthOfPanelWithWord :(NSArray*)word {
	
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

- (void) putLettersOfWord:(NSArray *)word {
	
	CGFloat panelWidth = [self widthOfPanelWithWord:word];
	NSLog(@"width of word panel is: %f", panelWidth);
	
	// make image context
	CGFloat imgX = 0;
	
	//- todo: height == 100?
	UIGraphicsBeginImageContext(CGSizeMake(panelWidth, 150));
	
	for (NSInteger i = [word count]-1; i>=0; --i) {
		
		//- a JawiLetter object to represent letter
		JawiLetter* letter = [[JawiLetter alloc] initWithString:[word objectAtIndex:i]];

		//- compute vertical offset of letter
		CGFloat imgY = [self yOffsetOfLetter:letter]+25;
		
		//- draw image onto context
		UIImage* img = [UIImage imageNamed:[letter imageFilename]];
		
		//- TODO: if letter is alif, add space
		//- TODO: if letter is ra-type, substract space
		//- TODO: if letter is jim-type and pos 3, substract space
		//- TODO: if letter is lam?
		//if ([letter isName:@"alif"])
		//	imgX += 7;
		
		[img drawAtPoint:CGPointMake(imgX, imgY)];
		
		//- add dash/space between letters
		if ([self needsDashForLetter:letter]) {
			UIImage* dimg = [UIImage imageNamed:@"dash0.png"];
			[dimg drawAtPoint:CGPointMake(imgX-4, 68)];
		}
		
		//- update x-coord for next letter
		imgX += [img size].width;

		[letter release];
	}
	
	UIImage* panelImg = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	//- embed word image into panel into app frame
	UIImageView* iv = [[UIImageView alloc] initWithImage:panelImg];
	[self.view addSubview:iv];
	iv.center = self.view.center;
	/*CGFloat iw = iv.frame.size.width;
	CGFloat ih = iv.frame.size.height;
	CGFloat x = iv.frame.origin.x;
	CGFloat y = iv.frame.origin.y;
	iv.frame = CGRectMake(x, y, iw/2, ih/2);*/
	[iv release];
	
}

/* -- Ligature algorithm --
 * The algorithm handles how an alphabet is connected to the others.
 * This is a recursive algorithm.
 * recurseForWord :word should be called for each word,
 * which will call recurseForWord :word :prevType where the algorithm
 * is executed.
 * Lam-alif checks are done in algorithm to mimick the way
 * the human mind works (mine at least).
 * If the checks are done before hand, it's pre-emptive and unnatural.
 */

- (NSArray*) linkLettersOf:(NSArray*)word {
	return [self recurseForWord:word withPrevType:1];
}

- (NSArray*) recurseForWord :(NSArray*)word withPrevType:(NSInteger)prevType {
	
	NSInteger nLetter = [word count];
	
	//- BASE CASE: empty letter (due to lam-alif at end of word)
	if (nLetter == 0)
		return nil;
	
	//- current letter to be processed
	JawiLetter* letter = [[JawiLetter alloc] initWithString:[word objectAtIndex:0]];
	
	//- BASE CASE: last letter
	if (nLetter == 1) {
		//- add pos to current letter
		if (prevType == TYPE_A)
			letter.pos = 0;
		else
			letter.pos = 3;
		
		//- return new word with modified letter
		NSMutableArray* newWord = [[NSMutableArray alloc] initWithObjects:[letter namepos], nil];
		[letter release];
		return [newWord autorelease];
	}

	//- RECURSIVE CASE: front/middle letter
	
	//- range for word tail (i.e. exclude current letter)
	NSRange subRange = NSMakeRange(1, nLetter-1);
	
	//- add pos to current letter
	if (prevType == TYPE_A)
		letter.pos = 1;
	else 
		letter.pos = 2;

	//- check if lam-alif, combine to "la" and remove trailing alif
	if ([letter isName:@"lam"] && ([[word objectAtIndex:1] isEqualToString:@"alif"])) {
		letter.name = @"la";
		subRange = NSMakeRange(2, nLetter-2);
	}
	
	//- TODO: check if ba ta jim sin sad ain fa kaf lam mim nun ya nya
	//- then do "ya"-ligature
	
	//- recurse on tail (remaining letters)
	NSArray* subWord = [word subarrayWithRange:subRange];
	NSArray* modfTail = [self recurseForWord:subWord withPrevType:[self typeOfLetter:letter]];
	
	//- return modified currLetter + recurseForWord(subWord,lType)
	NSArray* newWord = [[[NSArray alloc] initWithObjects:[letter namepos], nil] autorelease];
	[letter release];
	return [newWord arrayByAddingObjectsFromArray:modfTail];
	
}

- (NSInteger) typeOfLetter : (JawiLetter*)letter {
	NSDictionary* letterInfo = [self.letterList objectForKey:letter.name];
	return [[letterInfo objectForKey:T_KEY] integerValue];
}

- (CGFloat) yOffsetOfLetter : (JawiLetter *)letter {
	NSDictionary* letterInfo = [self.letterList objectForKey:letter.name];
	return [[[letterInfo objectForKey:Y_KEY] objectAtIndex:letter.pos] floatValue];
}

//- letter needs dash if type==2 and (pos==1 or pos==2)
- (bool) needsDashForLetter:(JawiLetter*)letter {
	NSDictionary* letterInfo = [self.letterList objectForKey:letter.name];
		
	if ([[letterInfo objectForKey:T_KEY] integerValue]==2 && (letter.pos==1 || letter.pos==2)) {
		//NSLog(@"%@ at %d needs dash", self.name, self.pos);
		return YES;
	}
	
	return NO;
	
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
	//NSLog(@"spell: %d", [self.objSpell count]);
	NSDictionary* aSpell = [self.objSpell objectAtIndex:18];
	NSMutableArray* word = [aSpell objectForKey:@"spell"];
	NSArray* lword = [self linkLettersOf:word];

	[self putLettersOfWord:lword];
	
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
