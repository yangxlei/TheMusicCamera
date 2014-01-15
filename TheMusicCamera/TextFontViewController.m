//
//  TextFontViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 14-1-8.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "TextFontViewController.h"
#import "DataManager.h"
#import "CustomButton.h"

@interface TextFontViewController ()

@end

@implementation TextFontViewController

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
    self.hidesBottomBarWhenPushed = YES;

    colorButton.selected = YES;
    fontButton.selected = NO;

    [self navgationImage:@"header_mojiire"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editBtn = [self navgationButton:@"button_OK" andFrame:CGRectMake(250, 10, 62, 31)];
    [editBtn addTarget:self action:@selector(okBtuuon) forControlEvents:UIControlEventTouchUpInside];

    for (int i=0; i<2; i++) {
        for (int j=0; j<5; j++) {
            CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(25+60*j, 75+65*i, 35, 35);
            button.tag = i*5+j+1;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"color%d",i*5+j+1]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(colorButton:) forControlEvents:UIControlEventTouchUpInside];
            [colorView addSubview:button];
        }
    }
    NSArray *fontArray = @[@"APJapanesefont", @"HuiFont", @"MakibaFont", @"OhisamaFont", @"VL Gothic"];
    
    for (int q=0; q<5; q++) {
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(25, 30+40*q, 135, 40);
        button.tag = q+11;
        button.titleLabel.font = [UIFont fontWithName:[fontArray objectAtIndex:q] size:22];
        button.fontStr = [fontArray objectAtIndex:q];
        [button setTitle:@"■あいうabc" forState:UIControlStateNormal];
//        button.tintColor = [UIColor colorWithRed:166/255.f green:116/255.f blue:63/255.f alpha:1];
        [button setTitleColor:[UIColor colorWithRed:166/255.f green:116/255.f blue:63/255.f alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(fontButton:) forControlEvents:UIControlEventTouchUpInside];
        [fontView addSubview:button];
    }

    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:t];

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

- (void)okBtuuon
{
//    [self.delegate selectColor:textView.textColor andFont:textView.font];
    
    [self.delegate selectTextView:textView];

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)colorButton:(CustomButton *)button
{
    switch (button.tag) {
        case 1:
        {
            textView.textColor = [UIColor colorWithRed:255/255.f green:102/255.f blue:98/255.f alpha:1];
        }
            break;
        case 2:
        {
            textView.textColor = [UIColor colorWithRed:255/255.f green:183/255.f blue:98/255.f alpha:1];

        }
            break;
        case 3:
        {
            textView.textColor = [UIColor colorWithRed:255/255.f green:238/255.f blue:98/255.f alpha:1];

        }
            break;
        case 4:
        {
            textView.textColor = [UIColor colorWithRed:168/255.f green:255/255.f blue:98/255.f alpha:1];

        }
            break;
        case 5:
        {
            textView.textColor = [UIColor colorWithRed:98/255.f green:255/255.f blue:201/255.f alpha:1];
        }
            break;
        case 6:
        {
            textView.textColor = [UIColor colorWithRed:98/255.f green:139/255.f blue:255/255.f alpha:1];
        }
            break;
        case 7:
        {
            textView.textColor = [UIColor colorWithRed:187/255.f green:98/255.f blue:255/255.f alpha:1];
        }
            break;
        case 8:
        {
            textView.textColor = [UIColor colorWithRed:255/255.f green:98/255.f blue:187/255.f alpha:1];
        }
            break;
        case 9:
        {
            textView.textColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        }
            break;
        case 10:
        {
            textView.textColor = [UIColor colorWithRed:65/255.f green:65/255.f blue:65/255.f alpha:1];
        }
            break;

        default:
            break;
    }
}

- (void)fontButton:(CustomButton *)button
{
    textView.font = [UIFont fontWithName:button.fontStr size:22];
}

- (IBAction)colorBtn:(id)sender
{
    
    colorView.hidden = NO;
    fontView.hidden = YES;
    colorButton.selected = YES;
    fontButton.selected = NO;
}

- (IBAction)fontBtn:(id)sender
{
    fontView.hidden = NO;
    colorView.hidden = YES;
    colorButton.selected = NO;
    fontButton.selected = YES;

}

-(void) singleTap:(UITapGestureRecognizer*) tap
{
    [textView resignFirstResponder];

}

@end
