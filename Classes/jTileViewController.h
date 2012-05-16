//
//  jTileViewController.h
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jTileViewController : UIViewController {

}

- (void) arrangeTile;
- (float) widthOfRow : (NSMutableArray*)tileset;
- (void) placeTile : (NSMutableArray*)tileset startAtCoord:(float)xcoord;
- (void) detPos : (NSMutableArray*)panel;
- (NSMutableArray*) recPanelWithPrevType :(NSInteger)prevType forPanel:(NSMutableArray*)panel;



@end

