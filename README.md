# KXModuleOrz
[![CI Status](https://img.shields.io/travis/XiangqiTu/KXModuleOrz.svg?style=flat)](https://travis-ci.org/XiangqiTu/KXModuleOrz)
[![Version](https://img.shields.io/cocoapods/v/KXModuleOrz.svg?style=flat)](https://cocoapods.org/pods/KXModuleOrz)
[![License](https://img.shields.io/cocoapods/l/KXModuleOrz.svg?style=flat)](https://cocoapods.org/pods/KXModuleOrz)
[![Platform](https://img.shields.io/cocoapods/p/KXModuleOrz.svg?style=flat)](https://cocoapods.org/pods/KXModuleOrz)
## 概述
KXModuleOrz 是组件化架构设计的管理统称。orz 代表为组件`module`提供服务的意思

* KXModuleManager 管理`module`的活性`active `, `trigger`各种自定义事件`event`
	* `active` 需要指定`moduleClass`, `YES`代表着激活`moduleClass`文件，响应`event`，`NO`反之
	* `event` 可以自定义，后期可拓展为更多的`subevent`
		* `module lifecycle event` module生命周期相关的子类型（init, setup, start, end, dispose）
		* `application lifecycle event` application生命周期子类型(FinishLaunching,ResignActive, EnterBackground)
		* `section event`业务事件子类型(登录、登出、连接成功、连接失败)
		* `custom event` 自定义
	* `KXModuleProtocol` 新建的`module`对象需要继承此协议 
		* `KXModuleOrz_Auto_Regist()`宏自动注册,并且实现`@required` 相关
		* `modulePriority` 若不设置权重 默认为`KXModulePriorityLow `
		* `- (void)moduleCatchEvent:(KXModuleEvent)event` 响应各种`event`
	* 线程不安全，请在 **主线程** 操作。后期会考虑加入线程安全，任性使用
<br></br>

* KXModuleQAService 不同`module`之间以QA形式 **单向** 通信，初衷就是为了Module之间的解耦。
	* **举例：** ModuleA需要用到ModuleB，A 向 B 提出问题集合 `B_Question`, A 不关心 B 如何解答问题，A 只关心 `B_Question` 如何描述清楚（方法名, 返回值，各个参数）。B 回答问题，需要生成一个`B_Answer`文件，`B_Answer`文件作为一个新的`module`，需要被 `KXModuleManager` 管理 灵活使用，`B_Answer` 全心全意为 `B_Question`服务。
	<br></br>
	* `regist/unregist` `Answer` 与 `Question`  一对一映射，不支持一对多，多对多。（初衷就是为了Module之间的解耦）
	* `Question` 问题的描述集合，可以由于多个业务模块共同提出。A，C，D模块，对B模块提出了各种各样的问题,集合在`B_Question`中。`orz_ask`可在具体业务模块中直接快速提问并得到 **问题反馈** ，进行后续逻辑。
	
	* `Answer`作为新且小的`module`需实现`KXModuleProtocol`、`B_Question`两个协议。`Answer`只对接`Question`相关实现逻辑. `__ORZ_ANSWER__`可用于实现`B_Question`具体问题解答后标注（已回答）
	* 线程不安全，请在 **主线程** 操作。后期会考虑加入线程安全，任性使用

* `Question`的描述文件建议单独存放在一个Pod中

## 特点
KXModuleOrz 整体内容借鉴 [BeeHive](https://github.com/alibaba/BeeHive "BeeHive"), [CTMediator](https://github.com/casatwy/CTMediator) 。集两家之所长，避其短。短小精悍，易上手。

* KXModuleManager: 模块生命周期 + trigger Event 机制, `modulePriority`优先级
* KXModuleQAService: QA的形式 业务解耦，简单易懂

* 全程无硬编码HardCode
* QA支持`Question`高度自由自定义，参数返回值多样化
* 新建`module`对象，原有业务模块代码 **无污染**
* 注册机制 可插可拔

## 弊端
* 注册机制，需要维护注册表
* 注册过程 `+(void)load` ，若使用不当，影响`pre-main`阶段运行
* 不允许`sharedInstance` 单例 / 全局 对象实现`module Protocol`,需要新建`Module`
* `Question` 只支持 `ClassMethod +()`,不支持 `InstanceMethod -()`

* 版本 **未正式发布**，存在未发现的bug隐患

## Installation

KXModuleOrz is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KXModuleOrz'
```

## Author

XiangqiTu, 110293734@qq.com

## License

KXModuleOrz is available under the MIT license. See the LICENSE file for more info.
