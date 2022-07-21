//
//  SearchViewController.h
//  MyWeather
//
//  Created by Simone Leoni on 21/07/22.
//

#import <UIKit/UIKit.h>
#import "WeatherTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

// used to update the city for meteo forecast once it is selected a new one
@property (weak) WeatherTableViewController *previous;

@end

NS_ASSUME_NONNULL_END
