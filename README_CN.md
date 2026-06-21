# TTGTagCollectionView

[![Version](https://img.shields.io/cocoapods/v/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![License](https://img.shields.io/cocoapods/l/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)

**[English Documentation →](README.md)**

iOS 标签集合视图组件 —— 支持文字标签和自定义视图，可垂直/水平滚动，提供丰富的对齐方式和 AutoLayout 支持。

![TTGTagCollectionView 宣传图](Resources/promo_poster.png)

宣传图由 [Resources/promo_poster.html](Resources/promo_poster.html) 生成，后续可以直接维护 HTML 后重新截图。

## 特性

- **两种视图类型**：`TextTagCollectionView` 用于文字标签，`TagCollectionView` 用于任意自定义 `UIView`
- **6 种对齐模式**：左对齐、居中、右对齐、间距填充、宽度填充、宽度填充（末行除外）
- **垂直 & 水平**滚动方向，支持行数限制
- **逐标签定制**：背景色、渐变、圆角（支持四角独立设置）、边框、阴影、内边距、尺寸约束
- **富文本支持**：通过 `NSAttributedString`
- **选中管理**：点击选中、选中数量限制、选中态样式
- **AutoLayout 友好**：`intrinsicContentSize` 自动更新；支持 `preferredMaxLayoutWidth`
- **无障碍**：自动检测模式或手动设置 `accessibilityLabel / hint / traits`
- **Swift 优先的 API**，同时完全兼容 Objective-C
- 支持 **CocoaPods** 和 **Swift Package Manager**

## 环境要求

- iOS 16.0+
- Swift 5.9+
- Xcode 15+

## 安装

### Swift Package Manager（推荐）

在 Xcode 中：**File → Add Package Dependencies**，输入：

```
https://github.com/zekunyan/TTGTagCollectionView.git
```

或在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/zekunyan/TTGTagCollectionView.git", from: "3.1.0")
]
```

### CocoaPods

```ruby
pod 'TTGTagCollectionView'
```

## 快速开始

> **3 步在屏幕上显示标签。** 完整 API 请参阅 [详细用法](#详细用法)。

### 第 1 步 — 导入并创建

```swift
import TTGTags

let tagView = TextTagCollectionView(frame: CGRect(x: 16, y: 100, width: 320, height: 200))
view.addSubview(tagView)
```

### 第 2 步 — 构建标签

每个标签是一个 `TextTag`，由 **内容（Content）** + **样式（Style）** 组成：

```swift
// 内容：显示什么文字、字体、颜色
let content = TextTagStringContent(text: "Swift")
content.textFont  = .boldSystemFont(ofSize: 14)
content.textColor = .white

// 样式：背景、圆角、内边距
let style = TextTagStyle()
style.backgroundColor = .systemBlue
style.cornerRadius    = 10
style.extraSpace      = CGSize(width: 12, height: 8)   // 内边距

let tag = TextTag(content: content, style: style)
```

### 第 3 步 — 添加并刷新

```swift
tagView.add(tag: tag)
tagView.reload()   // ← 每次增删改后必须调用
```

完成！屏幕上会出现一个蓝色圆角标签。

### 添加选中效果

```swift
let selectedStyle = TextTagStyle()
selectedStyle.backgroundColor = .systemOrange
selectedStyle.cornerRadius    = 10
selectedStyle.extraSpace      = CGSize(width: 12, height: 8)

tag.selectedStyle = selectedStyle    // 点击时自动切换样式

tagView.delegate = self              // 接收点击回调
```

### Objective-C？没问题

```objc
#import <TTGTags/TTGTags-Swift.h>

TTGTextTagCollectionView *tagView = [[TTGTextTagCollectionView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:tagView];

TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:@"你好"];
TTGTextTagStyle *style = [TTGTextTagStyle new];
style.backgroundColor = UIColor.systemBlueColor;
style.cornerRadius = 10;
style.extraSpace = CGSizeMake(12, 8);

TTGTextTag *tag = [TTGTextTag tagWithContent:content style:style];
[tagView addTag:tag];
[tagView reload];
```

---

## 核心概念

理解以下 4 个构建模块有助于高效使用本库：

```
┌─────────────────────────────────────────────────────────────┐
│  TextTagCollectionView（或 TagCollectionView）              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ TextTag  │  │ TextTag  │  │ TextTag  │  │ TextTag  │   │
│  │┌────────┐│  │┌────────┐│  │┌────────┐│  │┌────────┐│   │
│  ││Content ││  ││Content ││  ││Content ││  ││Content ││   │
│  ││ Style  ││  ││ Style  ││  ││ Style  ││  ││ Style  ││   │
│  │└────────┘│  │└────────┘│  │└────────┘│  │└────────┘│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

| 概念 | 类名 | 职责 |
|---|---|---|
| **标签** | `TextTag` | 数据模型：持有内容、样式、选中状态，以及可选的 `attachment` |
| **内容** | `TextTagStringContent` / `TextTagAttributedStringContent` | 显示的文字、字体和颜色 |
| **样式** | `TextTagStyle` | 外观：背景、渐变、圆角、边框、阴影、尺寸 |
| **集合视图** | `TextTagCollectionView` / `TagCollectionView` | 容器：负责对标签进行对齐、间距和滚动布局 |

> **重要规则**：每次添加、删除或更新标签后，必须调用 `reload()`。

---

## 详细用法

### 代理回调

```swift
tagView.delegate = self

// TextTagCollectionViewDelegate
func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           canTapTag tag: TextTag, at index: Int) -> Bool { true }

func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           didTapTag tag: TextTag, at index: Int) {
    print("点击: \(tag.rightfulContent.contentAttributedString.string), 选中: \(tag.selected)")
}

func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           updateContentSize contentSize: CGSize) {
    // 例如：更新高度约束
}
```

### 内容类型

```swift
// 纯文本
let c1 = TextTagStringContent(text: "你好")
c1.textFont  = .systemFont(ofSize: 14)
c1.textColor = .darkText

// 富文本（NSAttributedString）
let attrs: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.systemRed,
    .font: UIFont.boldSystemFont(ofSize: 16)
]
let c2 = TextTagAttributedStringContent(
    attributedText: NSAttributedString(string: "富文本", attributes: attrs)
)
```

### 样式属性 — TextTagStyle

```swift
let style = TextTagStyle()

// 背景色
style.backgroundColor = .systemBlue
style.textAlignment = .center
style.numberOfLines = 1                  // 0 = 不限制行数
style.lineBreakMode = .byTruncatingTail

// 渐变背景
style.enableGradientBackground        = true
style.gradientBackgroundStartColor    = .systemBlue
style.gradientBackgroundEndColor      = .systemPurple
style.gradientBackgroundStartPoint    = CGPoint(x: 0, y: 0.5)
style.gradientBackgroundEndPoint      = CGPoint(x: 1, y: 0.5)

// 圆角（默认四角全部圆角；设置独立标志控制每个角）
style.cornerRadius      = 14
style.cornerTopLeft     = true
style.cornerTopRight    = true
style.cornerBottomLeft  = false
style.cornerBottomRight = false

// 边框
style.borderWidth = 1
style.borderColor = .white

// 阴影
style.shadowColor   = .black
style.shadowOffset  = CGSize(width: 2, height: 2)
style.shadowRadius  = 2
style.shadowOpacity = 0.3

// 尺寸
style.extraSpace  = CGSize(width: 12, height: 6)  // 内边距
style.minWidth    = 60      // 0 = 不限制
style.maxWidth    = 200
style.exactWidth  = 0       // 0 = 自动
style.exactHeight = 32
```

### 布局配置

```swift
tagView.scrollDirection  = .vertical     // .vertical（默认）或 .horizontal
tagView.alignment        = .left         // 参见下方对齐模式
tagView.horizontalDistribution = .rowMajor
tagView.contentVerticalAlignment = .top
tagView.numberOfLines    = 0             // 0 = 不限
tagView.selectionLimit   = 3             // 0 = 不限
tagView.horizontalSpacing = 8
tagView.verticalSpacing   = 8
tagView.contentInset      = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

// AutoLayout 手动计算高度
tagView.manualCalculateHeight   = true
tagView.preferredMaxLayoutWidth = 320

// 点击回调（无需代理）
tagView.onTapBlankArea = { point in print("点击空白区域 \(point)") }
tagView.onTapAllArea   = { point in print("点击任意区域 \(point)") }
```

### 对齐模式

| Swift 枚举值 | 说明 |
|---|---|
| `.left` | 左对齐（默认） |
| `.center` | 居中对齐 |
| `.right` | 右对齐 |
| `.fillByExpandingSpace` | 扩展标签间距以填满每行 |
| `.fillByExpandingWidth` | 扩展每个标签的宽度以填满每行 |
| `.fillByExpandingWidthExceptLastLine` | 同上，但跳过最后一行 |

### 横向多行和垂直摆放

```swift
// 横向多行默认按自然阅读顺序逐行排列（3.1 默认）
tagView.scrollDirection = .horizontal
tagView.numberOfLines = 2
tagView.horizontalDistribution = .rowMajor

// 如果需要保留旧版上下交错的列优先排列
tagView.horizontalDistribution = .columnMajor

// 固定高度容器中垂直居中内容
tagView.contentVerticalAlignment = .center
```

### 多行文本标签

```swift
let content = TextTagStringContent(text: "可以自动换行的长标签")
let style = TextTagStyle()
style.numberOfLines = 0
style.maxWidth = 180
style.lineBreakMode = .byWordWrapping

let tag = TextTag(content: content, style: style)
```

### 标签模型 — TextTag

```swift
let tag = TextTag()

// 普通态 / 选中态的内容和样式
tag.content         = TextTagStringContent(text: "标签")
tag.style           = TextTagStyle()
tag.selectedContent = TextTagStringContent(text: "已选中")   // 可选，未设置时回退到 content 的拷贝
tag.selectedStyle   = TextTagStyle()                         // 可选，未设置时回退到 style 的拷贝

// 选中状态
tag.selected = false
tag.onSelectStateChanged = { selected in print(selected) }

// 绑定任意对象
tag.attachment = myModel

// 无障碍
tag.enableAutoDetectAccessibility = true   // 自动从内容读取 label 和 traits
// 或手动设置：
tag.isAccessibilityElement  = true
tag.accessibilityLabel      = "我的标签"
tag.accessibilityHint       = "双击以选中"
tag.accessibilityTraits     = .button

// 当前激活的内容 / 样式（自动跟随选中状态）
let activeContent = tag.rightfulContent
let activeStyle   = tag.rightfulStyle
```

### 标签增删改查

```swift
// 添加
tagView.add(tag: tag)
tagView.add(tags: [tag1, tag2])

// 插入
tagView.insert(tag: tag, at: 0)
tagView.insert(tags: [tag1, tag2], at: 2)

// 更新
tagView.updateTag(at: 0, selected: true)
tagView.updateTag(at: 0, with: newTag)
tagView.updateTag(byId: tag.tagId, selected: true)
tagView.updateTag(byId: tag.tagId, with: newTag)

// 删除
tagView.remove(tag: tag)
tagView.removeTag(byId: tag.tagId)
tagView.removeTag(at: 0)
tagView.removeAllTags()

// 查询
let tag  = tagView.getTag(at: 0)
let sameTag = tagView.getTag(byId: tagId)
let index = tagView.indexOfTag(byId: tagId)
let tags = tagView.getTags(in: NSRange(location: 0, length: 3))
let all      = tagView.allTags()
let selected = tagView.allSelectedTags()
let unselected = tagView.allNotSelectedTags()

// 刷新（增删改后必须调用）
tagView.reload()
```

### 点击检测

```swift
let index = tagView.indexOfTag(at: touchPoint)   // 未命中时返回 NSNotFound
```

### 滚动到指定标签

```swift
tagView.scrollToTag(at: 12, position: .center, animated: true)
tagView.scrollToTag(byId: tag.tagId, position: .end, animated: true)
```

---

### TagCollectionView — 自定义视图

当你的标签是任意 `UIView` 子类而非文字时，使用 `TagCollectionView`。

```swift
tagCollectionView.dataSource = self
tagCollectionView.delegate   = self

// TagCollectionViewDataSource
func numberOfTags(in tagCollectionView: TagCollectionView) -> Int { items.count }

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       tagViewFor index: Int) -> UIView { myViews[index] }

// TagCollectionViewDelegate
func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       sizeForTagAt index: Int) -> CGSize { myViews[index].frame.size }

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       didSelectTag tagView: UIView, at index: Int) {
    print("选中 \(index)")
}

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       updateContentSize contentSize: CGSize) { }

// 刷新
tagCollectionView.reload()
```

所有布局和间距属性（`scrollDirection`、`alignment`、`horizontalDistribution`、`contentVerticalAlignment`、`numberOfLines`、`horizontalSpacing`、`verticalSpacing`、`contentInset`、`manualCalculateHeight`、`preferredMaxLayoutWidth`）与 `TextTagCollectionView` 完全一致。

---

## 使用技巧

- 每次添加、删除或更新标签后，**必须调用 `reload()`**。
- 嵌入 `UITableViewCell` 时，如果 `UITableViewAutomaticDimension` 行为异常，请在 `viewDidAppear` 中调用 `tableView.reloadData()`。
- 当视图宽度在布局时还未确定（如在自适应高度的 Cell 中），使用 `manualCalculateHeight = true` + `preferredMaxLayoutWidth`。

---

## 3.0 迁移指南

3.0 版本将所有核心源码用 Swift 重写。Objective-C 的类名、选择器和枚举值通过 `@objc(TTGXxx)` 别名完整保留 —— 现有 OC 调用点只需一处修改：将旧的 `.h` 头文件替换为 Swift 生成的伞头文件。

**OC 迁移只需改一行：**

```objc
// 旧版（2.x）
#import <TTGTags/TTGTextTagCollectionView.h>

// 新版（3.0+）
#import <TTGTags/TTGTags-Swift.h>
```

### Swift API 对照表

| 2.x / Objective-C | 3.0 Swift |
|---|---|
| `TTGTagCollectionView` | `TagCollectionView` |
| `TTGTextTagCollectionView` | `TextTagCollectionView` |
| `TTGTextTag` | `TextTag` |
| `TTGTextTagStyle` | `TextTagStyle` |
| `TTGTextTagContent` | `TextTagContent` |
| `TTGTextTagStringContent` | `TextTagStringContent` |
| `TTGTextTagAttributedStringContent` | `TextTagAttributedStringContent` |
| `TTGTagCollectionAlignment` | `TagCollectionAlignment` |
| `TTGTagCollectionScrollDirection` | `TagCollectionScrollDirection` |
| `[tag getRightfulContent]` | `tag.rightfulContent` |
| `[tag getRightfulStyle]` | `tag.rightfulStyle` |
| `[content getContentAttributedString]` | `content.contentAttributedString` |
| `[tagView addTag:]` | `tagView.add(tag:)` |
| `[tagView insertTag:atIndex:]` | `tagView.insert(tag:at:)` |
| `[tagView removeTagAtIndex:]` | `tagView.removeTag(at:)` |
| `[tagView getTagAtIndex:]` | `tagView.getTag(at:)` |
| `[tagView updateTagAtIndex:selected:]` | `tagView.updateTag(at:selected:)` |

### 3.0 其他变更

- 最低部署版本从 iOS 11 提升至 **iOS 16**
- `tagId` 自增改为线程安全（`NSLock`）
- 修复 `UIRectCorner` 按角设置的位掩码 bug
- 提取纯布局计算器 `TagCollectionLayout`（含完整单元测试）
- 新增 SPM 测试 target（`Tests/TTGTagsTests`）

### 3.1 API 新增

- 横向多行默认改为 `.rowMajor`，符合自然阅读顺序。
- `.columnMajor` 可保留旧版上下交错的列优先排列。
- `contentVerticalAlignment` 支持在固定高度标签容器中顶部、居中或底部摆放内容。
- `TextTagStyle.numberOfLines` 和 `lineBreakMode` 支持配合 `maxWidth` 或容器宽度实现多行文本标签。
- `getTag(byId:)`、`indexOfTag(byId:)`、`updateTag(byId:...)`、`scrollToTag(byId:...)` 让基于 id 的更新更直接。
- `scrollToTag(at:position:animated:)` 支持 `.nearest`、`.start`、`.center`、`.end`。

---

## 作者

zekunyan — zekunyan@163.com

## 许可证

TTGTagCollectionView 基于 MIT 许可证发布。详见 LICENSE 文件。
