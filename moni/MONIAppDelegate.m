//
//  MONIAppDelegate.m
//  moni
//
//  Created by yue on 14-3-6.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import "MONIAppDelegate.h"
#import "MONI.h"
#import "ViewController.h"
#import "CKViewController.h"


@implementation MONIAppDelegate
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];//外观代理 navigationBar
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    detail = [[ViewController alloc]init];
    setting = [[SettingViewController alloc]init];
    
    moni = [[MONI alloc]init];
    [self.window addSubview:moni.view];
    moni.title = @"MONI";

    
    nav = [[UINavigationController alloc] initWithRootViewController:moni];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"]
                            forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    window.rootViewController = nav;
    moni.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"detail.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(push:)];
    moni.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting.png"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(setting:)];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


-(void)push:(id)sender
{
    [nav pushViewController:detail
                   animated:YES];
    [detail viewDidLoad];
}

-(void)pushtest:(id)sender
{
    CKViewController *calendar =[[CKViewController alloc]init];
    [nav pushViewController:calendar animated:YES];
}

-(void)setting:(id)sender
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionFromLeft];
    [animation setSubtype: kCATransitionMoveIn];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [nav pushViewController:setting
                   animated:NO];
    [nav.view.layer addAnimation:animation
                          forKey:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
