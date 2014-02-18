//
//  SoundsRepeatViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRepeatViewController.h"
#import "DataManager.h"

@interface SoundsRepeatViewController ()

@end

@implementation SoundsRepeatViewController

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
//    [self navgationImage:@"header_sound_list"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_sound_list",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    self.hidesBottomBarWhenPushed = YES;

    
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *bgImg = (UIImageView *)[cell viewWithTag:1];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    if (indexPath.row==0) {
        bgImg.image = [UIImage imageNamed:@"list_top"];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            nameLabel.text = [NSString stringWithFormat:@"无"];
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            nameLabel.text = [NSString stringWithFormat:@"NO"];
        }
        else
        {
            nameLabel.text = [NSString stringWithFormat:@"なし"];
        }

    }
    else
    {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:3];
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            nameLabel.text = [NSString stringWithFormat:@"有"];
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            nameLabel.text = [NSString stringWithFormat:@"YES"];
        }
        else
        {
            nameLabel.text = [NSString stringWithFormat:@"あり"];//有
        }

        bgImg.image = [UIImage imageNamed:@"list_bottom"];
    }
    
//    nameLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:15];

    UIImageView *checkImg = (UIImageView *)[cell viewWithTag:2];
    
    int selectNO = [[[NSUserDefaults standardUserDefaults] objectForKey:@"musicrepeat"] intValue];
    if (selectNO==indexPath.row) {
        checkImg.hidden = NO;
    }
    else
    {
        checkImg.hidden = YES;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"musicrepeat"];
    
    [tableViews reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
