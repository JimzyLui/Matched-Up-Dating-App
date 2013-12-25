//
//  MUMatchVC.h
//  MatchedUp
//
//  Created by Jimzy Lui on 12/16/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUMatchVCDelegate <NSObject>

-(void)presentMatchesViewController;

@end

@interface MUMatchVC : UIViewController

@property(strong,nonatomic) UIImage *matchedUserImage;
@property(weak,nonatomic)id<MUMatchVCDelegate>delegate;

@end
