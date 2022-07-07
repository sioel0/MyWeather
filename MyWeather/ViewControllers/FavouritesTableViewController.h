//
//  FavouritesTableViewController.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <UIKit/UIKit.h>
#import "CityListDataSource.h"
#import "WeatherTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavouritesTableViewController : UITableViewController

@property (strong, nonatomic) CityListDataSource *dataSource;
@property (weak) WeatherTableViewController *previous;

@end

NS_ASSUME_NONNULL_END
