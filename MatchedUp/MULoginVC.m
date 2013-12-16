//
//  MULoginVC.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/7/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MULoginVC.h"

@interface MULoginVC ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic)NSMutableData *imageData;
@end

@implementation MULoginVC

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
	// Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday",@"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if(!user) {
            if (!error) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Log In Error"
                                                message:@"The Facebook Login was Canceled"
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Log In Error"
                                                message:[error description]
                                               delegate:nil
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Method

-(void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        //NSLog(@"%@", result);
        
        if (!error) {
            NSDictionary *userDict = (NSDictionary *)result;
            
            //Create URL
            NSString *facebookID = userDict[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            if (userDict[kMUUserProfileNameKey]) {
                userProfile[kMUUserProfileNameKey] = userDict[kMUUserProfileNameKey];
            }
            if (userDict[@"firstName"]) {
                userProfile[kMUUserProfileFirstNameKey] = userDict[@"firstName"];
            }
            if (userDict[kMUUserProfileLocationKey][kMUUserProfileNameKey]) {
                userProfile[kMUUserProfileLocationKey] = userDict[kMUUserProfileLocationKey][kMUUserProfileNameKey];
            }
            if (userDict[kMUUserProfileGenderKey]){
                userProfile[kMUUserProfileGenderKey] = userDict[kMUUserProfileGenderKey];
            }
            if (userDict[kMUUserProfileBirthdayKey]) {
                userProfile[kMUUserProfileBirthdayKey] = userDict[kMUUserProfileBirthdayKey];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                NSDate *date = [formatter dateFromString:userDict[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds/31536000;
                userProfile[KMUUserProfileAgeKey] = @(age);
            }
            if (userDict[kMUUserProfileInterestedInKey]) {
                userProfile[kMUUserProfileInterestedInKey] = userDict[kMUUserProfileInterestedInKey];
            }
            if (userDict[@"relationship_status"]) {
                userProfile[kMUUserProfileRelationshipStatusKey] = userDict[@"relationship_status"];
            }
            if ([pictureURL absoluteString]) {
                userProfile[kMUUserProfilePictureURLKey] = [pictureURL absoluteString];
            }
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            
            [[PFUser currentUser] saveInBackground];
            
            [self requestImage];
        }
        else{
            NSLog(@"Error in FB request %@",error);
        }
    }];
}

-(void)uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if(!imageData){
        NSLog(@"imageData was not found");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kMUPhotoUserKey];
            [photo setObject:photoFile forKey:kMUPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo saved successfully");
            }];
        }
    }];
}

-(void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            NSURL *profilePictureURL = [NSURL URLWithString:user [kMUUserProfileKey][kMUUserProfilePictureURLKey]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection) {
                NSLog(@"Failed to Download Picture");
            }
        }
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

















@end
