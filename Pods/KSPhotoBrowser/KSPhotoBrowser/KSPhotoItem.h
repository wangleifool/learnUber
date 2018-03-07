//
//  KSPhotoItem.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KSPhotoItem : NSObject

@property (nonatomic, strong, readonly, nullable) UIView *sourceView;
@property (nonatomic, strong, readonly, nullable) UIImage *thumbImage;
@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, strong, readonly, nullable) PHAsset *imageAsset;
@property (nonatomic, strong, readonly, nullable) NSURL *imageUrl;
@property (nonatomic, assign) BOOL finished;

- (nonnull instancetype)initWithSourceView:(nullable UIView *)view
                                thumbImage:(nullable UIImage *)image
                                  imageUrl:(nullable NSURL *)url;
- (nonnull instancetype)initWithSourceView:(nullable UIImageView * )view
                                  imageUrl:(nullable NSURL *)url;
- (nonnull instancetype)initWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image;
- (nonnull instancetype)initWithSourceView:(nullable UIImageView *)view
                                imageAsset:(nullable PHAsset *)asset;

+ (nonnull instancetype)itemWithSourceView:(nullable UIView *)view
                                thumbImage:(nullable UIImage *)image
                                  imageUrl:(nullable NSURL *)url;
+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                  imageUrl:(nullable NSURL *)url;
+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image;
+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                imageAsset:(nullable PHAsset *)asset;

@end
