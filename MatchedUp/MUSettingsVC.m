//
//  MUSettingsVC.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/12/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUSettingsVC.h"

@interface MUSettingsVC ()
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singlesSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;




@end

@implementation MUSettingsVC

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
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kMUAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    self.singlesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singlesSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
}

#pragma mark - Helper Methods

-(void)valueChanged:(id)sender
{
    if (sender == self.ageSlider) {
        [[NSUserDefaults standardUserDefaults] setInteger:(int)self.ageSlider.value forKey:kMUAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
    }
    else if (sender == self.menSwitch){
        [[NSUserDefaults standardUserDefaults] setInteger:self.menSwitch.isOn forKey:kMUMenEnabledKey];
    }
    else if (sender == self.womenSwitch){
        [[NSUserDefaults standardUserDefaults] setInteger:self.womenSwitch.isOn forKey:kMUWomenEnabledKey];
    }
    else if (sender == self.singlesSwitch){
        [[NSUserDefaults standardUserDefaults] setInteger:self.singlesSwitch.isOn forKey:kMUSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}





















@end
