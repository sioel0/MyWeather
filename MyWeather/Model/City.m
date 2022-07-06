//
//  City.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "City.h"

@implementation City

-(instancetype) initWithName:(NSString *)name {
    if(self = [super init]) {
        _name = name;
        // open-meteo api to find out latitude and longitude
        _latitude = 0.0;
        _longitude = 0.0;
    }
    return self;
}

@end
