//
//  jTileViewController.h
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JawiLetter.h"

@interface jTileViewController : UIViewController {

	NSMutableDictionary* letterList;
	NSMutableArray* objSpell;
}

//- letterList - a dictionary of letters with its attributes
//- objSpell - a list of words (with spelling)
@property (nonatomic,retain) NSMutableDictionary* letterList;
@property (nonatomic,retain) NSMutableArray* objSpell;

//- place complete word onto panel (row of letters) with correct spelling
//- 1. determine width of panel
//- 2. determine margin of panel so can align
//- 3. put images of letter onto screen
- (CGFloat) widthOfPanelWithWord : (NSMutableArray*)word;
- (CGFloat) marginForPanelWidth : (CGFloat)panelWidth;
- (void) putPanelOfWord : (NSMutableArray*)word withMarginLength : (CGFloat)marginLength;
//- same as putPanelOfWord but use image context and only one UIViewImage as panel
- (void) putLettersOfWord : (NSMutableArray*)word;

//- implement algorithm for determining letter post (alone, front, middle, end)
//- alone - 0, front - 1, middle - 2, end - 3
- (NSMutableArray*) recurseForWord : (NSMutableArray*)word;
- (NSMutableArray*) recurseForWord : (NSMutableArray*)word withPrevType : (NSInteger)prevType;

//- draw lines for aligning panels vertically using PanelGrid class
- (void) drawPanelAlignment;

//- letter info and condition
- (CGFloat) yOffsetOfLetter:(JawiLetter*)letter;
- (NSInteger) typeOfLetter:(JawiLetter*)letter;
//- (bool) needsDashForLetter:(JawiLetter*)letter;


@end

