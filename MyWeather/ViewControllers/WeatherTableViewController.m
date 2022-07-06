//
//  WeatherTableViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "WeatherTableViewController.h"

@interface WeatherTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ConditionImage;
@property (weak, nonatomic) IBOutlet UITableViewCell *ConditionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *TemperatureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WindSpeedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WindDirectionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *FirstDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *SecondDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ThirdDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ForthDayCell;

@end

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ConditionImage.image = [UIImage systemImageNamed:@"sun.max"];
    self.ConditionCell.textLabel.text = @"Soleggiato";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
