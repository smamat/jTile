//
//  jTileViewController.h
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jTileViewController : UIViewController {

	//NSMutableArray* letterType;
	NSMutableDictionary* letterList;
	NSMutableArray* objSpell;
}

//@property (nonatomic,retain) NSMutableArray* letterType;
@property (nonatomic,retain) NSMutableDictionary* letterList;
@property (nonatomic,retain) NSMutableArray* objSpell;

- (CGFloat) widthOfPanelWithWord : (NSMutableArray*)word;
- (CGFloat) marginForPanelWidth : (CGFloat)panelWidth;
- (void) putPanelOfWord : (NSMutableArray*)word withMarginLength : (CGFloat)marginLength;

- (NSMutableArray*) recurseForWord : (NSMutableArray*)word withPrevType : (NSInteger)prevType;
- (NSMutableArray*) recurseForWord : (NSMutableArray*)word;

//- draw lines for aligning panels vertically
- (void) drawPanelAlignment;


@end

