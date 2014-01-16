//
//  SoundsListViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsListViewController.h"
#import "DataManager.h"
#import "Music.h"

@interface SoundsListViewController ()

@end

@implementation SoundsListViewController

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
	// Do any additional setup after loading the view.
    [self navgationImage:@"header_sound_list"];

    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    self.hidesBottomBarWhenPushed = YES;

    
    dataManager = [DataManager sharedManager];

    [dataManager getLoadMusicList];
    
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.separatorStyle = NO;

    [tableViews reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

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
    if (indexPath.row==0) {
        bgImg.image = [UIImage imageNamed:@"list_top"];
    }
    else if (indexPath.row==dataManager.musicList.count-1)
    {
        bgImg.image = [UIImage imageNamed:@"list_bottom"];
    }
    else
    {
        bgImg.image = [UIImage imageNamed:@"list_middle"];
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
    nameLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:15];

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Music *music = (Music *)[dataManager.musicList objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:music.ID] forKey:@"musicID"];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",music.name] forKey:@"musicName"];
    
    
    [tableViews reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
