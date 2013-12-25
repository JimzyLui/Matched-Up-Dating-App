//
//  MUTestUser.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/12/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

+(void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      //@"firstName" : @"Julie",
                                      @"gender" : @"female",
                                      @"location" : @"Berlin, Germany",
                                      //@"tagLine" : @"I like to climb",
                                      @"name" : @"Julie Adams"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"catinhat.jpg"];
                //NSLog(@"%@", profileImage);
                NSData *imageData = UIImageJPEGRepresentation(profileImage,0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
                        [photo setObject:newUser forKey:kMUPhotoUserKey];
                        [photo setObject:photoFile forKey:kMUPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Test photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
}


@end
