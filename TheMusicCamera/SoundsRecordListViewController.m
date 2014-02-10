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
#import "CustomButton.h"

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
    
//    [self navgationImage:@"header_record_sound"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_record_sound",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editBtn = [self navgationButton:[NSString stringWithFormat:@"%@btn_edit",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]] andFrame:CGRectMake(250, 7, 62, 31)];
    [editBtn addTarget:self action:@selector(editBtuuon:) forControlEvents:UIControlEventTouchUpInside];

    self.hidesBottomBarWhenPushed = YES;

    dataManager = [DataManager sharedManager];

    [dataManager getLoadRecordMusicList];
    
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = NO;

    [tableViews reloadData];

    isEdit = NO;
    selectIndex = -1;
    
	// Do any additional setup after loading the view.
}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
    
}

- (void)editBtuuon:(UIButton *)button
{
    if (isEdit) {
        isEdit = NO;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@btn_edit",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forState:UIControlStateNormal];
        selectIndex = -1;
    }
    else
    {
        isEdit = YES;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@button_finish",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forState:UIControlStateNormal];
    }
    [tableViews reloadData];

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
    return dataManager.recordMusicList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    Music *music = (Music *)[dataManager.recordMusicList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *bgImg = (UIImageView *)[cell viewWithTag:1];
    if (indexPath.row==0 && dataManager.recordMusicList.count!=1) {
        bgImg.image = [UIImage imageNamed:@"list_top"];
    }
    else if (indexPath.row==0 && dataManager.recordMusicList.count==1)
    {
        bgImg.image = [UIImage imageNamed:@"list"];
    }
    else if (indexPath.row==dataManager.recordMusicList.count-1 && dataManager.recordMusicList.count!=1)
    {
        bgImg.image = [UIImage imageNamed:@"list_bottom"];
    }
    else
    {
        bgImg.image = [UIImage imageNamed:@"list_middle"];
    }
    
    UIImageView *editImg = (UIImageView *)[cell viewWithTag:4];
    if (!isEdit) {
        editImg.hidden = YES;
    }
    else
    {
        editImg.hidden = NO;
    }
    
//    UIImageView *checkImg = (UIImageView *)[cell viewWithTag:2];
//    
    if (selectIndex==indexPath.row) {
//        checkImg.hidden = NO;
        editImg.image = [UIImage imageNamed:@"check_mark_dot"];
    }
    else
    {
//        checkImg.hidden = YES;
        editImg.image = [UIImage imageNamed:@"check_mark_blank"];
    }

    CustomButton *deleteBtn = (CustomButton *)[cell viewWithTag:2];
    int listNO = indexPath.row+10;
    NSLog(@"%d",listNO);

    deleteBtn.listNo = indexPath.row+10;
    [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (isEdit && selectIndex == indexPath.row) {
        deleteBtn.hidden = NO;
    }
    else
    {
        deleteBtn.hidden = YES;
    }

    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    nameLabel.text = [NSString stringWithFormat:@"%@",music.name];
    nameLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:15];

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isEdit) {
        selectIndex = indexPath.row;
        [tableViews reloadData];
    }else
    {
        selectIndex = -1;
    }
    

//    Music *music = (Music *)[dataManager.musicList objectAtIndex:indexPath.row];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:music.ID] forKey:@"musicID"];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",music.name] forKey:@"musicName"];
//    
//    
//    [tableViews reloadData];
    
    
}

- (void)deleteBtn:(CustomButton *)button
{
//tableViews deleteRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
    Music *music = (Music *)[dataManager.recordMusicList objectAtIndex:button.listNo-10];
    [dataManager.recordMusicList removeObjectAtIndex:button.listNo-10];
    [dataManager deleteMusicWithID:music.ID];
    
    [dataManager getLoadRecordMusicList];

    [tableViews reloadData];
    
}

@end
