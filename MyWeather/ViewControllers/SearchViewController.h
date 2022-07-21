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

@property (weak) WeatherTableViewController *previous;

@end

NS_ASSUME_NONNULL_END
