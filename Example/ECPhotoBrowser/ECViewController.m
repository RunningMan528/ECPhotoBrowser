//
//  ECViewController.m
//  ECPhotoBrowser
//
//  Created by RunningMan528 on 09/11/2020.
//  Copyright (c) 2020 RunningMan528. All rights reserved.
//

#import "ECViewController.h"
#import "ECPhotoBrowserContrller.h"

@interface ECViewController ()

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testClick:(id)sender {
    
    NSMutableArray *imageArr = [NSMutableArray array];
    UIImage *image01 = [UIImage imageNamed:@"IMG_7434"];
    [imageArr addObject:image01];
    
    UIImage *image02 = [UIImage imageNamed:@"IMG_7436"];
    [imageArr addObject:image02];
    
    UIImage *image03 = [UIImage imageNamed:@"IMG_7440"];
    [imageArr addObject:image03];
    
    ECPhotoBrowserContrller *browserVc = [[ECPhotoBrowserContrller alloc]initWithImageArr:imageArr currentIndex:1 longpress:^{
        NSLog(@"我长按图片了.......");
    } dissmiss:^(id  _Nonnull reslut) {
        
    }];
    browserVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:browserVc animated:YES completion:nil];
    
    
}

@end
