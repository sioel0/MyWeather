//
//  MapViewController.h
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import <UIKit/UIKit.h>
#import "CityList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) City *currentLocation;

@end

NS_ASSUME_NONNULL_END
