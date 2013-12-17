//
//  ViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ViewController.h"
#import "BeautifiedPictureViewController.h"
#import "SoundsViewController.h"
#import "PhontoViewController.h"
#import "SettingViewController.h"
#import "ShareViewController.h"
#import "DataManager.h"
#import "CameraController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    firstEntry = YES;

    [self loadMainView];
    
    dataManager = [DataManager sharedManager];
    
}

- (void)loadMainView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BeautifiedPictureViewController *bpVC = [storyboard instantiateViewControllerWithIdentifier:@"BeautifiedPictureViewController"];
    UINavigationController *bpNC = [[UINavigationController alloc] initWithRootViewController:bpVC];
    bpNC.delegate = self;
    
    SoundsViewController *soundsVC = [storyboard instantiateViewControllerWithIdentifier:@"SoundsViewController"];
    UINavigationController *soundsNC = [[UINavigationController alloc] initWithRootViewController:soundsVC];
    soundsNC.delegate = self;
    
    PhontoViewController *photoVC = [storyboard instantiateViewControllerWithIdentifier:@"PhontoViewController"];
    UINavigationController *photoNC = [[UINavigationController alloc] initWithRootViewController:photoVC];
    photoNC.delegate = self;
    
    SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController *settingNC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    settingNC.delegate = self;
    
    ShareViewController *shareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    UINavigationController *shareNC = [[UINavigationController alloc] initWithRootViewController:shareVC];
    shareNC.delegate = self;
    
    NSArray *ctrlArr = [NSArray arrayWithObjects:bpNC,soundsNC,photoNC,settingNC,shareNC,nil];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"main_tab_decoration_off.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"main_tab_decoration_on.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"main_tab_decoration_on.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"main_tab_sound_off.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"main_tab_sound_on.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"main_tab_sound_on.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"main_tab_camera.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"main_tab_camera.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"main_tab_camera.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"main_tab_setting_off.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"main_tab_setting_on.png"] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"main_tab_setting_on.png"] forKey:@"Seleted"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"main_tab_osusume_off.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"main_tab_osusume_on.png"] forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"main_tab_osusume_on.png"] forKey:@"Seleted"];
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
	self.mainTabBarController = [[GTTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    //	[self.mainTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom-bg.png"]];
	[self.mainTabBarController setTabBarTransparent:YES];
    self.mainTabBarController.delegate = self;
    
    self.mainTabBarController.selectedIndex = 2;
    
//    self.mainTabBarController.animateDriect = 0;
    
    [self.view addSubview:self.mainTabBarController.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnPhotoVC:) name:@"RETURNPHOTOVC" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed)
    {
        [self.mainTabBarController hidesTabBar:YES animated:YES];
    }
    else
    {
        [self.mainTabBarController hidesTabBar:NO animated:YES];
    }
}

#pragma mark -
#pragma mark GTTabBarControllerDelegate
- (BOOL)tabBarController:(GTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(GTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if (firstEntry) {
        firstEntry = NO;
    }
    else
    {
        NSLog(@"1111 %d %@",(int)tabBarController.selectedIndex,viewController);
        if (tabBarController.selectedIndex==4) {
            [self.mainTabBarController hidesTabBar:YES animated:YES];
        }
        else if (tabBarController.selectedIndex == 2)
        {
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"camera" bundle:[NSBundle mainBundle]];
          CameraController *camera = [storyboard instantiateViewControllerWithIdentifier:@"CameraController"];
          [(UINavigationController*)viewController pushViewController:camera animated:YES];
        }
        else if (tabBarController.selectedIndex == 0)
        {
            [self.mainTabBarController hidesTabBar:YES animated:YES];
//
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//            BeautifiedPictureViewController *bpVC = [storyboard instantiateViewControllerWithIdentifier:@"BeautifiedPictureViewController"];
//            [(UINavigationController*)viewController pushViewController:bpVC animated:YES];
            
        }
    }

}

- (void) returnPhotoVC: (NSNotification*) aNotification
{
    [self.mainTabBarController hidesTabBar:NO animated:YES];
    self.mainTabBarController.selectedIndex = 2;

}

@end
