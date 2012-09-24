//
//  AppDelegate.h
//  Project Acorn
//
//  Created by James Crowson on 18/09/2012.
//  Copyright (c) 2012 James Crowson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@end
