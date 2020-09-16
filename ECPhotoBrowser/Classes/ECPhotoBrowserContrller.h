//
//  ECPhotoBrowserContrller.h
//  ECPhotoBrowser_Example
//
//  Created by peixu on 2020/9/11.
//  Copyright © 2020 RunningMan528. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片浏览器
@interface ECPhotoBrowserContrller : UIViewController

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,copy) void (^dissmissBlock)(id result);
@property (nonatomic,copy) void (^longpressBlock)(void);

- (instancetype)initWithImageArr:(NSArray *)imageArr
                    currentIndex:(NSInteger)currentIndex
                       longpress:(void(^)(void))longpress
                        dissmiss:(void(^)(id reslut))dissmissBlock;

@end

NS_ASSUME_NONNULL_END
