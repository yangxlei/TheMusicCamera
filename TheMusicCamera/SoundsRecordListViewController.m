//
//  SoundsRecordListViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-23.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRecordListViewController.h"
#import "DataManager.h"
#import "Music.h"

@interface SoundsRecordListViewController ()

@end

@implementation SoundsRecordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //header_record_sound
    
    [self navgationImage:@"header_record_sound"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    
    dataManager = [DataManager sharedManager];

    [dataManager getLoadRecordMusicList];
    
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = NO;

    [tableViews reloadData];

	// Do any additional setup after loading the view.
}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return dataManager.musicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    Music *music = (Music *)[dataManager.musicList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *bgImg = (UIImageView *)[cell viewWithTag:1];
    if (indexPath.row==0 && dataManager.musicList.count!=1) {
        bgImg.image = [UIImage imageNamed:@"list_1"];
    }
    else if (indexPath.row==dataManager.musicList.count-1 && dataManager.musicList.count!=1)
    {
        bgImg.image = [UIImage imageNamed:@"list_3"];
    }
    else
    {
        bgImg.image = [UIImage imageNamed:@"list_2"];
    }
    
    UIImageView *checkImg = (UIImageView *)[cell viewWithTag:2];
    
    int selectNO = [[[NSUserDefaults standardUserDefaults] objectForKey:@"musicID"] intValue];
    if (selectNO==music.ID) {
        checkImg.hidden = NO;
    }
    else
    {
        checkImg.hidden = YES;
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    nameLabel.text = [NSString stringWithFormat:@"%@",music.name];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Music *music = (Music *)[dataManager.musicList objectAtIndex:indexPath.row];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:music.ID] forKey:@"musicID"];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",music.name] forKey:@"musicName"];
//    
//    
//    [tableViews reloadData];
    
    
}

@end
