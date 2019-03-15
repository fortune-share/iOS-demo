//
//  RootViewController.m
//  ostentation iOS
//
//  Created by lidazhi on 2019/3/15.
//  Copyright © 2019 fortune. All rights reserved.
//

#import "RootViewController.h"
#import "GameViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * loginbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    loginbutton.tag=100;
    loginbutton.layer.cornerRadius=5;
    loginbutton.layer.masksToBounds=YES;
    [loginbutton setBackgroundColor:[UIColor blackColor]];
    [loginbutton setTitle:@"炫 富 登 录" forState:UIControlStateNormal];
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
    
    UIButton * paybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 40)];
     [paybutton setTitle:@"炫 富 支 付" forState:UIControlStateNormal];
    paybutton.tag=101;
    [paybutton setBackgroundColor:[UIColor blackColor]];
    paybutton.layer.cornerRadius=5;
    paybutton.layer.masksToBounds=YES;
     [paybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paybutton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:paybutton];
    
}
-(void)buttonAction:(UIButton*)button{
    GameViewController*vc=[[GameViewController alloc]init];
    if (button.tag==100) {
        vc.isPay=NO;
    }else{
        vc.isPay=YES;
    }
     [self presentViewController:vc animated:YES completion:nil];
}

@end
