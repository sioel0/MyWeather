//
//  WeatherTableViewController.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherTableViewController : UITableViewController

@property (strong, nonatomic) City *city;

@end

NS_ASSUME_NONNULL_END
