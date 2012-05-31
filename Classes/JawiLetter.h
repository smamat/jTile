//
//  JawiLetter.h
//  jTile
//
//  Created by Darul Digital on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JawiLetter : NSObject {

	NSString* name; //- name of letter "alif" "ba" "ta"
	NSInteger pos;  //- contextual form "solo", "front", "middle", "end" (0, 1, 2, 3)
}


@property (nonatomic,retain) NSString* name;
@property (nonatomic) NSInteger pos;


- (id)init;
- (id)initWithString:(NSString*)letter;
- (NSString*)imageFilename;
- (CGFloat) yOffsetFromDictionary:(NSDictionary*)dict;


@end
