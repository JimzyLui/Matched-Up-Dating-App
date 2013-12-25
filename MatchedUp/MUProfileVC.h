//
//  MUProfileVC.h
//  MatchedUp
//
//  Created by Jimzy Lui on 12/12/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUProfileVCDelegate <NSObject>

-(void)didPressLike;
-(void)didPressDislike;

@end
@interface MUProfileVC : UIViewController

@property(weak,nonatomic)id<MUProfileVCDelegate>delegate;

@property(strong,nonatomic)PFObject *photo;

@end
