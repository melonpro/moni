//
//  ViewController.m
//  moni
//
//  Created by yue on 14-4-10.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize listData;

- (void)viewDidLoad
{
    NSLog(@"TableView");
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *database_path = [documentDirectory stringByAppendingPathComponent:DBNAME];
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }

    items = [self getAllCost];
    NSEnumerator *enumerator;
    enumerator = [items objectEnumerator];
    id astring;
//    NSLog(@"-viewDidLoad-\n");
    while (astring = [enumerator nextObject])
    {
        NSLog(@"%@",astring);
    }
    
    self.listData = items;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    detail_back = [[UIImageView alloc]initWithImage:background_img];
    detail_back.bounds = self.view.bounds;
    detail_back.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView setBackgroundView:detail_back];
    self.tableView.contentMode = UIViewContentModeScaleAspectFill;
        [detail_back clipsToBounds];
    [self.tableView setNeedsDisplay];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:detail_back.image];

   
    [self.view addSubview:detail_back];
}

- (void) setBarButtonItems
{
    UIBarButtonItem *trash = SYSBARBUTTON(UIBarButtonSystemItemTrash, @selector(tableView:commitEditingStyle:forRowAtIndexPath:));
    self.navigationController.navigationItem.rightBarButtonItem = trash;
}

/*
- (void) updateItemAtIndexPath: (NSIndexPath *) indexPath withObject: (id) object
{
    [self.tableView beginUpdates];
    
    // delete item
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"Sum.txt"];
    
    NSString *str = [items objectAtIndex:indexPath.row];
    float removeCost =[[[str componentsSeparatedByString:@"/"]objectAtIndex:0]floatValue];
    NSLog(@"remove cost float value:%f\n",removeCost);
    
    FILE *Sfp;
    Sfp = fopen([file UTF8String], "r");
    sum = [[NSString stringWithContentsOfFile:file
                                     encoding:NSUTF8StringEncoding
                                        error:nil] floatValue];
    NSLog(@"----sum :%f\n",sum);
    fclose(Sfp);
    Sfp = fopen([file UTF8String], "w");
    sum = sum + removeCost;
    const char *a = [[NSString stringWithFormat:@"%3.2f",sum] UTF8String];
    fputs(a, Sfp);
    fclose(Sfp);
    
    NSString *itemstr = [items objectAtIndex:indexPath.row];
    NSLog(@"item:%@",itemstr);
    
    NSArray *res = [itemstr componentsSeparatedByString:@"- "];
    [items removeObjectAtIndex:indexPath.row];
    NSLog(@"res:%@",[res objectAtIndex:1]);
    [self deleteFromCostInfoWhere:COST equalTo:[res objectAtIndex:1]];

    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    NSLog(@"-Update item-\n");
    
    NSEnumerator *enumerator;
    enumerator = [items objectEnumerator];
    
    sumcount.transform = CGAffineTransformIdentity;
    sumcount.text = [NSString stringWithFormat:@"Cost : %3.2f\n",sum];
    
    [self.tableView endUpdates];
    [self.tableView setEditing:NO animated:YES];
    [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self updateItemAtIndexPath:indexPath withObject:nil];
}
 */


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    NSString *text;
    text = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    
    return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    [self.tableView setEditing:editing animated:YES];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path)
    {
        [self.tableView deselectRowAtIndexPath:path animated:YES];
    }
}


-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    BOOL isChecked = !((NSNumber *)stateDictionary[indexPath]).boolValue;
//    stateDictionary[indexPath] = @(isChecked);
//    cell.accessoryType = isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
//    
//    int numChecked = 0;
//    for (int row = 0; row <[items count]; row++)
//    {
//        NSIndexPath *path = INDEXPATH(0, row);
//        isChecked = ((NSNumber *)stateDictionary[path]).boolValue;
//        if (isChecked) numChecked++;
//    }
    
  //  self.title = [@[@(numChecked).stringValue, @" Checked"] componentsJoinedByString:@" "];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"钱花都花了就别想后悔了\n假装没花!没门！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)btnClicked:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if(indexPath != nil)
    {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)getAllCost
{
    NSString *sql = @"SELECT * FROM CostInfo";
    sqlite3_stmt *statement;
    NSMutableArray *allinfo = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int id = sqlite3_column_int(statement, 0);
            char *date = (char *)sqlite3_column_text(statement, 1);
            char *cost = (char *)sqlite3_column_text(statement, 2);
            char *typeN = (char *)sqlite3_column_text(statement, 3);
            NSString *infoallitems = [[NSString alloc] initWithFormat:@"%d - %s - %s - %s",id,cost ,date, typeN];
            
            NSLog(@"%@",infoallitems);
            [allinfo addObject:infoallitems];
            [infoallitems release];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return allinfo;
    [allinfo release];
}

-(void)selectFromCostInfoWhere:(NSString *)coloum equalTo:(NSString *)value
{
    sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CostInfo where %@ like '%%%@%%' ",coloum,value];
    NSLog(@"select\n");
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
        
            char *type_ = (char *)sqlite3_column_text(statement, 3);
            NSString *typeStr = [[NSString alloc] initWithUTF8String:type_];
            
            info = [[NSString alloc] initWithFormat:@"%@ - %@ - %@ - %@",
                    idStr,dateStr, costStr, typeStr];
            
            NSLog(@"select :%@",info);
            info = [NSString stringWithString:costStr];
            [idStr release];
            [dateStr release];
            [costStr release];
            [typeStr release];
        }
        
        sqlite3_finalize(statement);
    }
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



@end
