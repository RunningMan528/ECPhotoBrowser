//
//  ECPhotoBrowserContrller.m
//  ECPhotoBrowser_Example
//
//  Created by peixu on 2020/9/11.
//  Copyright © 2020 RunningMan528. All rights reserved.
//

#import "ECPhotoBrowserContrller.h"
#import "ECBrowserCell.h"
#import "UIView+Layout.h"

@interface ECPhotoBrowserContrller ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UILabel *_titleLab;
    
    CGFloat _offsetItemCount;
}

@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, assign) double progress;

@end

@implementation ECPhotoBrowserContrller

- (instancetype)initWithImageArr:(NSArray *)imageArr
                    currentIndex:(NSInteger)currentIndex
                       longpress:(nonnull void (^)(void))longpress
                        dissmiss:(nonnull void (^)(id _Nonnull))dissmissBlock{
    if (self = [super init]) {
        _imageArray = imageArr;
        _currentIndex = currentIndex;
        _dissmissBlock = dissmissBlock;
        _longpressBlock = longpress;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configCustomNaviBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.tz_width + 20) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCustomNaviBar {
    
    CGFloat kAppNavigationBarHeight = 44;
    CGFloat kAppStatusBarHeight = isIPhoneXSeries() ? 44 : 20;
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, kAppStatusBarHeight + kAppNavigationBarHeight)];
    _naviBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:_naviBar];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kAppStatusBarHeight + 5, 50, 25)];
    _backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [currentBundle pathForResource:@"icon_guanbibaise.png" ofType:nil inDirectory:@"ECPhotoBrowser.bundle"];
    [_backButton setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:_backButton];
    
    _titleLab = [UILabel new];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont boldSystemFontOfSize:20];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.text = [NSString stringWithFormat:@"照片(%@/%@)",[NSString stringWithFormat:@"%ld",_currentIndex+1], [NSString stringWithFormat:@"%ld",self.imageArray.count]];
    _titleLab.frame = CGRectMake(60, kAppStatusBarHeight, self.view.tz_width - 120, kAppNavigationBarHeight);
    [_naviBar addSubview:_titleLab];
    
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.imageArray.count * (self.view.tz_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ECPhotoBrowserCell class] forCellWithReuseIdentifier:@"ECPhotoBrowserCell"];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _layout.itemSize = CGSizeMake(self.view.tz_width + 20, self.view.tz_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.tz_width + 20, self.view.tz_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}


- (void)backButtonClick {
    if (self.dissmissBlock) {
        self.dissmissBlock(self.imageArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapPreviewCell {
    self.isHideNaviBar = !self.isHideNaviBar;
    CGFloat alpha = self.isHideNaviBar?0:1;
    [UIView animateWithDuration:0.1 animations:^{
        self->_naviBar.alpha = alpha;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.tz_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.tz_width + 20);
    
    if (currentIndex < _imageArray.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *currentImage = _imageArray[indexPath.item];
    ECPhotoBrowserCell *photoPreviewCell = (ECPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ECPhotoBrowserCell" forIndexPath:indexPath];;
    photoPreviewCell.cropRect = CGRectZero;
    photoPreviewCell.allowCrop = NO;
     __weak typeof(self) weakSelf = self;
    [photoPreviewCell setLongPressGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.longpressBlock) {
            strongSelf.longpressBlock();
        }
    }];
        
    photoPreviewCell.previewImage = currentImage;
    [photoPreviewCell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];
    return photoPreviewCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ECPhotoBrowserCell class]]) {
        ECPhotoBrowserCell *photocell = (ECPhotoBrowserCell *)cell;
        [photocell recoverCellSubViews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ECPhotoBrowserCell class]]) {
        ECPhotoBrowserCell *photocell = (ECPhotoBrowserCell *)cell;
        [photocell recoverCellSubViews];
    }
}

#pragma mark - Private Method

- (void)dealloc {
     
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshNaviBarAndBottomBarState {
    _titleLab.text = [NSString stringWithFormat:@"照片(%@/%@)",[NSString stringWithFormat:@"%ld",_currentIndex+1], [NSString stringWithFormat:@"%ld",self.imageArray.count]];
}

static inline BOOL isIPhoneXSeries() {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}
//底部安全区域距离
static inline CGFloat kAPPBottomHeight() {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        return mainWindow.safeAreaInsets.bottom;
    }
    return 0.f;
}


@end
