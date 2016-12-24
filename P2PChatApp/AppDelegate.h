//
//  AppDelegate.h
//  P2PChatApp
//
//  Created by Aleksey Solovyev on 09.12.16.
//  Copyright © 2016 Aleksey Solovyev. All rights reserved.
//

#import <UIKit/UIKit.h>
//////
#import "P2PConnector.h"
//////
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//////
@property (strong, nonatomic) P2PConnector *p2pConnector;
//////

@end

