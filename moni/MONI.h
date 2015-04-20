//
//  MONI.h
//  moni
//
//  Created by yue on 14-3-10.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SettingViewController.h"
#import "CKViewController.h"
#import "Header.h"
#import "sqlite3.h"
#import <UIKit/UIKit.h>
#define CHTwitterCoverViewHeight 200



struct cost
{
    int tag;
    float mo;
}cost;

UIImage *background_img;
UILabel *sumcount;
float sum;
  sqlite3 *db;

@interface MONI : UIViewController <UITabBarDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    int length;
    float xp,yp, xDistance,yDistance;
    UIView *drop;
    UIView *pigView;
    UIView *coinView;
    UITextField *text;
    UIToolbar *toolbar;
    UIScrollView *type;
    UIViewController *newController;
    UIImageView *moniback;
    UIImageView *coinimg;
    UIImageView *pigimg;
    UIPageControl *pageControl;
    UILabel *typelable;
    UILabel *sumLabel;
    UISwipeGestureRecognizer *swipe;
    NSString *info;
    NSMutableArray *infoall;
    
  }
@property (strong, nonatomic) IBOutlet UITextField *text;
@end
