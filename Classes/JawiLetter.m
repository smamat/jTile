//
//  JawiLetter.m
//  jTile
//
//  Created by Darul Digital on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AbjadConstants.h"
#import "JawiLetter.h"




@implementation JawiLetter

@synthesize name, pos;

- (id) init {
	
	//- TODO: maybe change ba0 with kiyi? 
	return [self initWithString:@"ba0"];
}

- (id) initWithString:(NSString*)letter {
    
    self = [super init];
    if (self) {
        //- TODO: check that letter only contains "a-b"
		//- check pos only contains numeric "0-9"
		NSInteger length = [letter length];
		int c = [letter characterAtIndex:length-1];
		
		//- ASCII code for 0, 1, 2 and 3 is 48, 49, 50, 51
		if ( c > 47 && c < 52 ) {
			self.name = [letter substringWithRange:NSMakeRange(0, length-1)];
			//self.name = [[NSString alloc] initWithString:@"ba"];
			//self.name = letter;
			self.pos = c - 48;
		}
		else {
			self.name = letter;
			self.pos = 0;
		}

		NSLog(@"name = %@, pos = %d", self.name, self.pos);
	}
    return self;
}

- (NSString*) imageFilename {
	//NSLog(@"image file name is: %@%d.png", self.name, self.pos);
	return [NSString stringWithFormat:@"%@%d.png", self.name , self.pos];
}

- (CGFloat) yOffsetFromDictionary:(NSDictionary*)dict {
	NSDictionary* letterInfo = [dict objectForKey:self.name];
	//NSLog(@"letterInfo: %@", letterInfo);
	
	return [[[letterInfo objectForKey:Y_KEY] objectAtIndex:self.pos] floatValue];
	//CGFloat	dy = [[[letterInfo objectForKey:Y_KEY] objectAtIndex:lpos] floatValue];
}

//- letter needs dash if type==2 and (pos==1 or pos==2)
- (bool) needsDashFromDictionary:(NSDictionary*) dict {
	NSDictionary* letterInfo = [dict objectForKey:self.name];
	
	if ([[letterInfo objectForKey:T_KEY] integerValue]==2 && (self.pos==1 || self.pos==2)) {
		NSLog(@"%@ at %d needs dash", self.name, self.pos);
		return YES;
	} else {
		NSLog(@"%@ at %d needs no dash", self.name, self.pos);
	}

	
	return NO;
}

//- get letter type: 1 or 2
- (NSInteger) letterTypeFromDictionary: (NSDictionary*)dict {
	
	NSDictionary* letterInfo = [dict objectForKey:self.name];
	return [[letterInfo objectForKey:T_KEY] integerValue];
}

- (void)dealloc {
	NSLog(@"before dealloc");
	[name dealloc];
	NSLog(@"after dealloc");
    [super dealloc];
}

@end
