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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSLog(@"Entered");
    
    static NSString *AnnotationIdentifer = @"CityAnnotation";
    
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifer];
    
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:AnnotationIdentifer];
        view.canShowCallout = YES;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    imageView.image = [UIImage systemImageNamed:@"square"];
    view.leftCalloutAccessoryView = imageView;
    
    return view;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        id<MKAnnotation> annotation = view.annotation;
        if([annotation isKindOfClass:[City class]]) {
            City *city = (City *)annotation;
            dispatch_queue_t queue = dispatch_queue_create("get_meteo_information", NULL);
            dispatch_async(queue, ^{
                NSString *urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true", city.latitude, city.longitude];
                NSURL *url = [NSURL URLWithString:urlString];
                NSData *data = [NSData dataWithContentsOfURL:url];
                if([NSJSONSerialization isValidJSONObject:data]) {
                    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@", (NSString *)[values objectAtIndex:0]);
                }
            });
        }
    }
}

@end
