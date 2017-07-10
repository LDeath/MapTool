//
//  ViewController.m
//  MapHelp
//
//  Created by 高赛 on 2017/7/7.
//  Copyright © 2017年 高赛. All rights reserved.
//

#import "ViewController.h"
#import "MAFMapTool.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MAFMapTool sharedInstance] needShowAnnotationWithIsNeedSearch:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    MAMapView *mapView = [[MAFMapTool sharedInstance] getMAMapViewWithFrame:self.view.bounds];
    ///把地图添加至view
    [self.view addSubview:mapView];
    
//    [[MAFMapTool sharedInstance] setOfflineMap];
    [[MAFMapTool sharedInstance] checkOfflineMap];
    [[MAFMapTool sharedInstance] downloadNationWideOfflineMap];
    [[MAFMapTool sharedInstance] downloadCityOfflineMapWithCityCode:@"023"];
    [[MAFMapTool sharedInstance] initLocationMap];
    [[MAFMapTool sharedInstance] singleLocation];
    [[MAFMapTool sharedInstance] startAlwaysLocation];
    
//    [[MAFMapTool sharedInstance] searchKeyWord:@"舜泰广场" andPage:1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
