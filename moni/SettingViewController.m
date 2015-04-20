//
//  SettingViewController.m
//  moni
//
//  Created by yue on 14-4-18.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController
@synthesize picker;

- (void)viewDidLoad
{
    [super viewDidLoad];

    settingback = [[UIImageView alloc]initWithImage:background_img];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    settingback.contentMode = UIViewContentModeScaleAspectFill;
    [settingback clipsToBounds];
    [settingback setFrame:rect];
    [settingback setNeedsDisplay];
    [self.view addSubview:settingback];
    
    UIButton *pick = [[UIButton alloc]initWithFrame:CGRectMake(120, 300, 80, 30)];
    [pick setTitle:@"Pick!"
          forState:UIControlStateNormal];
    pick.titleLabel.font = [UIFont fontWithName:@"American Typewriter"
                                           size:24.0f];
    [pick  setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    pick.highlighted = YES;
    [pick addTarget:self
             action:@selector(pickphoto:)
   forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:pick];
    
    
    datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(00, 80, self.view.bounds.size.width, 180)];
    [datepicker setDate:[NSDate date]];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datepicker];

    //设置navigation bar button左
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Back~", @selector(doBack:));
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error)
    {
        NSLog(@"picture saved with no error.");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage]retain];
    background_img = image;
    [settingback setImage:image];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [settingback clipsToBounds];
    settingback.contentMode = UIViewContentModeScaleAspectFill;
    [settingback setFrame:rect];
    [settingback setNeedsDisplay];
    
    //储存background img
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"backgroung-img.png"];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:file
                                               options:NSAtomicWrite error:nil];
    
    //test print image info
    NSLog(@"image size: %@", [[NSValue valueWithCGSize:image.size]description]);
    NSLog(@"background size: %@", [[NSValue valueWithCGSize:background_img.size]description]);

    //dismiss picker VC
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}

-(void)doBack:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFromLeft;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:nil];
    [[self navigationController] popViewControllerAnimated:NO];
}


-(void)pickphoto:(id)sender
{
    picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    [self presentViewController: picker
                       animated: YES
                     completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//#pragma mark - Navigation



@end
