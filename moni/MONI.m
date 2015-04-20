//
//  MONI.m
//  moni
//
//  Created by yue on 14-3-10.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import "MONI.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "Header.h"


@implementation MONI
@synthesize text;

-(void)viewDidLoad
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [path objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];

    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS CostInfo (date TEXT,  Cost TEXT, Type TEXT)";
    [self execSql:sqlCreateTable];
    
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"Sum.txt"];
    FILE *fp;
    fp = fopen([file UTF8String], "r");
    sum = [[NSString stringWithContentsOfFile:file
                                     encoding:NSUTF8StringEncoding
                                        error:nil] floatValue];

    fclose(fp);
    
    NSString *imagePath = [documentDirectory
                           stringByAppendingPathComponent:@"backgroung-img.png"];
    
    background_img = [[UIImage alloc]initWithContentsOfFile: imagePath];
    if (background_img == nil)
    {
        background_img = [UIImage imageNamed:@"background.PNG"];
    }
    
    moniback = [[UIImageView alloc]initWithImage:background_img];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [moniback clipsToBounds];
    moniback.contentMode = UIViewContentModeScaleAspectFill;
    [moniback setFrame:rect];
    [moniback setNeedsDisplay];
    [self.view addSubview:moniback];
    self.view.backgroundColor = [UIColor whiteColor];
    
    coinView = [[UIView alloc]initWithFrame:CGRectMake(135, 150, 50, 50)];
    coinimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin.png"]];
//    coinimg.frame = CGRectMake(0,0, 50, 50);
    coinimg.contentMode = UIViewContentModeScaleToFill;
    [coinView addSubview:coinimg];
    [self.view addSubview:coinView];
    
    drop = [[UIView alloc]initWithFrame:self.view.bounds];
    text = [[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 100)];
    text.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.0f];
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.placeholder = @"input cost";
    text.font = [UIFont fontWithName:@"American Typewriter"
                                size:20.0f];
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.textAlignment = 1;
    text.keyboardType = UIKeyboardTypeDecimalPad;
    text.returnKeyType = UIReturnKeyDone;
    text.inputAccessoryView  = [self accessoryView];
    
    pigView = [[UIView alloc]initWithFrame:CGRectMake(110, 250, 80, 80)];
    pigimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pig.png"]];
    pigimg.contentMode = UIViewContentModeScaleToFill;
    [pigView addSubview:pigimg];
    [self.view addSubview:pigView];
    
    sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 250, 180, 200)];
    sumLabel.center = CGPointMake(self.view.frame.size.width/2 + 45, 350);
    sumLabel.text = [NSString stringWithFormat:@"sum:%.2f",sum];
    sumLabel.textColor = [UIColor darkGrayColor];
    sumLabel.font = [UIFont fontWithName:@"American Typewriter"
                                     size:20.0f];
    [self.view addSubview:sumLabel];

    [self setType];
    [drop addSubview:text];
    [drop addSubview:type];
//    [self deleteAll];
    sqlite3_close(db);
}
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    xp = coinView.center.x;
    yp = coinView.center.y;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    xDistance = coinView.center.x - currentPoint.x;
    yDistance = coinView.center.y - currentPoint.y;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];

    CGPoint newCenter = CGPointMake(self.view.frame.size.width / 2, currentPoint.y + yDistance);
       if (newCenter.y > pigView.center.y) {
        newCenter.y = pigView.center.y;
    }
    [coinView  setCenter:newCenter];

    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [coinView setCenter: CGPointMake(xp, yp)];
  
    [self DropViewWillShow];
    [coinView setHidden:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

-(void)DropViewWillShow
{
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{}
                     completion:^(BOOL finished){}];
    [drop setHidden:NO];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatAutoreverses:NO];
    [text becomeFirstResponder];
    [self.navigationController.navigationBar setHidden:YES];
    [sumcount setHidden:YES];
    [self.view addSubview:drop];
    [UIView commitAnimations];
}

