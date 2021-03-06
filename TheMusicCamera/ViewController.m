//
//  ViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ViewController.h"

#import "SoundsViewController.h"
#import "PhontoViewController.h"
#import "SettingViewController.h"
#import "ShareViewController.h"
#import "DataManager.h"
#import "CameraController.h"
#import "ProcessGLView.h"
#import "MQUIImage.h"
ViewController *_viewController;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _viewController = self;
  
    NSArray *fontArray = [UIFont familyNames];
//    NSLog(@"fontArray  %@",fontArray);
    
    firstEntry = YES;

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"currentLanguage====   %@" , currentLanguage);
    
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"c_"] forKey:@"languages"];
    }else if ([currentLanguage isEqualToString:@"en"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"e_"] forKey:@"languages"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@""] forKey:@"languages"];
    }
    
    [self loadMainView];
    
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"musicID"]]isEqualToString:@"(null)"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicID"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"default01.wav"] forKey:@"musicName"];


        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicrepeat"];

        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicOFF"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicstation"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"imageSize"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"appStore"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"shareImage"];

    }
    
    
    dataManager = [DataManager sharedManager];
    
}

- (void)loadMainView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    bpVC = [storyboard instantiateViewControllerWithIdentifier:@"BeautifiedPictureViewController"];
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
    NSLog(@"%@",[NSString stringWithFormat:@"%@main_tab_decoration_off",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]);
	[imgDic setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_decoration_off",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Default"];
    
    [imgDic setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_decoration_on",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_decoration_on",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Seleted"];

	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_sound_off.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_sound_on.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_sound_on.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Seleted"];

	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_camera.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_camera.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_camera.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Seleted"];

	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_setting_off.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_setting_on.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_setting_on.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Seleted"];

	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_osusume_off.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_osusume_off.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@main_tab_osusume_off.png",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]] forKey:@"Seleted"];

	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
	self.mainTabBarController = [[GTTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    //	[self.mainTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom-bg.png"]];
	[self.mainTabBarController setTabBarTransparent:YES];
    self.mainTabBarController.delegate = self;
    
    self.mainTabBarController.selectedIndex = 2;
    
//    self.mainTabBarController.animateDriect = 0;
    
    [self.view addSubview:self.mainTabBarController.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnPhotoVC:) name:@"RETURNPHOTOVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnShareVC:) name:@"RETURNSHAREVC" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed|| [viewController isKindOfClass:[VPImageCropperViewController class]])
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

- (void)tabBarController:(GTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
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
            if (dataManager.isPhotoView) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"camera" bundle:[NSBundle mainBundle]];
                CameraController *camera = [storyboard instantiateViewControllerWithIdentifier:@"CameraController"];
                [(UINavigationController*)viewController pushViewController:camera animated:YES];
            }
        }
        else if (tabBarController.selectedIndex == 0)
        {
            [self.mainTabBarController hidesTabBar:YES animated:YES];
//            [self performSelector:@selector(laterBegin) withObject:nil afterDelay:1];
            [bpVC begin];//leileilei

        }
    }
}

//- (void)laterBegin
//{
//    [bpVC begin];//leileilei
//}

- (void) returnPhotoVC: (NSNotification*) aNotification
{
    dataManager.isPhotoView = NO;
    [self.mainTabBarController hidesTabBar:NO animated:YES];
    self.mainTabBarController.selectedIndex = 2;

}

- (void) returnShareVC: (NSNotification*) aNotification
{
    [self.mainTabBarController hidesTabBar:NO animated:YES];
    self.mainTabBarController.selectedIndex = 4;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHAREVC" object:nil];
}

+(UIViewController*) shareInstance
{
  return _viewController;
}

@end
