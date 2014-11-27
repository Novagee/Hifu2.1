//
//  YXPhotoLibraryViewController.m
//  HiFuCalendar
//
//  Created by Yin Xu on 6/22/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//

#import "YXPhotoLibraryViewController.h"
#import "YXImageCollectionItemCell.h"
#import "YXImagePickerViewController.h"

@interface YXPhotoLibraryViewController ()
{
    UIImagePickerControllerCameraFlashMode flashMode;  //there is a bug for iOS7.1 flashMode http://stackoverflow.com/questions/23156163/ios-7-1-flash-mode-dont-work
    YXImagePickerViewController *imagePickerController;
//    NSMutableArray *selectedImageArray;
    NSIndexPath *selectedIndexPath;
    UIImage *selectImage;
}

@end

@implementation YXPhotoLibraryViewController

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
    [self.imagesCollectionView registerNib:[YXImageCollectionItemCell cellNib] forCellWithReuseIdentifier:[YXImageCollectionItemCell reuseIdentifier]];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [HFUIHelpers generateNavBarBackButton];    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.selectedPhotoCount.layer.cornerRadius = self.selectedPhotoCount.frame.size.height / 2;
    self.selectedPhotoCount.text = @"0";
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadImageFromPhotoLibrary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXImageCollectionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YXImageCollectionItemCell reuseIdentifier] forIndexPath:indexPath];
    cell.pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.assets objectAtIndex:indexPath.row]).thumbnail];
    return cell;
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXImageCollectionItemCell *cell = (YXImageCollectionItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell checkImage];
    
    if (indexPath != selectedIndexPath) {
        YXImageCollectionItemCell *cell = (YXImageCollectionItemCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
        [cell checkImage];
        selectedIndexPath = indexPath;
    }
}

#pragma mark - Helper Methods
- (void)loadImageFromPhotoLibrary
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    self.assetsFilter = [ALAssetsFilter allAssets];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [group setAssetsFilter:self.assetsFilter];
            if (group.numberOfAssets > 0 )
            {
                self.assetsGroup = group;
                if (!self.assets)
                    self.assets = [[NSMutableArray alloc] init];
                else
                    [self.assets removeAllObjects];
                
                ALAssetsGroupEnumerationResultsBlock imagesResultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                    
                    if (asset)
                    {
                        NSString *type = [asset valueForProperty:ALAssetPropertyType];
                        if ([type isEqual:ALAssetTypePhoto])
                        {
                            //we want to display the photo which took the most recently at the begining of the array.
                            //so we construct the array by always inserting object at the beginging.
                            [self.assets insertObject:asset atIndex:0];
                        }
                    }
                    else if (self.assets.count > 0)
                    {
                        [self.imagesCollectionView reloadData];
                    }
                };
                
                [self.assetsGroup enumerateAssetsUsingBlock:imagesResultsBlock];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
    
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    //    NSUInteger type =
    //    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    //    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    //
    //    [self.assetsLibrary enumerateGroupsWithTypes:type
    //                                      usingBlock:resultsBlock
    //                                    failureBlock:failureBlock];
    
}

#pragma mark - Action Methods
- (IBAction)doneButtonClicked:(id)sender
{
    if (selectedIndexPath) {
        ALAsset *asset = [self.assets objectAtIndex:selectedIndexPath.row];
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        UIImage *image = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage] scale:1 orientation:orientation];
        [[NSNotificationCenter defaultCenter] postNotificationName:HFFinishPickingPhotos object:image];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)switchToCameraButtonClicked:(id)sender;
{
    if (!imagePickerController) {
        imagePickerController = [[YXImagePickerViewController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.extendedLayoutIncludesOpaqueBars = YES;
        imagePickerController.navigationBarHidden=YES;
        imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(1.2, 1.2);
        // we have our custom overlay view for the camera. so hide the default controls
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"CameraOverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)closeButtonOnPhotoLibraryClicked
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraTakePhotoButtonClicked:(id)sender
{
    [imagePickerController takePicture];
}

- (IBAction)cameraCloseButtonClicked:(id)sender
{
    [imagePickerController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cameraFlipButtonClicked:(id)sender
{
    if (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront)
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    else
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}

- (IBAction)cameraFlashButtonClicked:(id)sender
{
    switch (flashMode) {
        case UIImagePickerControllerCameraFlashModeOff:
            [imagePickerController setCameraFlashMode: UIImagePickerControllerCameraFlashModeAuto];
            flashMode = UIImagePickerControllerCameraFlashModeAuto;
            break;
        case UIImagePickerControllerCameraFlashModeAuto:
            [imagePickerController setCameraFlashMode: UIImagePickerControllerCameraFlashModeOn];
            flashMode = UIImagePickerControllerCameraFlashModeOn;
            break;
        default:
            [imagePickerController setCameraFlashMode: UIImagePickerControllerCameraFlashModeOff];
            flashMode = UIImagePickerControllerCameraFlashModeOff;
            break;
    }
    
    [self changeFlashModeTitle:flashMode];
}

- (void)changeFlashModeTitle: (UIImagePickerControllerCameraFlashMode) cameraFlashMode
{
    switch (cameraFlashMode) {
        case UIImagePickerControllerCameraFlashModeOff:
            [self.overlayFlashButton setTitle:@"    Off" forState:UIControlStateNormal];
//            [self.overlayFlashButton setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
            break;
        case UIImagePickerControllerCameraFlashModeAuto:
            [self.overlayFlashButton setTitle:@"    Auto" forState:UIControlStateNormal];
//            [self.overlayFlashButton setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
            
            break;
        default:
            [self.overlayFlashButton setTitle:@"    On" forState:UIControlStateNormal];
//            [self.overlayFlashButton setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [imagePickerController dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:HFFinishTakingPicture object:image];
    }];
    imagePickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}


@end
