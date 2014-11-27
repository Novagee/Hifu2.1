//
//  YXPhotoLibraryViewController.h
//  HiFuCalendar
//
//  Created by Yin Xu on 6/22/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YXPhotoLibraryViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
/// Set the ALAssetsFilter to filter the picker contents.
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) BOOL shouldCameraShow;

@property (nonatomic, weak) IBOutlet UICollectionView *imagesCollectionView;
@property (nonatomic, weak) IBOutlet UILabel *selectedPhotoCount;

- (IBAction)switchToCameraButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
//***************Camera***************//

//overlayView for camera

@property (nonatomic, weak) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIButton *overlayTakePictureButton;
@property (nonatomic, weak) IBOutlet UIButton *overlayFlashButton;

- (IBAction)cameraTakePhotoButtonClicked:(id)sender;
- (IBAction)cameraCloseButtonClicked:(id)sender;
- (IBAction)cameraFlipButtonClicked:(id)sender;
- (IBAction)cameraFlashButtonClicked:(id)sender;

@end
