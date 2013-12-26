//
//  SoundsRecordListViewController.h
//  TheMusicCamera
//
//  Created by song on 13-12-23.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataManager;

@interface SoundsRecordListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tableViews;
    DataManager *dataManager;

    BOOL isEdit;
    int selectIndex;
}

@end
