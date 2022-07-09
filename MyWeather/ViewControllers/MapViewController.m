//
//  MapViewController.m
//  MyWeather
//
//  Created by Simone Leoni on 06/07/22.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "City+MapAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@end

@implementation MapViewController

// TODO: fix this placemarks not working

- (void)viewDidLoad {
    [super viewDidLoad];
    self.MapView.delegate = self;
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(self.currentLocation.latitude, self.currentLocation.longitude);
    mapRegion.span.latitudeDelta = 10.0;
    mapRegion.span.longitudeDelta = 10.0;
    [self.MapView setRegion:mapRegion];
    //add annotations to the map
    [self.list enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[City class]]) {
            City *city = (City *)obj;
            [self.MapView addAnnotation:city];
        }
    }];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *AnnotationIdentifer = @"CityAnnotation";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifer];
    
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifer];
        view.canShowCallout = YES;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    imageView.image = [UIImage systemImageNamed:@"questionmark"];
    view.leftCalloutAccessoryView = imageView;
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        __block UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        id<MKAnnotation> annotation = view.annotation;
        if([annotation isKindOfClass:[City class]]) {
            City *city = (City *)annotation;
            dispatch_queue_t queue = dispatch_queue_create("get_meteo_information", NULL);
            dispatch_async(queue, ^{
                NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true", city.latitude, city.longitude];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *weather = (NSDictionary *)value;
                // get current weather informations
                NSDictionary *current_weather = [weather valueForKey:@"current_weather"];
                NSNumber *weathercode = [current_weather valueForKey:@"weathercode"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [self imageForWeatherCode:weathercode.intValue];
                });
            });
        }
    }
}

-(UIImage *)imageForWeatherCode:(int) value {
    // wmo weather interpretation codes
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

@end