- (void)DropViewWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.navigationController.navigationBar setHidden:NO];
    text.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.0f];
    [sumcount setHidden:NO];
    [type setHidden:NO];
    [UIView commitAnimations];
}

-(void)cleartext
{
    [text setText:@""];
}

-(void)btnPressed:(UIButton *)sender//typelable 内容
{
    NSLog(@"button pressed ");
    cost.tag = (int)sender.tag;
    NSLog(@"%d-tag\n",cost.tag);
    switch (cost.tag)
    {
        case 0:
            typelable.text = @"shopping";
            break;
        case 1:
            typelable.text = @"food";
            break;
        case 2:
            typelable.text = @"drink";
            break;
        case 3:
            typelable.text = @"traffic";
            break;
        case 4:
            typelable.text = @"medical";
            break;
        case 5:
            typelable.text = @"travel";
            break;
    }
}

-(UIToolbar *)accessoryView
{
    toolbar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 50.0f)];
    toolbar.tintColor = [UIColor lightGrayColor];
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:BARBUTTON(@"clear", @selector(cleartext))];
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace,nil)];
    [items addObject:BARBUTTON(@"COST", @selector(buttonPressed:))];
    [items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace,nil)];
    [items addObject:BARBUTTON(@"done", @selector(leaveKeyboardMode))];
    toolbar.items = items;
    
    return toolbar;
}

-(void)setType
{
    float width = self.view.frame.size.width;
    type = [[UIScrollView alloc]initWithFrame:
            CGRectMake(0.0 ,  100, width ,200.0f)];
    type.contentSize = CGSizeMake(2 * width, 200.0f);
    type.pagingEnabled = YES;
    type.delegate = self;
    type.backgroundColor = [UIColor whiteColor];
    
    typelable = [[UILabel alloc]initWithFrame:
                 CGRectMake(110, self.view.bounds.size.width/2, 100, 50)];
    typelable.textAlignment = 1;
    typelable.textColor = [UIColor darkGrayColor];
    typelable.font = [UIFont fontWithName:@"American Typewriter"
                                     size:20.0f];
    UIButton *shopping = [UIButton buttonWithType:UIButtonTypeCustom];
    shopping.frame = CGRectMake(30, 30, 55, 55);
    [shopping setImage:[UIImage imageNamed:@"shopping.png"]
              forState:UIControlStateNormal];
    shopping.tag = 0;
    [shopping addTarget:self
                 action:@selector(btnPressed:)
       forControlEvents:UIControlEventTouchDown];
    
    UIButton *food = [UIButton buttonWithType:UIButtonTypeCustom];
    food.frame = CGRectMake(130, 30, 55, 55);
    [food setImage:[UIImage imageNamed:@"food.png"]
          forState:UIControlStateNormal];
    food.tag = 1;
    [food addTarget:self
             action:@selector(btnPressed:)
   forControlEvents:UIControlEventTouchDown];
    
    UIButton *drink = [UIButton buttonWithType:UIButtonTypeCustom];
    drink.frame = CGRectMake(220, 30, 55, 55);
    [drink setImage:[UIImage imageNamed:@"drink.png"]
           forState:UIControlStateNormal];
    drink.tag = 2;
    [drink addTarget:self
              action:@selector(btnPressed:)
    forControlEvents:UIControlEventTouchDown];
    
    UIButton *traffic = [UIButton buttonWithType:UIButtonTypeCustom];
    traffic.frame = CGRectMake(30, 100, 55, 55);
    [traffic setImage:[UIImage imageNamed:@"traffic.png"]
             forState:UIControlStateNormal];
    traffic.tag = 3;
    [traffic addTarget:self
                action:@selector(btnPressed:)
      forControlEvents:UIControlEventTouchDown];
    
    UIButton *medic = [UIButton buttonWithType:UIButtonTypeCustom];
    medic.frame = CGRectMake(130, 100, 55, 55);
    [medic setImage:[UIImage imageNamed:@"medic.png"]
           forState:UIControlStateNormal];
    medic.tag = 4;
    [medic addTarget:self
              action:@selector(btnPressed:)
    forControlEvents:UIControlEventTouchDown];
    
    UIButton *travel = [UIButton buttonWithType:UIButtonTypeCustom];
    travel.frame = CGRectMake(220, 100, 55, 55);
    [travel setImage:[UIImage imageNamed:@"travel.png"]
            forState:UIControlStateNormal];
    travel.tag = 5;
    [travel addTarget:self
               action:@selector(btnPressed:)
     forControlEvents:UIControlEventTouchDown];
    
    [type addSubview:shopping];
    [type addSubview:food];
    [type addSubview:drink];
    [type addSubview:traffic];
    [type addSubview:medic];
    [type addSubview:travel];
    [type addSubview:typelable];
}

