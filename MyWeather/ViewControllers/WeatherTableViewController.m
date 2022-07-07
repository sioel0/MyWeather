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
    
    NSLog(@"city: %@", self.city.name);
    NSLog(@"lat: %f", self.city.latitude);
    NSLog(@"long: %f", self.city.longitude);
    // TODO: add other data and parse values
    dispatch_queue_t queue = dispatch_queue_create("get_meteo_information", NULL);
    dispatch_async(queue, ^{
        NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true", self.city.latitude, self.city.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"%@", data.description);
        id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *weather = (NSDictionary *)value;
        NSString *current_weather = [weather valueForKey:@"current_weather"];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[CityListDataSource alloc] init];
    if(self.dataSource != nil)
        self.cities = [self.dataSource getCities];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.city.name != nil)
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
        self.city = [[City alloc] initWithName:placemark.locality latitude:placemark.location.coordinate.latitude longitude: placemark.location.coordinate.longitude];
        if(self.city.name != nil) {
            [self.locationManager stopUpdatingLocation];
            [self renderView];
        }
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
