//
//  City+MapAnnotation.m
//  MyWeather
//
//  Created by Simone Leoni on 07/07/22.
//

#import "City+MapAnnotation.h"

@implementation City(MapAnnotation)

-(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

- (NSString *)title {
    // name + temperature
    NSString *temperature = @"";
    NSString *title = [NSString stringWithFormat:@"%@  %@", self.name, temperature];
    return title;
}

@end
