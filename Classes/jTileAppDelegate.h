//
//  jTileAppDelegate.h
//  jTile
//
//  Created by Saif Mamat on 11/05/2012.
//  Copyright 2012 DD Multimedia Solutions Sdn. Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class jTileViewController;

@interface jTileAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    jTileViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet jTileViewController *viewController;

@end

