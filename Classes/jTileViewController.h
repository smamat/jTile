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
	NSMutableDictionary* typeList;
	NSMutableArray* objSpell;
}

//@property (nonatomic,retain) NSMutableArray* letterType;
@property (nonatomic,retain) NSMutableDictionary* typeList;
@property (nonatomic,retain) NSMutableArray* objSpell;

- (void) arrangeTile;
- (float) widthOfRow : (NSMutableArray*)tileset;
- (void) placeTile : (NSMutableArray*)tileset startAtCoord:(float)xcoord;
- (void) detPos : (NSMutableArray*)panel;
//- (NSMutableArray*) recPanelWithPrevType :(NSInteger)prevType forPanel:(NSMutableArray*)panel;
- (void) recPanelWithPrevType :(NSInteger)prevType forPanel:(NSMutableArray*)panel;

- (void) recurseForWord :(NSMutableArray*)word withPrevType:(NSInteger)prevType;
- (void) recurseForWord :(NSMutableArray*)word;

@end

