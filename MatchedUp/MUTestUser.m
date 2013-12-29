//
//  MUTestUser.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/12/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

+(void)saveTestUserToParse01
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user01";
    newUser.password = @"password01";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @19,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"MonkeyFace",
                                      @"gender" : @"female",
                                      @"location" : @"NYC, USA",
                                      @"name" : @"Monkeyface Apes"};
            [newUser setObject:profile forKey:@"profile"];
            //[newUser setObject:@"I'm as cute as a button and I know it!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"babymonkey.jpg"];
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

+(void)saveTestUserToParse02
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user02";
    newUser.password = @"password02";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Julie",
                                      @"gender" : @"female",
                                      @"location" : @"Berlin, Germany",
                                      //@"tagLine" : @"I like to climb",
                                      @"name" : @"Julie Adams"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"" forKey:kMUUserTagLineKey];
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


+(void)saveTestUserToParse03
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user03";
    newUser.password = @"password03";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Dee Dee",
                                      @"gender" : @"female",
                                      @"location" : @"Philly, PA",
                                      @"name" : @"Dee Dee Barker"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"I need a bath!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"doggie.jpg"];
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


+(void)saveTestUserToParse04
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user04";
    newUser.password = @"password04";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @22,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Dan",
                                      @"gender" : @"male",
                                      @"location" : @"San Francisco, California",
                                      @"name" : @"Dan Ducky"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"Quack, quack, quack!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"duckling.jpg"];
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


+(void)saveTestUserToParse05
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user05";
    newUser.password = @"password05";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @77,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Fanny",
                                      @"gender" : @"female",
                                      @"location" : @"South Africa",
                                      @"name" : @"Fanny Ferret"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"I love to borrow!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"ferret.jpg"];
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


+(void)saveTestUserToParse06
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user06";
    newUser.password = @"password06";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Hank",
                                      @"gender" : @"male",
                                      @"location" : @"Washington, DC",
                                      @"name" : @"Hank Hog"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"I'm the one that you want." forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"hedghog.jpg"];
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


+(void)saveTestUserToParse07
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user07";
    newUser.password = @"password07";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @28,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Dorothy",
                                      @"gender" : @"female",
                                      @"location" : @"Topeka, Kansas",
                                      @"name" : @"Dorothy Sounder"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"Do you hear what I hear?" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"longears.jpg"];
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


+(void)saveTestUserToParse08
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user08";
    newUser.password = @"password08";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @18,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Sam",
                                      @"gender" : @"male",
                                      @"location" : @"Beijing, China",
                                      @"name" : @"Sam Chin"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"Hi!  I'm Sam, your man!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"pandababy.jpg"];
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


+(void)saveTestUserToParse09
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user09";
    newUser.password = @"password09";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @44,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Martha",
                                      @"gender" : @"female",
                                      @"location" : @"Toronto, Canada",
                                      @"name" : @"Martha Katz"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"Please, God, find me a mate!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"prayingkitten.jpg"];
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


+(void)saveTestUserToParse10
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user10";
    newUser.password = @"password10";

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSDictionary *profile = @{@"age" : @22,
                                      @"birthday" : @"11/22/1985",
                                      @"firstName" : @"Max",
                                      @"gender" : @"male",
                                      @"location" : @"Honolulu, Hawaii",
                                      @"name" : @"Max Biter"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser setObject:@"Please pick me!" forKey:kMUUserTagLineKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"twopawspuppy"];
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
