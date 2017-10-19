//
//  SubSequenceViewController.m
//  DPGithub
//
//  Created by myApple on 2017/10/19.
//  Copyright © 2017年 myApple. All rights reserved.
//

#import "SubSequenceViewController.h"

#define Swidth  [UIScreen mainScreen].bounds.size.width
#define Sheight [UIScreen mainScreen].bounds.size.height

@interface SubSequenceViewController ()<UITextFieldDelegate>
{
    UITextField * inputTextField;
    NSMutableArray * originArray;//原始数据
    NSMutableArray * sequenceArray;//每个数的最长序列的值
    UILabel * resultLabel;
}

@end

@implementation SubSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    originArray = [[NSMutableArray alloc]init];
    sequenceArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self prepareView];
    
}

#pragma mark - 视图
-(void)prepareView
{
    CGFloat x = 20;
    CGFloat y = 70;
    CGFloat width = Swidth - 2 * x;
    CGFloat height = 50;
    
    inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, width, height)];
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    inputTextField.delegate = self;
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.placeholder = @"输入三角形的列数 1~11";
    inputTextField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:inputTextField];
    
}

#pragma mark - 试图展示
-(void)prepareTriangleView:(NSInteger)length
{
    CGFloat offX = 20;
    CGFloat height = 25;
    CGFloat width = 30;
    CGFloat y = 150;
    for (int i = 0; i <= length; i ++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(offX + i * width,y , width, height)];
        label.text = [NSString stringWithFormat:@"%d",arc4random() % 20 + 1];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        label.tag = i * 15 + 2;
        [originArray addObject:label.text];
        [sequenceArray addObject:@"1"];
    }
    
    resultLabel = [[UILabel alloc]initWithFrame:CGRectMake((Swidth - 60)/2.0, (Sheight - 30)/2.0,60, 30)];
    resultLabel.textColor = [UIColor redColor];
    resultLabel.font = [UIFont systemFontOfSize:20];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.layer.borderWidth = 2;
    resultLabel.layer.borderColor = [UIColor greenColor].CGColor;
    resultLabel.layer.masksToBounds = YES;
    [self.view addSubview:resultLabel];
    
    [self findNumberOfLIS];
}

#pragma mark - 最长子序列
-(void)findNumberOfLIS
{
    NSInteger len = originArray.count;
    for (int i = 0; i < len; i ++) {
        for (int j = 0; j < i; j ++) {
            if ([originArray[j] integerValue] < [originArray[i] integerValue] && [sequenceArray[j] integerValue] + 1 >= [sequenceArray[i] integerValue]) {
                NSInteger seqLen = [sequenceArray[j] integerValue] + 1;
                [sequenceArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%ld",(long)seqLen]];
            }
        }
    }
    resultLabel.text = [NSString stringWithFormat:@"%@",[sequenceArray valueForKeyPath:@"@max.floatValue"]];
    [self calcuateValue];
}

#pragma mark - 显示最长序列的数值
-(void)calcuateValue
{
    NSInteger index = 0;
    NSInteger max = [sequenceArray[0] integerValue];
    for (NSInteger i = 1; i < sequenceArray.count; i ++) {
        if ([sequenceArray[i] integerValue] > max) {
            max = [sequenceArray[i] integerValue];
            index = i;
        }
    }
    UILabel * selectLabel = [self.view viewWithTag:index * 15 + 2];
    selectLabel.textColor = [UIColor redColor];
    if (index > 0) {
        NSInteger lastValue = [originArray[index] integerValue];
        for (NSInteger j = index - 1; j >= 0; j --) {
            if ([originArray[j] integerValue] < lastValue) {
                lastValue = [originArray[j] integerValue];
                UILabel * selectLabel = [self.view viewWithTag:j * 15 + 2];
                selectLabel.textColor = [UIColor redColor];
            }
        }
    }
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [originArray removeAllObjects];
    [sequenceArray removeAllObjects];
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    NSInteger count = [inputTextField.text integerValue];
    if (count < 1 || count > 11) {
        NSLog(@"请输入 1～11之间的正整数");
    }
    else
    {
        NSLog(@"Ready Go");
        [self prepareTriangleView:count];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
