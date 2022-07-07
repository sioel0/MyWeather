//
//  WeatherTableViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <CoreLocation/CoreLocation.h>
#import "WeatherTableViewController.h"
#import "FavouritesTableViewController.h"
#import "CityListDataSource.h"
#import "CityList.h"

@interface WeatherTableViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ConditionImage;
@property (weak, nonatomic) IBOutlet UITableViewCell *ConditionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *TemperatureCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WindSpeedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *WindDirectionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *FirstDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *SecondDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ThirdDayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ForthDayCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *FavouriteButton;
@property (strong, nonatomic) CityListDataSource *dataSource;
@property (strong, nonatomic) CityList *cities;
@property (strong, nonatomic) NSMutableArray<CLLocation *> *locations;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WeatherTableViewController

-(CLLocationManager *)locationManager {
    if(!_locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}

- (void)renderView {
    self.title = self.city.name;
    if([self.cities contains:self.city])
        self.FavouriteButton.image = [UIImage systemImageNamed:@"star.fill"];
    else
        self.FavouriteButton.image = [UIImage systemImageNamed:@"star"];
    
    // fetch data and edit appearance
    self.ConditionImage.image = [UIImage systemImageNamed:@"sun.max"];
    self.ConditionCell.textLabel.text = @"Soleggiato";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[CityListDataSource alloc] init];
    if(self.dataSource != nil)
        self.cities = [self.dataSource getCities];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    //self.city = [[City alloc] initWithName:@"Londra" latitude:51.48 longitude:-0.14];
    [self locationManager:self.locationManager didUpdateLocations:self.locations];
}

- (void)viewWillAppear:(BOOL)animated {
    [self renderView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)AddToFavourites:(id)sender {
    if([self.cities contains:self.city]) {
        [self.cities removeCity:self.city];
        self.FavouriteButton.image = [UIImage systemImageNamed:@"star"];
    }
    else {
        [self.cities addCity:self.city];
        self.FavouriteButton.image = [UIImage systemImageNamed:@"star.fill"];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];

        self.city.name = placemark.locality;
        NSLog(@"%@", placemark.locality);
        NSLog(@"lat: %f long: %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        NSLog(@"lat: %f long: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
        self.city.latitude = placemark.location.coordinate.latitude;
        self.city.longitude = placemark.location.coordinate.longitude;
        
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error %@", error.domain);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"FavList"]){
        if([segue.destinationViewController isKindOfClass:[FavouritesTableViewController class]]){
            FavouritesTableViewController *vc = (FavouritesTableViewController *)segue.destinationViewController;
            vc.previous = self;
            vc.dataSource = self.dataSource;
        }
    }
}


@end
