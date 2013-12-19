//
//  SoundsListViewController.h
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataManager;

@interface SoundsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tableViews;
    DataManager *dataManager;
    
}

@end
