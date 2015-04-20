//
//  MONIAppDelegate.h
//  moni
//
//  Created by yue on 14-3-6.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MONI.h"
#import "ViewController.h"
#import "Header.h"
#import "SettingViewController.h"



@interface MONIAppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>
{
    MONI *moni;
    UINavigationController *nav;
    ViewController *detail;
    CKViewController *Calendar;
    SettingViewController *setting;
    UIImageView *background ;
}

@property (strong, nonatomic) UIWindow *window;
@end
