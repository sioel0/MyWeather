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

    dispatch_queue_t queue = dispatch_queue_create("get_meteo_information", NULL);
    dispatch_async(queue, ^{
        NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=UTC", self.city.latitude, self.city.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"%@", data.description);
        id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *weather = (NSDictionary *)value;
        // get current weather informations
        NSDictionary *current_weather = [weather valueForKey:@"current_weather"];
        NSNumber *temp = [current_weather valueForKey:@"temperature"];
        NSNumber *windspeed = [current_weather valueForKey:@"windspeed"];
        NSNumber *winddirection = [current_weather valueForKey:@"winddirection"];
        NSString *direction;
        NSNumber *weathercode = [current_weather valueForKey:@"weathercode"];
        // set wind direction
        if((winddirection.intValue >= 0 && winddirection.intValue < 23) || (winddirection.intValue > 337 && winddirection.intValue <= 360))
            direction = @"N";
        else if(winddirection.intValue >= 23 && winddirection.intValue < 67)
            direction = @"NE";
        else if(winddirection.intValue >= 67 && winddirection.intValue < 113)
            direction = @"E";
        else if(winddirection.intValue >= 113 && winddirection.intValue < 158)
            direction = @"SE";
        else if(winddirection.intValue >= 158 && winddirection.intValue < 203)
            direction = @"S";
        else if(winddirection.intValue >= 203 && winddirection.intValue < 248)
            direction = @"SO";
        else if(winddirection.intValue >= 248 && winddirection.intValue < 293)
            direction = @"O";
        else
            direction = @"NO";
        
        // daily informations
        NSDictionary *daily = [weather valueForKey:@"daily"];
        NSArray *temperature_min = [daily valueForKey:@"temperature_2m_min"];
        NSArray *temperature_max = [daily valueForKey:@"temperature_2m_max"];
        NSArray *weathercond = [daily valueForKey:@"weathercode"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TemperatureCell.textLabel.text = [NSString stringWithFormat:@"%d °C", temp.intValue];
            self.WindSpeedCell.detailTextLabel.text = [NSString stringWithFormat:@"%d Km/h", windspeed.intValue];
            self.WindDirectionCell.detailTextLabel.text = direction;
            self.ConditionImage.image = [self imageForWeatherCode:weathercode.intValue];
            self.ConditionCell.textLabel.text = [self stringForWeatherCode:weathercode.intValue];
            self.FirstDayCell.imageView.image = [self imageForWeatherCode:((NSNumber *)[weathercond objectAtIndex:1]).intValue];
            self.FirstDayCell.textLabel.text = [NSString stringWithFormat:@"%d/%d", ((NSNumber *)[temperature_min objectAtIndex:1]).intValue, ((NSNumber *)[temperature_max objectAtIndex:1]).intValue];
            self.SecondDayCell.imageView.image = [self imageForWeatherCode:((NSNumber *)[weathercond objectAtIndex:2]).intValue];
            self.SecondDayCell.textLabel.text = [NSString stringWithFormat:@"%d/%d", ((NSNumber *)[temperature_min objectAtIndex:2]).intValue, ((NSNumber *)[temperature_max objectAtIndex:2]).intValue];
            self.ThirdDayCell.imageView.image = [self imageForWeatherCode:((NSNumber *)[weathercond objectAtIndex:3]).intValue];
            self.ThirdDayCell.textLabel.text = [NSString stringWithFormat:@"%d/%d", ((NSNumber *)[temperature_min objectAtIndex:3]).intValue, ((NSNumber *)[temperature_max objectAtIndex:3]).intValue];
            self.ForthDayCell.imageView.image = [self imageForWeatherCode:((NSNumber *)[weathercond objectAtIndex:4]).intValue];
            self.ForthDayCell.textLabel.text = [NSString stringWithFormat:@"%d/%d", ((NSNumber *)[temperature_min objectAtIndex:4]).intValue, ((NSNumber *)[temperature_max objectAtIndex:4]).intValue];
        });
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

-(UIImage *)imageForWeatherCode:(int) value {
    // wmo weather interpretation codes
    UIImage *result;
    if(value == 0)
        return [UIImage systemImageNamed:@"sun.max"];
    if(value == 1 || value == 2 || value == 3)
        return [UIImage systemImageNamed:@"cloud.sun"];
    if(value == 45 || value == 48)
        return [UIImage systemImageNamed:@"cloud.fog"];
    if(value == 51 || value == 53 || value == 55)
        return [UIImage systemImageNamed:@"cloud.drizzle"];
    if(value == 56 || value == 57)
        return [UIImage systemImageNamed:@"snow"];
    if(value == 61 || value == 63 || value == 65)
        return [UIImage systemImageNamed:@"cloud.rain"];
    if(value == 66 || value == 67)
        return [UIImage systemImageNamed:@"cloud.rain"];
    if(value == 71 || value == 73 || value == 75)
        return [UIImage systemImageNamed:@"cloud.snow"];
    if(value == 77)
        return [UIImage systemImageNamed:@"cloud.snow"];
    if(value == 80 || value == 81 || value == 82)
        return [UIImage systemImageNamed:@"cloud.rain"];
    if(value == 85 || value == 86)
        return [UIImage systemImageNamed:@"cloud.snow"];
    if(value == 95 || value == 96 || value == 99)
        return [UIImage systemImageNamed:@"cloud.bolt"];
    else
        return nil;
}

-(NSString *)stringForWeatherCode:(int)value {
    // wmo weather interpretation codes
    if(value == 0)
        return @"Soleggiato";
    if(value == 1 || value == 2 || value == 3)
        return @"Parzialmente nuovoloso";
    if(value == 45 || value == 48)
        return @"Nebbia";
    if(value == 51 || value == 53 || value == 55)
        return @"Rovesci sparsi";
    if(value == 56 || value == 57)
        return @"Nevischio";
    if(value == 61 || value == 63 || value == 65)
        return @"Pioggia";
    if(value == 66 || value == 67)
        return @"Pioggia";
    if(value == 71 || value == 73 || value == 75)
        return @"Neve";
    if(value == 77)
        return @"Nevicate intense";
    if(value == 80 || value == 81 || value == 82)
        return @"Acquazzone";
    if(value == 85 || value == 86)
        return @"Nevicate intense";
    if(value == 95 || value == 96 || value == 99)
        return @"Tempesta";
    else
        return @"";
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