-(void)updatesum
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"Sum.txt"];
    NSLog(@"file address:%@\n",file);
    
    FILE *fp;
    fp = fopen([file UTF8String], "r");
    sum = [[NSString stringWithContentsOfFile:file
                                     encoding:NSUTF8StringEncoding
                                        error:nil] floatValue];
    NSLog(@"Update Sum Cost:%.2f",sum);
    sumLabel.text = [NSString stringWithFormat:@"sum:%.2f",sum];
    
}

-(void)pushtest:(id)sender//test日历
{
    CKViewController *calendar =[[CKViewController alloc]init];
    [self.navigationController pushViewController:calendar animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    
    [moniback setImage: background_img];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [moniback clipsToBounds];
    moniback.contentMode = UIViewContentModeScaleAspectFill;
    [moniback setFrame:rect];
    [moniback setNeedsDisplay];
}

-(void)buttonPressed:(id)sender
{
    float money;
    if ([text.text floatValue] != 0)
    {
       money = [text.text floatValue];
    }
    else
    {
        text.text = text.text;
        money = [text.text floatValue];
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [path objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    NSString *sumdirectory = [path objectAtIndex:0];
    NSString *file = [sumdirectory stringByAppendingPathComponent:@"Sum.txt"];
    FILE *fp;
    fp = fopen([file UTF8String], "wb");
    
    sum = sum + money;
    NSDate *dateToday = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyyMMdd"];
    NSLocale *locale = [NSLocale currentLocale];
    [df setLocale:locale];
    NSString *date = [NSString stringWithFormat:@"%@", [df stringFromDate:dateToday]];
    
    NSString *dateV = [NSString stringWithFormat:@"%@",[df stringFromDate:dateToday]];
    NSString *costV = [NSString stringWithFormat:@"%3.2f",[text.text floatValue]];
    NSString *typeV = [NSString stringWithFormat:@"%@",typelable.text];
    [self insertIntoTablewithDate:dateV Cost:costV Type:typeV];
    NSString *moneym = [NSString stringWithFormat:@"￥%3.2f",[text.text floatValue]];
    NSString *message = [typelable.text stringByAppendingString:@"\n"];
    message = [message stringByAppendingString:date];
    
    NSString *infoallitems = [[NSString alloc] initWithFormat:@"%@ - %@ - %@ ",
                dateV, costV, typeV];
    
    NSLog(@"%@",infoallitems);

    UIAlertView *alert =[ [[UIAlertView alloc]initWithTitle:moneym
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"ok",nil]autorelease ];
    [alert show];
    
    const char *a = [[NSString stringWithFormat:@"%3.2f",sum] UTF8String];
    fputs(a,fp);
    fclose(fp);
    sumcount.transform = CGAffineTransformIdentity;
    sumcount.text = [NSString stringWithFormat:@"Cost : %3.2f\n",sum];
    [text setText:@""];
    [df release];
        [self updatesum];


}

-(void)leaveKeyboardMode
{
    [text resignFirstResponder];
    [drop setHidden:YES];
    [text setText:@""];
    [self DropViewWillHide];

}

- (void) push:(id)sender
{
    [self.navigationController pushViewController:newController
                                         animated:YES];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

-(void)insertIntoTablewithDate:(NSString *)date_s Cost:(NSString *)cost_s Type:(NSString *)type_s
{
    char *errorMsg;
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO CostInfo ('%@', '%@', '%@') VALUES('%@', '%@', '%@')", DATE, COST, TYPE, date_s, cost_s, type_s];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"insert");
        
    }
    sqlite3_free(errorMsg);
}

- (void)getAllCost
{
    NSString *sql = @"SELECT * FROM CostInfo";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int ids = sqlite3_column_int(statement, 0);
            char *date = (char *)sqlite3_column_text(statement, 1);
            char *cost = (char *)sqlite3_column_text(statement, 2);
            char *typeN = (char *)sqlite3_column_text(statement, 3);
            NSString *infoallitems = [[NSString alloc] initWithFormat:@"%d - %s - %s - %s",
                              ids,date, cost, typeN];
            
            NSLog(@"%@",infoallitems);
            
            
            [infoallitems release];
            
        }
        
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
}

- (void)deleteFromCostInfoWhere:(NSString *)coloum equalTo:(NSString *)value
{
    char *errorMsg;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"Sum.txt"];
    
    FILE *fp;
    fp = fopen([file UTF8String], "r");
    sum = [[NSString stringWithContentsOfFile:file
                                     encoding:NSUTF8StringEncoding
                                        error:nil] floatValue];
    fclose(fp);
    [self selectFromCostInfoWhere:coloum equalTo:value];
    float del = [info floatValue];
    NSLog(@"del: %f",del);
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM CostInfo where %@ like '%%%@%%' ",coloum,value];
    if (sqlite3_exec(db,[sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        NSLog(@"delete ok.");
        sum = sum - del;
        fp = fopen([file UTF8String], "wb");
        const char *a = [[NSString stringWithFormat:@"%3.2f",sum] UTF8String];
        fputs(a,fp);
        
    }
    else
    {
        NSLog( @"can not delete it" );
    }
       fclose(fp);
   
}

-(void)deleteAll
{
    char *errorMsg;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE  FROM CostInfo"];
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg ) == SQLITE_OK)
    {
        NSLog(@"delete all.\n");
        sum = 0;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *file = [documentDirectory stringByAppendingPathComponent:@"Sum.txt"];
        FILE *fp;
        fp = fopen([file UTF8String], "wb");
        const char *a = [[NSString stringWithFormat:@"%3.2f",sum] UTF8String];
        NSLog(@"%f",sum);
        fputs(a,fp);
        fclose(fp);
        

    }
    else NSLog(@" fail to delete.\n");
    
    
}

-(void)selectFromCostInfoWhere:(NSString *)coloum equalTo:(NSString *)value
{
    sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CostInfo where %@ like '%%%@%%' ",coloum,value];
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *ids = (char *)sqlite3_column_int(statement, 0);
            NSString *idStr = [[NSString alloc]initWithUTF8String:ids];
            
            char *date = (char *)sqlite3_column_text(statement, 1);
            NSString *dateStr = [[NSString alloc] initWithUTF8String:date];
            
            char *cost = (char *)sqlite3_column_text(statement, 2);
            NSString *costStr = [[NSString alloc] initWithUTF8String:cost];
            
            NSString *typeStr ;
            char *type_ = (char *)sqlite3_column_text(statement, 3);
            if (type_)
            {
                typeStr = @"Null";
                 typeStr = [[NSString alloc] initWithUTF8String:type_];
            }
            else
               typeStr = @"Null";
            info = [[NSString alloc] initWithFormat:@"%@ - %@ - %@ - %@",
                              idStr,dateStr, costStr, typeStr];
            
            NSLog(@"select :%@",info);
            info = [NSString stringWithString:costStr];
            [idStr release];
            [dateStr release];
            [costStr release];
            [typeStr release];
            [info release];
        }
        
        sqlite3_finalize(statement);
    }
}


@end
