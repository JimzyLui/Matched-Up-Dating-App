//
//  MUHomeVC.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/12/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUHomeVC.h"
#import "MUTestUser.h"
#import "MUProfileVC.h"
#import "MUMatchVC.h"

@interface MUHomeVC ()<MUMatchVCDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property(strong,nonatomic)NSArray *photos;
@property(strong,nonatomic)PFObject *photo;
@property(strong,nonatomic)NSMutableArray *activities;  //keeps track of who we like/dislike

@property(nonatomic)int currentPhotoIndex;
@property(nonatomic)BOOL isLikedByCurrrentUser;
@property(nonatomic)BOOL isDislikedByCurrentUser;




@end

@implementation MUHomeVC

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
    
    //[MUTestUser saveTestUserToParse];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    self.photoImageView.image = nil;
    self.firstNameLabel.text = nil;
    self.ageLabel.text = nil;

    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;

    self.currentPhotoIndex = 0;

    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];   //don't show self
    [query includeKey:kMUPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error){
             self.photos = objects;
             if ([self allowPhoto] == NO) {
                 [self setupNextPhoto];
             }
             else{
                 [self queryForCurrentPhotoIndex];
             }
         }
         else {
             NSLog(@"%@",error);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"homeToProfileSegue"]){
        MUProfileVC *targetVC = segue.destinationViewController;
        targetVC.photo = self.photo;
    }
    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"]){
        MUMatchVC *targetVC = segue.destinationViewController;
        targetVC.matchedUserImage = self.photoImageView.image;
        targetVC.delegate = self;
    }
}

#pragma mark - IBActions

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];

}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender {
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    NSLog(@"Like Button Pressed");
    [self checkLike];
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

#pragma mark - Helper Methods

-(void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kMUPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"%@", error);
         }];
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForLike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
        [queryForLike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForDislike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeDislikeKey];
        [queryForDislike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike,queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.activities = [objects mutableCopy];
                
                if ([self.activities count] ==0) {
                    self.isLikedByCurrrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                } else{
                    PFObject *activity = self.activities[0];
                    
                    if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityTypeLikeKey]) {
                        self.isLikedByCurrrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityTypeDislikeKey]){
                        self.isLikedByCurrrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else{
                        //Some other type of activity
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
                self.infoButton.enabled = YES;
            }
        }];
        
    }
}

-(void)updateView
{
    self.firstNameLabel.text = self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kMUPhotoUserKey][kMUUserTagLineKey];
}

-(void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex++;
        if ([self allowPhoto] == NO) {
            [self setupNextPhoto];
        } else {
            [self queryForCurrentPhotoIndex];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more users to view" message:@"Check Back Later for More People!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)allowPhoto
{
    int maxAge = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kMUAgeMaxKey];
    BOOL men = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    BOOL women = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    BOOL single = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];

    PFObject *photo = self.photos[self.currentPhotoIndex];
    PFUser *user = photo[kMUPhotoUserKey];
    int userAge = [user[kMUUserProfileKey][kMUUserProfileAgeKey] intValue];
    NSString *gender = user[kMUUserProfileKey][kMUUserProfileGenderKey];
    NSString *relationshipStatus = user[kMUUserProfileKey][kMUUserProfileRelationshipStatusKey];

    if (userAge >= maxAge){
        return NO;
    }
    else if (men == NO && [gender isEqualToString:@"male"]){
        return NO;
    }
    else if (women == NO && [gender isEqualToString:@"female"]){
        return NO;
    }
    else if (single == NO && ([relationshipStatus isEqualToString:@"single"] || relationshipStatus == nil)){
        return NO;
    }
    else {
        return YES;
    }
}

-(void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [likeActivity setObject:kMUActivityTypeLikeKey forKey:kMUActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self checkForPhotoUserLikes];
        [self setupNextPhoto];
    }];
}


-(void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [dislikeActivity setObject:kMUActivityTypeDislikeKey forKey:kMUActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isDislikedByCurrentUser = YES;
        self.isLikedByCurrrentUser = NO;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
}

-(void)checkLike
{
    if (self.isLikedByCurrrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else{
        [self saveLike];
    }
}

-(void)checkDislike
{
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else{
        [self saveDislike];
    }
}

-(void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:kMUActivityClassKey];
    [query whereKey:kMUActivityFromUserKey equalTo:self.photo[kMUPhotoUserKey]];
    [query whereKey:kMUActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            //create our chatroom
            [self createChatRoom];
        }
    }];
}


-(void)createChatRoom
{
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [queryForChatRoom whereKey:kMUChatRoomUser1Key equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:kMUChatRoomUser2Key equalTo:self.photo[kMUPhotoUserKey]];
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [queryForChatRoomInverse whereKey:kMUChatRoomUser1Key equalTo:self.photo[kMUPhotoUserKey]];
    [queryForChatRoomInverse whereKey:kMUChatRoomUser2Key equalTo:[PFUser currentUser]];
   
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom,queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:kMUChatRoomClassKey];
            [chatroom setObject:[PFUser currentUser] forKey:kMUChatRoomUser1Key];
            [chatroom setObject:self.photo[kMUPhotoUserKey] forKey:kMUChatRoomUser2Key];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
    
    
}


#pragma mark - MUMatchVC Delegate

-(void)presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}








@end
