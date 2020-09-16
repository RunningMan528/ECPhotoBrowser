//
//  ECBrowserCell.h
//  ECPhotoBrowser
//
//  Created by peixu on 2020/9/11.
//

#import <UIKit/UIKit.h>

@class ECBrowserCell,ECPhotoBrowserCell,ECPhotoPreView;

NS_ASSUME_NONNULL_BEGIN

@interface ECBrowserCell : UICollectionViewCell

@property (nonatomic,copy) void (^singleTapGestureBlock)(void);
@property (nonatomic,copy) void (^longPressGestureBlock)(void);
@property (nonatomic,strong) UIImage *previewImage;
- (void)configSubViews;
- (void)photoPreVIewCollectionViewDidScroll;

@end

@interface ECPhotoBrowserCell : ECBrowserCell

@property (nonatomic,strong) ECPhotoPreView *previewView;
@property (nonatomic,assign) BOOL allowCrop;
@property (nonatomic,assign) CGRect cropRect;

- (void)recoverCellSubViews;

@end

@interface ECPhotoPreView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *previewImage;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *imageContainerView;
@property (nonatomic,assign) BOOL allowCrop;
@property (nonatomic,assign) CGRect cropRect;
@property (nonatomic,copy) void (^singleTapGestureBlock)(void);
@property (nonatomic,copy) void (^longPressGestureBlock)(void);
- (void)recoverSubViews;

@end

NS_ASSUME_NONNULL_END
