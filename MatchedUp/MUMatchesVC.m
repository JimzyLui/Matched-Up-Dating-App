//
//  MUMatchesVC.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/16/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUMatchesVC.h"
#import "MUChatVC.h"

@interface MUMatchesVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *availableChatRooms;

@end

@implementation MUMatchesVC

#pragma mark - Lazy Instantiation

-(NSMutableArray *)availableChatRooms
{
    if (!_availableChatRooms) {
        _availableChatRooms = [[NSMutableArray alloc] init];
    }
    return _availableChatRooms;
}


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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateAvailableChatRoms];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MUChatVC *targeVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    targeVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
}

#pragma mark - Helper Methods

-(void)updateAvailableChatRoms
{
    PFQuery *query = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [query whereKey:kMUChatRoomUser1Key equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [queryInverse whereKey:kMUChatRoomUser2Key equalTo:[PFUser currentUser]];
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query,queryInverse]];
    [queryCombined includeKey:kMUChatClassKey];  //includeKey: is like a join
    [queryCombined includeKey:kMUChatRoomUser1Key];
    [queryCombined includeKey:kMUChatRoomUser2Key];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
                              
    
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatRoom[kMUChatRoomUser1Key];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        likedUser = [chatRoom objectForKey:kMUChatRoomUser2Key];
    }
    else {
        likedUser = [chatRoom objectForKey:kMUChatRoomUser1Key];
    }
    
    cell.textLabel.text = likedUser[kMUUserProfileKey][kMUUserProfileFirstNameKey];
    cell.detailTextLabel.text = chatRoom[@"createdAt"];
    
    //cell.imageView.image = place holder image
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:kMUPhotoClassKey];
    [queryForPhoto whereKey:kMUPhotoUserKey equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMUPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
            
        }
    }];
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}
































@end
