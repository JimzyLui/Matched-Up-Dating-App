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

@interface MUHomeVC ()
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
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kMUPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error){
             self.photos = objects;
             [self queryForCurrentPhotoIndex];
         }
         else {
             NSLog(@"%@",error);
         }
     }];
    //do additional code
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
}

#pragma mark - IBActions

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender {
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
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.photo[kMUPhotoUserKey][kMUUserProfileKey][KMUUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kMUPhotoUserKey][kMUUserTagLineKey];
}

-(void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex++;
        [self queryForCurrentPhotoIndex];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more users to view" message:@"Check Back Later for More People!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
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





@end
