//
//  PanelGrid.m
//  jTile
//
//  Created by Saif Mamat on 22/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//


#import "PanelGrid.h"


@implementation PanelGrid

@synthesize gridScale;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.opaque = NO;
		self.alpha = 0.5;
		self.gridScale = 1;
		//self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	CGContextRef con = UIGraphicsGetCurrentContext();
	
	CGFloat gHeight = 100*gridScale;
	CGFloat gapY = gHeight/6.0;
	CGFloat xend = self.bounds.size.width;							
	
	CGFloat y = 0;
	while (y<gHeight) {
		//NSLog(@"panelGrid y-coord: %f", y);
		CGContextMoveToPoint(con, 0, y);
		CGContextAddLineToPoint(con, xend, y);
		y += gapY;
	}
	//- line that underlines bottom of ba--
	CGFloat baLine = 56.2*gridScale;
	CGContextMoveToPoint(con, 0, baLine);
	CGContextAddLineToPoint(con, xend, baLine);
	
	CGContextSetLineWidth(con, 0.25);
	
	CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(con, red);
	CGContextStrokePath(con);
}


- (void)dealloc {
    [super dealloc];
}


@end
