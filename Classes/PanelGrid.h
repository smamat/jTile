//
//  PanelGrid.h
//  jTile
//
//  Created by Saif Mamat on 22/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//
//	This class, when initialised, will draw a set of horizontal lines
//	that will be used to align the letters vertically.
//	set gridScale (0..1) to scale the grid (distance between the lines)
//	The position of the grid (vertical position) is set
//	by the initialiser "initWithFrame"

#import <UIKit/UIKit.h>


@interface PanelGrid : UIView {
	
	CGFloat gridScale;
}

@property (nonatomic) CGFloat gridScale;

@end
